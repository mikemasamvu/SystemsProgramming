#![deny(unsafe_code)]

use std::env;
use std::fs::File;
use std::io::{self, Read};
use std::collections::HashMap;
use std::panic;

// a similar 'die' macro with the C version
macro_rules! die {
    ($($arg:tt)*) => {
        eprintln!("proj3: {}", format_args!($($arg)*));
        panic!();
    };
}
struct MacroProcessor {
    macros: HashMap<String, String>,
}

impl MacroProcessor {
    // Creates a new MacroProcessor instance.
    fn new() -> Self {
        Self {
            macros: HashMap::new(),
        }
    }
}


fn main() -> io::Result<()> {
    panic::set_hook(Box::new(|_| {}));
    let args: Vec<String> = env::args().collect();
    let mut combined_content = String::new(); // String to store combined content of all files

    // Create a new HashMap to store macro names and their definitions.
    let mut processor = MacroProcessor::new();

    if args.len() == 1 {
        // No files specified, read from standard input and remove comments
        let stdin = io::stdin();
        let input_handle = stdin.lock();
        combined_content = remove_comments(input_handle)?;
        let mut dynamic_string: Vec<char> = combined_content.chars().collect();
        expand_macros_using_stack(&mut dynamic_string, &mut processor.macros);
        combined_content = dynamic_string.into_iter().collect();
    } else {
        // Process each file specified in the command line arguments
        for arg in args.iter().skip(1) {
            let file = if let Ok(file) = File::open(arg) {
                file
            } else {
                die!("Failed to open file");
            };            
            let file_content = remove_comments(file)?;
            combined_content.push_str(&file_content); // Append content of each file
        }
        let mut dynamic_string: Vec<char> = combined_content.chars().collect();
        expand_macros_using_stack(&mut dynamic_string, &mut processor.macros);
        combined_content = dynamic_string.into_iter().collect();
    }

    print!("{}", combined_content);
    Ok(())
}

fn remove_comments<R: Read>(mut source: R) -> io::Result<String> {
    let mut buffer = Vec::new();
    source.read_to_end(&mut buffer)?;
    
    let mut result = String::new();
    let mut is_comment = false;
    let mut skip_line_start = false;
    let mut is_escape_char = false;
    let mut last_char: Option<char> = None; // Initialize variable to store the last character

    for &ch in &buffer {
        let ch = ch as char;
        last_char = Some(ch); // Update last_char with the current character
        if is_comment {
            if ch == '\n' {
                is_comment = false;
                skip_line_start = true;
            }
        } else {
            if ch == '\\' && !is_escape_char {
                is_escape_char = true; // Set flag if escape character is encountered

            } else if ch == '%' && !is_escape_char {
                is_comment = true;
            } else if skip_line_start && (ch == ' ' || ch == '\t') {
                continue; // Skip leading blanks/tabs
            } else {
                skip_line_start = false;
                if is_escape_char && ch != '%' {
                    // If it was an escape character but not before '%', write the escape character
                    result.push('\\');  
                }
                result.push(ch);
                is_escape_char = false; // Reset escape character flag
            }
        }
    }
    
    if last_char == Some('\\') && result.is_empty() {
        // If the last character was a backslash, append it to the result
        result.push('\\');
    }
    Ok(result)
}

fn expand_macros_using_stack(dynamic_string: &mut Vec<char>, macros: &mut HashMap<String, String>) {
    dynamic_string.reverse(); // Reverse to simulate stack behavior

    let mut result_string = String::new();
    let mut temp_string = String::new();

    while let Some(ch) = dynamic_string.pop() {
        match ch {
            '\\' => {
                let mut result_vec: Vec<char> = result_string.chars().collect();
                if handle_escape_character(dynamic_string, &mut result_vec) {
                    result_string = result_vec.into_iter().collect();
                    continue;
                } else {
                    if dynamic_string.is_empty() {
                        result_string.push(ch);
                        continue;
                    }
                    // Extract the macro name
                    let macro_name = extract_macro_name(dynamic_string);
                    
                    if is_built_in_macro(&macro_name) {
                        // Process built-in macros, append directly to result_string for simplicity
                        let _ = process_built_in_macros(dynamic_string, &macro_name, &mut temp_string, macros);
                        for ch in temp_string.chars().rev() {
                            dynamic_string.push(ch);
                        }
                        temp_string.clear();
                    } else if let Some(macro_value) = macros.get(&macro_name) {
                        // User-defined macro, append its value to result_string
                        let value = extract_macro_arg(dynamic_string);
                        let expanded_macro = replace_placeholder(macro_value, &value);
                        let reversed_expanded_macro: String = expanded_macro.chars().rev().collect();
                        for ch in reversed_expanded_macro.chars() {
                            dynamic_string.push(ch);
                        }
                        
                    } else {
                        die!("Error: Macro not defined");
                    }
                }
                
            },
            
            _ => result_string.push(ch),
        }
    }
    *dynamic_string = result_string.chars().collect();
}

fn is_built_in_macro(macro_name: &str) -> bool {
    let built_in_macros = ["def", "undef", "include", "if", "ifdef", "expandafter"];
    built_in_macros.contains(&macro_name)
}

fn extract_macro_name(stack: &mut Vec<char>) -> String {
    let mut macro_name = Vec::new();

    while let Some(&ch) = stack.last() {
        if ch == '{' {
            break; // Stop extracting if we reach the delimiter '{'
        }

        // Check if the character is alphanumeric
        if !ch.is_alphanumeric() {
            die!("Error: Macro name contains non-alphanumeric character");
        }

        if let Some(popped_ch) = stack.pop() {
            macro_name.push(popped_ch);
        }
    }

    macro_name.iter().collect() // Reverse the order of characters to form the correct macro name
}

fn extract_macro_arg(stack: &mut Vec<char>) -> String {
    let mut macro_arg = String::new();
    let mut brace_count = 1; // Start with 1 to account for the initial opening brace
    let mut is_escaped = false; // Track if the current character is escaped

    if stack.last() == Some(&'{') {
        stack.pop(); // Remove the opening brace now that we've checked it
    } else {       
        die!("Error: Expected opening brace at the start of macro value");
    }

    while let Some(ch) = stack.pop() {
        match ch {
            '}' if !is_escaped => {
                brace_count -= 1;
                if brace_count == 0 { break; } // Stop extracting as the closing brace is reached
                else { macro_arg.push(ch); } // Include closing brace if it's part of nested structure
            },
            '{' if !is_escaped => {
                brace_count += 1;
                macro_arg.push(ch); // Include opening brace if it's part of nested structure
            },
            '\\' => {
                if !is_escaped {
                    is_escaped = true; // Mark the next character as escaped
                    macro_arg.push('\\'); // Add the backslash to the string
                } else {
                    // This means we've encountered a second backslash, so treat it as a literal
                    macro_arg.push(ch);
                    is_escaped = false; // Reset escape status
                }
            },
            _ if is_escaped => {
                // If the previous character was a backslash, add the current character as is and reset escape status
                macro_arg.push(ch);
                is_escaped = false;
            },
            _ => {
                // Normal character, just add it
                macro_arg.push(ch);
            },
        }
    }

    if brace_count != 0 {
        die!("Error: Unbalanced braces in macro argument");
    }
    macro_arg.chars().collect()
}

fn process_built_in_macros(
    source_string: &mut Vec<char>, 
    macro_name: &str, 
    temp_string: &mut String, 
    macros: &mut HashMap<String, String>
) -> Result<(), String> {
    match macro_name {
        "def" => {
            // Extract macro name and value from the stack
            let (name, value) = extract_def_details(source_string);

            // Check if the macro already exists
            if macros.contains_key(&name) {
                die!("Error: Macro already exists");
            }

            // Insert the new macro definition
            macros.insert(name, value);
            
        }
        "undef" => {
            // Extract macro name from the stack
            let name = extract_macro_arg(source_string);

            // Remove the macro if it exists
            if macros.remove(&name).is_none() {
                die!("Warning: Attempted to undefine non-existent macro");
            }
        }
        "include" => {
            let file_path = if let Ok(path) = extract_file_path(source_string) {
                path
            } else {
                die!("Error extracting file path");
            };
                
            let mut file = if let Ok(file) = File::open(&file_path) {
                file
            } else {
                die!("Error: Unable to open included file");
            };
            
            let file_contents = if let Ok(contents) = remove_comments(&mut file) {
                contents
            } else {
                die!("Error processing file contents");
            };        
        
            // Append the cleaned contents to source_string (Vec<char>) in reverse order
            for ch in file_contents.chars().rev() {
                source_string.push(ch);
            }
        },  
        "if" => {
            let (cond, then_part, else_part) = parse_if_details(source_string);
            append_conditional_result(temp_string, &cond, &then_part, &else_part);
        },
        "ifdef" => {
            let (macro_name, then_part, else_part) = parse_ifdef_details(source_string);
            let condition = macros.contains_key(&macro_name);
            append_conditional_result(temp_string, if condition { "1" } else { "" }, &then_part, &else_part);
        },
        "expandafter" => {
            let (before, after) = parse_expand_after_details(source_string);
            process_expand_after(temp_string, &before, &after, macros);
        },
        _ => panic!("Unsupported macro"),
    }

    Ok(())
}


fn extract_def_details(source_string: &mut Vec<char>) -> (String, String) {
    let mut macro_name = Vec::new();
    let mut macro_value = Vec::new();
    let mut brace_count = 1; // Start with 1 for the initial opening brace

    // Skip the initial opening brace
    if source_string.pop() != Some('{') {
        die!("Error: Expected opening brace at the start");
    }
    
    // First loop to read macro name
    while let Some(ch) = source_string.pop() {
        if ch == '}' {
            brace_count -= 1;
            break; // End of macro name
        }
        if !ch.is_alphanumeric() {
            die!("Error: Non-alphanumeric character encountered in macro name");
        }
        macro_name.push(ch);
    }
    if brace_count != 0 {
        die!("Error: Expected closing brace for macro name");
    }

    if source_string.last() != Some(&'{') {
        die!("Error: Expected opening brace at the start of macro value");
    }
    // Second loop to read macro value
    while let Some(ch) = source_string.pop() {
        match ch {
            '{' => {
                brace_count += 1;
                if brace_count > 1 {
                    // Include this brace as part of the macro value if it's nested
                    macro_value.push(ch);
                }
            },
            '}' => {
                if brace_count > 1 {
                    // Include this brace as part of the macro value if it's nested
                    macro_value.push(ch);
                }
                brace_count -= 1;
                if brace_count == 0 {
                    break; // End of macro value
                }
            },
            _ => macro_value.push(ch), // Include all other characters in the macro value
        }
    }
    if brace_count != 0 {
        die!("Error: Unbalanced braces in macro value");
    }
    
    let name: String = macro_name.into_iter().collect();
    let value: String = macro_value.into_iter().collect();

    (name, value)
}

fn extract_file_path(source_string: &mut Vec<char>) -> Result<String, &'static str> {
    let mut file_path = Vec::new();
    let mut brace_count = 0;
    let mut is_escaped = false;
    let mut prev_ch = '\0';

    // Skip the initial opening brace '{'
    if source_string.pop() != Some('{') {
        die!("Error: Expected opening brace at the start");
    }

    while let Some(ch) = source_string.pop() {
        if prev_ch == '\\' && !is_escaped {
            is_escaped = true;
        } else {
            is_escaped = false;
        }

        // Handle nested braces considering escape characters
        if !is_escaped && ch == '{' {
            brace_count += 1;
        } else if !is_escaped && ch == '}' {
            if brace_count == 0 {
                // Closing brace of file path found, stop extracting
                break;
            }
            brace_count -= 1;
        }

        if ch != '}' || brace_count > 0 || (ch == '}' && is_escaped) {
            file_path.push(ch);
        }
        prev_ch = ch;
    }

    if brace_count != 0 {
        die!("Error: Unbalanced braces in file path");
    }

    let file_path_string: String = file_path.into_iter().collect();

    Ok(file_path_string)
}

fn parse_if_details(source_string: &mut Vec<char>) -> (String, String, String) {
    let cond = extract_conditional_part(source_string);      
    let then_part = extract_conditional_part(source_string);
    let else_part = extract_conditional_part(source_string);
    (cond, then_part, else_part)
}

fn extract_conditional_part_name(source_string: &mut Vec<char>) -> String {
    let mut part = Vec::new();
    let mut brace_count = 0;

    while let Some(ch) = source_string.pop() {
        match ch {
            '{' if brace_count == 0 => {
                // Skip the first opening brace
                brace_count = 1;
                continue;
            },
            '{' => brace_count += 1,
            '}' => {
                brace_count -= 1;
                if brace_count == 0 {
                    // End of this conditional part
                    break;
                }
            },
            _ if brace_count > 0 => {
                if !ch.is_alphanumeric() {
                    die!("Error: Non-alphanumeric character found in conditional part name");
                }
                part.push(ch);
            },
            _ => (),
        }
    }

    if brace_count != 0 {
        die!("Error: Unbalanced braces in if macro");
    }

    part.iter().collect()
}

fn extract_conditional_part(source_string: &mut Vec<char>) -> String {
    let mut part = Vec::new();
    let mut brace_count = 0;
    let mut first_brace_skipped = false;
    let mut prev_char: Option<char> = None; // Variable to keep track of the previous 

    if source_string.last() != Some(&'{') {
        die!("Error: Expected opening brace at the start of macro value");
    }

    while let Some(ch) = source_string.pop() {
        match ch {
            '{' if prev_char != Some('\\') => { // Check if '{' is not escaped
                if !first_brace_skipped {
                    // Skip only the first opening brace
                    first_brace_skipped = true;
                    prev_char = Some(ch);
                    continue;
                }
                brace_count += 1;
            },
            '}' if prev_char != Some('\\') => { // Check if '}' is not escaped
                if brace_count == 0 {
                    // If brace_count is 0, it means this closing brace matches the first opening brace, so stop.
                    break;
                }
                brace_count -= 1;
            },
            _ => {}
        }

        // Start appending after skipping the first opening brace
        if first_brace_skipped {
            part.push(ch);
        }

        prev_char = Some(ch); // Update the prev_char with the current character
    }
    
    if brace_count != 0 || !first_brace_skipped {
        die!("Error: Unbalanced braces in conditional part");
    }

    part.iter().collect()
}

fn append_conditional_result(dynamic_string: &mut String, condition: &str, then_part: &str, else_part: &str) {
    if !condition.is_empty() {
        // Condition is true (non-empty for `if`, "1" for `ifdef`)
        dynamic_string.push_str(then_part);
    } else {
        // Condition is false (empty string)
        dynamic_string.push_str(else_part);
    }
}

fn parse_ifdef_details(source_string: &mut Vec<char>) -> (String, String, String) {
    let macro_name = extract_conditional_part_name(source_string); // Macro name
    let then_part = extract_conditional_part(source_string);  // Then-part
    let else_part = extract_conditional_part(source_string);  // Else-part
    (macro_name, then_part, else_part)
}

fn parse_expand_after_details(source_string: &mut Vec<char>) -> (String, String) {
    let mut before = Vec::new();
    let mut after = Vec::new();
    let mut brace_count = 1; // Start counting from the opening brace

    // Pop the initial '{' since it's already checked
    if source_string.pop() != Some('{') {
        die!("Error: Expected opening brace at the start of macro value");
    }

    // Extract the "before" part
    while let Some(ch) = source_string.pop() {
        match ch {
            '{' => {
                if brace_count > 0 { // Include all '{' except the very first
                    before.push(ch);
                }
                brace_count += 1;
            },
            '}' => {
                brace_count -= 1;
                if brace_count == 0 { // End of "before"
                    break;
                } else {
                    before.push(ch); 
                }
            },
            _ => before.push(ch),
        }
    }

    // Reset brace_count for the "after" part
    brace_count = 1; 

    // Check if there's another part to extract
    if source_string.pop() == Some('{') {
        // Extract the "after" part
        while let Some(ch) = source_string.pop() {
            match ch {
                '{' => {
                    if brace_count > 0 { 
                        after.push(ch);
                    }
                    brace_count += 1;
                },
                '}' => {
                    brace_count -= 1;
                    if brace_count == 0 { // End of "after" part
                        break;
                    } else {
                        after.push(ch); 
                    }
                },
                _ => after.push(ch),
            }
        }
    } else {
        die!("Error: Missing opening bracket for the after part");
    }

    let before_str: String = before.into_iter().collect();
    let after_str: String = after.into_iter().collect();

    (before_str, after_str)
}

fn process_expand_after(dynamic_string: &mut String, before: &str, after: &str, macros: &mut HashMap<String, String>) {

    // Convert `after` from &str to Vec<char> for macro expansion
    let mut after_vec: Vec<char> = after.chars().collect();
    
    // Expand macros within `after_vec`
    expand_macros_using_stack(&mut after_vec, macros);

    // Convert `after_vec` back to a String
    let expanded_after: String = after_vec.into_iter().collect();

    // Append `before` directly to `dynamic_string`.
    dynamic_string.push_str(before);

    // Append the expanded `after` to `dynamic_string`.
    dynamic_string.push_str(&expanded_after);
}

fn handle_escape_character(dynamic_string: &mut Vec<char>, result_string: &mut Vec<char>) -> bool {
    if dynamic_string.is_empty() {
        // Nothing to handle if dynamic_string is empty
        return false;
    }

    // Get the last character from dynamic_string
    if let Some(ch) = dynamic_string.pop() {
        if ['\\', '#', '%', '{', '}'].contains(&ch) {
            result_string.push(ch);
            true
        } else if ch.is_ascii_alphanumeric() {
            // Append the character back at the end of dynamic_string
            dynamic_string.push(ch);
            false
        } else {
            result_string.push('\\');
            result_string.push(ch);
            true
        }
    } else {
        false
    }
}

fn replace_placeholder(macro_definition: &str, replacement: &str) -> String {
    let mut result = String::new();
    let mut chars = macro_definition.chars().peekable();
    let mut is_escaped = false;

    while let Some(ch) = chars.next() {
        match ch {
            '\\' if !is_escaped => {
                is_escaped = true;
            }
            '#' if is_escaped => {
                // If # is escaped, add it as a literal character
                result.push('#');
                is_escaped = false; // Reset escape status
            }
            '#' => {
                // Unescaped #, replace it
                result.push_str(replacement);
            }
            _ if is_escaped => {
                // If any character other than # is escaped, add the \ and the character
                result.push('\\');
                result.push(ch);
                is_escaped = false;
            }
            _ => {
                // Normal character, just add it
                result.push(ch);
            }
        }
    }

    // Handle the case where the last character is an escape character
    if is_escaped {
        // If the last character is a \, add it to the result
        result.push('\\');
    }

    result
}



