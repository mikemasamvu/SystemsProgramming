#!/bin/bash


# COMPREHENSIVE TESTING SUITE for CPSC 323 Proj 4
# AUTHOR: Eric Yoon '27
# LICENSE: Public Domain



# Do some work on assets
echo "can't touch this" > tests/assets/inaccessible_file.txt
chmod -rwx tests/assets/inaccessible_file.txt

# Make the student's implementation
echo "Your code is in the oven..."
make clean > /dev/null
make > /dev/null 2> make.out
if grep -q "warning" make.out; then
    echo "FAIL: Oopsie woopsie! You did a hecky-wecky! There are warnings :3"
fi
rm make.out

# Get the correct output from reference implementation
echo "Running reference implementation. This may take a while due to sleep commands"
/c/cs323/proj4/Bash < tests/test.in > tests/test.out 2> tests/test.err.out

# Get the output from the student's implementation
echo "Running your implementation. This may take a while due to sleep commands. We are also running Valgrind and will report any memory leaks."
valgrind --leak-check=full --log-file="tests/valgrind.out.student" --error-exitcode=1337 ./Bash < tests/test.in > tests/test.out.student 2> tests/test.err.out.student

# Parse Valgrind report
if grep -q "lost:" "tests/valgrind.out.student"; then
    lost_bytes=$(grep "lost:" "tests/valgrind.out.student" | awk -F: '{print $2}' | awk '{print $1}')
    for num in $lost_bytes; do
        if [ "$num" -ne "0" ]; then
            echo "FAIL: Memory leak detected: lost $num bytes. Check tests/vagrind.out.student for more details."
        fi
    done
fi

# Diff
diff tests/test.out tests/test.out.student

# Check right # of stderr lines printed
if [ "$(wc -l < tests/test.err.out)" -ne "$(wc -l < tests/test.err.out.student)" ]; then
    echo "FAIL: The number of lines in your STDERR differs from the number of lines in the reference's STDERR."
fi


echo "If no output, then all tests passed. Otherwise, see diff for errors."

# Clean up
rm -f tests/assets/inaccessible_file.txt