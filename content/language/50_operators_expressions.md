---
title: "Operators and Expressions"
slug: "operators-expressions"
draft: false
weight: 50
---

## Arithmetic Operators

## Comparison Operators

## Logical Operators

## Reference Operator

The `&` operator creates a local reference pointer for a some data structure.

## make

The `make` operator creates objects or arrays on the heap.

```go
let ptr = make<T>()
```

The above statements creates an object of type `T` on the stack and returns an owning pointer to it.

```go
let slice = make<T>(100, 200)
```

The above statement creates an array with elements of type `T` on the stack.
The array has a size of 200 elements.
The `make` expression returns a slice with length 100 that points to this array.
Hence, `cap(slice)` would return 200 and `len(slice)` would return 100.

## cap

The `cap` operator can be applied to all slices.
It returns the size of the underlying array.
The type of the return value is `int`.

```go
let slice = [...100][:5]    // The slice has length 5,
                            // but the underlying array has the size 100.
let c = cap(slice)          // c is 100
```
## len

The `len` operator can be applied to slices, arrays and strings.
In the case of strings it returns the size of the string in chars.
It does not return the number of UTF-8 runes encoded in the string.
The type of the return value is `int`.

```go
len("Hello")    // This is 5
```

## append

The `append` statement appends elements to a slice.
If the array underlying the slice is not large enough, a new array is allocated, the data copied and the old array released.
Therefore, `append` can only operate on owning pointers.

The first argument is the slice.
Append changes the size of this slice.
Therefore, the slice expression must be mutable.
All other arguments are appended to the slice.

```go
var slice = [0, 1, 2, 3]
append(slice, 4, 5)
// Prints 6
println(len(slice))
```

Slices prefixed with `...` can be used as arguments to `append` as well.
In this case the slices are appended by copying the slices to the destination slice.

```go
var s1 []byte = [1, 2, 3]
let s2 []byte = [4, 5, 6]
let s3 []byte = [7, 8]
append(s1, ...s2, ...s3, 9)
// Prints 9 1 2 3 4 5 6 7 8 9
println(len(s1), s1[0], s1[1], s1[2], s1[3], s1[4], s1[5], s1[6], s1[7], s1[8])
```

Because `append` is a statement, it returns nothing.

## push

The `push` statement is similar to `append`.
The only difference is that the program aborts in case the underlying array is not large enough.
`push` is potentially faster than `append`, because no code is generated to handle the case that the array is too small.

Furthermore, `push` is available in environments without heap, whereas `append` requires a heap.

## tryPush

The `tryPush` operator is similar to `push`.
However, it returns a `bool`.
If the underlying array is too small, `tryPush` returns false.
Otherwise it returns true.

## pop

The 'pop' operator returns the last element of a slice.
This last element is filled with the default value, i.e. zeros.

```go
let s []byte = [1, 2, 3]
// Prints 3
println(pop(s))
```

The length of the slice is reduced by one.
Therefore the slice must be mutable.
If the slice is empty, the program aborts.

If the slice contains elements with owning pointers then `pop` returns ownership of the objects being pointed to.
Thus, `pop` behaves like taking the last element of a slice via `take` and then shrinking the slice via the `slice` operator.
However, `pop` is faster and more concise.

## copy

The `copy` statement copies one slice onto another slice.
Only pure values can be copied.
The first operator is the destination, followed by the source.

```go
let slice = [1, 2, 3, 4, 0]
copy(slice[1:], slice[0:4])
```

Source and destination may overlap as shown in the example above.
The amount of elements copied is the minimum of the length of both slices.

Because `copy` is a statement, it returns nothing.

## move

The `move` statement is comparable to `copy`.
But instead of copying the data to a new location, it moves it to a new location.
The source is filled with zeros afterwards.
If source and destination overlap, only the part of source not covered by the destination is filled with zeros.

Unlike `copy`, the `move` statement works even for values containing pointers, because no ownership is copied by moving pointers inside an array.
In addition to filling the source with zeros, the pointers are destructed.

```go
let s []byte = [1,2,3,4,5]
// s[1:] is the destination and s is the source
move(s[1:], s)
// Prints 0, 1, 2, 3, 4
println(s[0], s[1], s[2], s[3], s[4])
```

## clone

The `clone` operator creates a copy of a slice and returns a unique slice.
The slice elements must be pure values, i.e. they must not contain any pointers.

The purpose of `clone` is to gain speed, because internally the compiler can copy the slice in steps of word size, i.e. 8 bytes in one step.
The same procedure in Fyr would have to copy the slice element by element.
In the case of a slice of bytes, each step could only copy one byte.

If slice elements contain pointers, just copying the data over is not sufficient.
The programmer must decide how to treat ownership of the objects pointed to.
Therefore, the compiler cannot clone such slices.

## slice

The `slice` statement changes a slice.
A slice is a pointer to an underlying array with a range definition.
The `slice` statement changes this range definition.
The resulting range must be covered by the underlying array or the program aborts.

The `slice` statement has three arguments: `slice(s, offset, len)`.
The first is the slice to change.
This slice must be mutable.
The second is an offset relative to the current range start.
This offset might be negative.
The third is the new length of the slice.

```go
let s []byte = [1,2,3,4,5,6]
var s2 = s[2:]
slice(s2, -1, 3)
// Prints 3, 2, 3, 4
println(len(s2), s2[0], s2[1], s2[2])
```

In the above example, the slice `s` defines the range `[2:6]`.
The slice `s2` has the range `[2-1:2-1+3]`, e.g. `[1:4]`, and therefore the length 3 as demanded.

## Slice Expressions

## Index Expressions

## sizeOf

The `sizeOf` operator returns the number of bytes required for storing a certain type in memory.
The type of the return value is `int`.

```go
sizeOf<int64>   // This is 8
```

## alignedSizeOf

The `alignedSizeOf` operator returns the number of bytes required for storing a certain type in an array includeing alignment.
The returned size is always a multiple of the alignment.
The type of the return value is `int`.

```go
type Odd struct {
    a int64
    b byte
}

alignedSizeOf<int64>    // This is 8
alignedSizeOf<Odd>      // This is 16, because Odd has a size of 9
                        // but needs an alignment of 8.
```

## min and max

For every numerical type, the template functions min<T> and max<T> denote the minimum and maximum value that can be stored in a variable of type `T`.
For example `min<uint64>` is `0`.

## take

The `take` operator can be used on expression with a type containing pointers or references to take these pointers away.
`take` copies the value of its expression, assigns a default value to its expression, and returns the copied value.
The only expression allowed for take are variables, member access and array/slice access.

```go
type struct List {
    next *List
}

var x *List = ...
var y = take(x.next)
```

In the above example, `x.next` is a pointer.
After `take(x.next)` executed, the value of `x.next` is set to `null`.
The previous value is assigned to `y` instead.
Thus, using `take` it is possible to transfer ownership of pointer values.

`take` can be used on variable expressions, but most of the time it can be omitted, resulting in slightly better performance.

```go
let y *List = take(x)
let z *List = x
```

In the case of `y = take(x)` the `null` value is written to `x`.
In the case if `z = x` the value if `x` is left unchanged, but the compiler does not allow further access to `x`.
Fyr enforces that there is at most one owning pointer.
This can be achieved by copying the owning pointer and then assigning zero to the original pointer or by just copying and disallowing access to the original pointer.

## Operator Precedence