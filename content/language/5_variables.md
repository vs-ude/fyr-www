---
title: "Variables"
draft: false
weight: 5
---

Fyr has a few small peculiarities in the approach to variables.

However, you are still very flexible in their use:

```go
var x := 5
x, y := split(x)
y = inc(y)
```

## Assignment

TODO: `let`, `var`, single/multiple assignment

As you can see above, Fyr uses the _walrus operator_ (`:=`).
This is used in the assignment of a variable.
If any of variables on the left has not yet been declared, it should be used to do so in the process of assigning it.

## Mutability

Variables defined in Fyr are immutable by default.
This is done to prevent accidental modification of values.

This will not work:

```go
var x int := 3
x = multiply(x, 3)
```

If a variable _needs_ to be modifiable, you can define this using the `mut` keyword.
We advise that you make use of it sparsely.

This _will_ work:

```go
var x mut int := 3
x = multiply(x, 3)
```


