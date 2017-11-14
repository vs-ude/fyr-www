---
title: "Language"
date: 2017-11-13T21:45:04+01:00
draft: false
weight: 10
---

The syntax of Fyr is inspired by _GO_, _TypeScript_ and _C++_.

```go
func main() int {
    var a = 21*2
    return a
}
```

Fyr performs type inference in many places.
In the above example, `a` is implicitly typed as `int`, because integer constants are by default of type `int`.

Fyr does not require `;` at the end of an statement.

{{% notice note %}}
It is valid, but not idiomatic, to terminate statements with `;`.
Future versions of the language might remove `;` entirely.
{{% /notice %}}

## Datatypes

Fyr supports the following data types:

```go
uint8, uint16, uint32, uint64
int8, int16, int32, int64
float, double
byte                            // An alias for uint8
bool                            // false or true
string                          // Strings are immutable
rune                            // A 32-bit unicode character
int                             // An alias for int32
uint                            // An alias for uint32
```

Since WebAssembly does use a 32-bit address space by default, Fyr treats `int` as an alias for `int32`. When compiling for other targets than WebAssembly MVP, `int` can be an alias for `int16` or `int64`.

{{% notice note %}}
The types `float` and `double` might be renamed to `float32` and `float64` in a future version of the language.
{{% /notice %}}

All data types have a default value of 0.
If a variable is not explicitly initialized, Fyr ensures that the data type is initialized with zeros.

### Strings

Fyr strings are immutable and store data in UTF-8 encoding.
The index operator returns bytes of this UTF-8 encoding.

To access the single unicode characters (of type `rune`) encoded in the UTF-8 string, a `for` loop can be used.

```go
func print(i int, r rune) {
    ...
}

export func main() int {
    var str = "Übung"
    for(var i, r in str) {
        print(i, r)         // Loops 5 times
    }
    return str.length       // Returns 6
}
```

The above example would call `print` 5 times although the string is 6 bytes long.
The first two bytes together represent the rune `'Ü'`.

There are several ways of denoting runes:

```
'a'             // value 0x61
'\a'            // value 7
'\b'            // value 8
'\t'            // value 9
'\n'            // value 10
'\v'            // value 11
'\f'            // value 12
'\r'            // value 13
'\\'            // value 0x5c
'\''            // value 0x27
'\x3f'          // value 0x3f
'\u123f'        // value of 0x123f
'\U0012345f'    // value of 0x12345f
```

### Arrays and Slices

Arrays are value types of fixed length.
When accessing an array, Fyr checks that the index if within the bounds of the array.
An out-of-bound index causes the application to abort.

```go
func search(arr [32]int, val int) int {
    for(var i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    var arr [32]int
    arr[0] = 123
    arr[1] = 234
    return search(arr, 234)
}
```

Note, that arrays (like all other data types) are initialized with zero.
Only the first two elements are set to a non-zero value.

In the above example, the array is copied when `search` is called.
This is inefficient, and the search function works only for arrays of a fixed size.
Therefore, Fyr supports slices, which are essentially pointers to an underlying array.

```go
func search(arr &[]int, val int) int {
    for(var i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    var arr [4]int = {123, 234, 345, 456}
    return search(arr[:], 234)
}
```
The above example uses an array initialization, which is just a shortcut to populate an array.

The slice operator `[:]` creates a slice which points to the underlying array and contains all elements of `arr`.
For example, `[2:]` would include all elements of the array starting by the array element at position 2.

An access to a slice checks tha the index is within the bounds of the slice.
Out-of-bound access aborts the application.

A slice is denoted as `[]int`.
However, in this example the search function accepts a reference slice of type `&[]int`.
When a function accepts a reference type as a parameter, the compiler verifies that the function will not store any pointers to this data that live longer than the function invocation.
This allows `main` to hand out a slice to an array which is on the stack, because Fyr can verify that no pointers to `arr` live longer than the stack frame in which `arr` is stored.

If `search` accepts `[]int` instead, `main` must allocate the array on the heap, because otherwise Fyr cannot ensure that there are no dangling pointers to the array after main returns.
Like _GO_, Fyr features pointers and is memory safe.

```go
func search(arr []int, val int) int {
    for(var i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    var arr = &[4]int{123, 234, 345, 456}
    return search(arr, 234)
}
```

In the above example, `&[4]int` allocates the array on the heap and returns a slice to it.
Hence, `arr` is now a slice type.
In addition, an array initializer is used to populate the array.
Arrays allocated on the heap are subject to garbage collection.

### Tuples

### Or Type

## Structs

## Functions

## Member Functions

## Interfaces

### And Type

## Control Structures

### If

### For

## Templates

### Template Types

### Template Functions