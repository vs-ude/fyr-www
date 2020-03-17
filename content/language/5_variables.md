---
title: "Variables"
draft: false
weight: 5
---

In Fyr, all variables must be declared and initialized before they can be used.
Variables can be declared with `var` or the _walrus operator_ `:=`.

```go
var x = 5
x, y := split(x)
y = inc(y)
```

## Assignment

TODO: `let`, `var`, single/multiple assignment

As you can see above, Fyr offers the _walrus operator_ (`:=`).
On the left of the operator, there must be at least one variable that has not yet been declared.
In the example above, `x` has been declared already, but `y` has not.
In such situations the walrus operator is more convenient as shown by the following two examples:

```go
// With walrus operator
var x = 5
x, y := split(x)
```

```go
// Without walrus operator
var x = 5
var y int
x, y = split(x)
```

It is an error if the left side features only variables that have been declared already, because in this case the `=` operator is sufficient and must be used.

## Mutability

Variables declared with `var` or `:=` are mutable, that means their value might be changed.
Constants defined with `let` are immutable.

This will not work:

```go
let x = 5
x = 6
```

The difference between `let` and `var` is only important for the values stored in these variables or constants.
It has no impact on the mutability of objects referenced via pointers.

Pointer types defined in Fyr are immutable by default.
This is done to prevent accidental modification of values.

This will not work:

```go
var ptr *int = new int(2)
*ptr = 8
```

If a pointer _needs_ to be modifiable, you can define this using the `mut` keyword.
We advise that you make use of it sparsely.

This _will_ work:

```go
var ptr mut *int = new int(2)
*ptr = 8

let ptr2 mut *int = new int(2)
*ptr2 = 8

```

In the above example `ptr2` is a constant, i.e. it will always point to the same location in memory.
However, the location it is pointing to is marked as mutable.
Therefore `ptr2` cannot be assigned to, but the location it is pointing to can be dereferenced and assigned.
