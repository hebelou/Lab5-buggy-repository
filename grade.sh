CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission > git-output.txt
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]]
then 
    cp student-submission/ListExamples.java grading-area
    cp TestListExamples.java grading-area
    cp -r lib grading-area
else 
    echo "Missing necessary files"
    exit 1
fi
echo "continue"

cd grading-area

javac -cp $CPATH *.java 2> tmp
if [ $? -ne 0 ]
then
    echo "Compilation error"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
echo $lastline
status=$(echo $lastline | awk -F'[, ]' '{print $1}')
success="OK"
if [ $status != $success ]
then
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
else
    failures=0
    tests=$(echo $lastline | grep -o '[0-9]*' | head -1)
fi
successes=$(( tests - failures ))
echo “Your score is $successes / $tests ”

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
