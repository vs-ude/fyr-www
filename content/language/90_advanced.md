---
title: "Advanced Topics"
slug: "advanced"
draft: false
weight: 90
---

## Unsafe Pointers

Fyr supports unsafe pointers, which are comparable to C-pointers.
They have pointer arithemtics and can be casted freely.
Consequently, unsafe pointers are as dangerous as C-pointers since the compiler does not provide any checks.
Idiomatic Fyr code does not use unsafe pointers at all.
Unsafe pointers are used for low-level programming or when interfacing with C code.

```go
let ptr #int32 = 0x20
*ptr = 1
ptr++
*ptr = 2
```