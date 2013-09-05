#!/bin/bash -ex

rm -rf environment-test
mkdir -p environment-test/node_modules
cd environment-test

npm install express coffee-script
node_modules/express/bin/express --version
echo 'console.log("hello")' | node_modules/coffee-script/bin/coffee

echo 'console.log("hello")' | node

rvm use 1.8.7
ruby --version | grep 1.8.7
echo 'puts "hello"' | ruby

rvm use 1.9.3
ruby --version | grep 1.9.3
echo 'puts "hello"' | ruby

python --version
echo 'print "hello"' | python

echo success
