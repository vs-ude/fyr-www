---
title: "Language"
draft: false
weight: 10
---

Here is the obligatory hello world in Fyr.

```go
func Main() {
    println("Hello World")
}
```

The syntax of Fyr is mainly inspired by _GO_, and in selected places by _TypeScript_ and _C++_.

```go
func compute() int {
    a := 21*2
    return a
}
```

Fyr performs type inference in many places.
In the above example, `a` is implicitly typed as `int`, because integer constants are by default of type `int`.

Fyr does not require `;` at the end of an statement.
Furthermore, Fyr code is encoded in UTF-8.

{{% notice note %}}
It is valid, but not idiomatic, to terminate statements with `;`.
Future versions of the language might remove `;` entirely.
{{% /notice %}}