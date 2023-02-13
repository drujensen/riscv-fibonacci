# Recursive Fibonacci Benchmark running on RISC-V

Languages: Assembly, C, C++, Go, Rust, Java, NodeJS, Ruby, Python3, Perl

The code performs a recursive fibonacci to the 42th position with the result of 267,914,296.

Fibonacci can be written many different ways.  The goal of this project is to compare how each language handles the exact same code.

Here is the Ruby version:
```
def fib(n)
  return n if n <= 1
  fib(n - 1) + fib(n - 2)
end

puts fib(42)
```

Here is the Python version:
```
def fib(n):
  if n <= 1: return n
  return fib(n - 1) + fib(n - 2)

print(fib(42))
```

Too keep a level playing field, only common "release" flags are used in the compilation step.  This allows for compiler optimizations like inlining and constant propogation but removes anything considered dangerous i.e. bypassing out of bounds checks.

All tests are run on:
 - Mac M1 Pro 32GB (Host)
 - Docker Desktop 4.16.2
 - Docker Ubuntu 22.04 RISC-V 64bit Image

## How to run them

You can run the tests using Docker:
```
docker run --platform linux/riscv64 -it drujensen/riscv-ubuntu bash
```

Then clone the repo and run the tests:
```
git clone https://github.com/drujensen/riscv-fibonacci.git
cd riscv-fibonacci
./run.sh
```

# Results

Last benchmark was ran on February 12, 2023

## Natively compiled, statically typed

| Language | Total | Compile | Time, s | Run | Time, s | Ext |
|----------|-------|---------|---------|-----|---------|-----|
| C |    2.228 | gcc -O3 -o fib fib.c |    0.821 | ./fib |    1.407 | c |
| C++ |    2.343 | g++ -O3 -o fib fib.cpp |    0.927 | ./fib |    1.416 | cpp |
| Go |    8.689 | go build fib.go |    0.889 | ./fib |    7.800 | go |
| Rust |   10.766 | rustc -C opt-level=3 fib.rs |    3.454 | ./fib |    7.312 | rs |

## VM compiled bytecode, statically typed

| Language | Total | Compile | Time, s | Run | Time, s | Ext |
|----------|-------|---------|---------|-----|---------|-----|
| Java |    9.231 | javac Fib.java |    3.740 | java Fib |    5.491 | java |

## VM compiled before execution, mixed/dynamically typed

| Language | Time, s | Run | Ext |
|----------|---------|-----|-----|
| Ruby (jit) |   42.278 | ruby --jit fib.rb | rbjit |
| Node |  208.353 | node fib.js | js |

## Interpreted, dynamically typed

| Language | Time, s | Run | Ext |
|----------|---------|-----|-----|
| Ruby |  197.762 | ruby fib.rb | rb |
| Python3 |  651.567 | python3 fib.py | py |
| Perl |  762.013 | perl fib.pl | pl |

# Contributing

If you would like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

To add other languages, please add them to the Dockerfile found here:

https://github.com/drujensen/riscv-ubuntu/blob/main/Dockerfile


# License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
