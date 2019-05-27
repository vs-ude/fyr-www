---
title: "Control Structures and Statements"
slug: "control-statements"
draft: false
weight: 40
---

## Assignment

## Increments

## if

## for

## println

`println` is a builtin function that can be used to write debug output.
The function accepts any number of arguments of any type.
The behavior of `println` is platform-specific.
Therefore, it should only be used for debugging, but it should never be part of shipped code.

```go
println("Hello, two square is", 2 * 2)
```

`println` uses platform-specifc support libraries to print integers, floats etc.
It does not use the Fyr standard library.
When targeting C, `println` will use `printf` internally.
In the case of WebAssembly it could choose to call `console.log`.
