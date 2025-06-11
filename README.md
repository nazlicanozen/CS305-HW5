# Scheme Interpreter

## Overview

This project is a Scheme interpreter implemented in the Scheme language.

## Features

The interpreter supports the following key features:

- **Arithmetic operations**: `+`, `-`, `*`, `/` with left associativity for `-` and `/`
- **Variables**: Define and use variables with `(define IDENT expr)`
- **Let expressions**: Local bindings using `(let ((var1 val1) (var2 val2) ...) expr)`
- **Lambda expressions**: First-class functions with support for closures
- **Function applications**: Apply both named and anonymous functions
- **Error handling**: Detect and report syntax and semantic errors, then continue REPL interaction

## Usage

- Start the interpreter by calling the repl procedure:  
  ```scheme
  ]=> (repl)
  ```
- Use the `repl>` prompt to enter expressions.
- Outputs are displayed with the prefix `repl:`.

Example interaction:
```scheme
repl> (define x 5)
repl: x

repl> ((lambda (n) (+ n 2)) 5)
repl: 7

repl> (define incx (lambda (n) (+ n x)))
repl: incx

repl> (incx 1)
repl: 6
```

## Requirements

- Only the specified subset of Scheme is supported.
- Input syntax must follow the provided grammar precisely.
- Variables in `let` must be uniquely bound.
- Division by zero and unary operations are not tested.
