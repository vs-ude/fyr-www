---
title: "Templates"
slug: "templates"
draft: false
weight: 60
---

## Template Types

## Template Functions

### Conditional compilation

Writing templates for numerical types poses a challenge, because some types do not support the unary `-` operator.
Thus, the following example will not compile for unsigned types, because `-i` is not allowed:

```go
func dummy<T>(T i) {
    i = -i
}
```

However, the following example compiles for unsigned types:

```go
func itoa<T>(T i) {
    if (i < 0) {
        i = -i
    }
}
```

Before the compiler performs a type check on `i = -i`, it determines that `i < 0` must be false for unsigned types.
If-clauses which are known to be never executed are not compiled and especially: they are not even type checked.
Hence, the typechecker will never see `i = -i` in the unsigned case and therefore it compiles.
This is in effect a conditional compilation, where some if-clause is ignored based on a type parameter `T`.

In the above example the if-clause executes if `T` is signed and `i < 0`.
To execute a clause only if `T` is signed, we can write:

```go
func atoi<T>() {
    if (min<T> < 0) {

    }
}
```

In this example the compiler infers that `min<T> < 0` is true if and only if `T` is signed and will perform conditional compilation.
