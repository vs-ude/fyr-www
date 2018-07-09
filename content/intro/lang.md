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
Furthermore, Fyr code is encoded in UTF-8.

{{% notice note %}}
It is valid, but not idiomatic, to terminate statements with `;`.
Future versions of the language might remove `;` entirely.
{{% /notice %}}

## Datatypes

Fyr supports the following data types:

```go
uint8, uint16, uint32, uint64   // Unsigned integers of fixed size
int8, int16, int32, int64       // Signed integers of fixed size
float, double                   // 32bit and 64bit floating point numbers
byte                            // Platform dependend
                                // Smallest addressable unsigned unit
                                // Usually 8 bits
char                            // Platform dependend
                                // Smallest addressable signed unit
                                // Usually 8 bits
bool                            // A boolean of 8 bits size that is false or true
string                          // Immutable UTF-8 strings
rune                            // A 32-bit unicode character
int                             // Platform dependend
                                // Signed value, usually 32 bits
uint                            // Platform dependend
                                // Signed value, usually 32 bits
```

WebAssembly uses a 32-bit address space by default, hence Fyr treats `int` as an alias for `int32` in WebAssembly. On Arduinos, `int` is an alias for `int16`. When compiling for other targets than WebAssembly MVP, `int` can be an alias for `int16` or `int32` or `int64`.

{{% notice note %}}
The types `float` and `double` might be renamed to `float32` and `float64` in a future version of the language.
{{% /notice %}}

All data types have a default value of 0.
If a value is not explicitly initialized, Fyr ensures that it is initialized with zeros.

Fyr does not perform any implicit type conversion.
Explicit casts are required as in the following example:

```go
var x int32 = 42
var y int16 = <int32>x
```

All numeric types including `bool` can be casted into each other.

### Numeric Literals

Boolean literals are `true` and `false`.

Integer literals are either written as decimals as in `1234` or in hexadecimal as in `0xffef`.

Floating point literal are of the form `12.34` or `.34`.

### Strings and Runes

Fyr strings are immutable and store data in UTF-8 encoding.
Strings are stored as pointers to string data.
Hence, string assignment is very fast.
String comparison, however, compares the value of the strings these internal pointers are pointing at.

The index operator `[index]` returns bytes of the UTF-8 encoding.

To obtain the byte count of a string, call its `len()` member function.
To access the single unicode characters (of type `rune`) encoded in the UTF-8 string, a `for` loop can be used.

```go
func print(let i int, r rune) {
    ...
}

export func main() int {
    var str = "Übung"
    for(let i, r in str) {
        print(i, r)         // Loops 5 times
    }
    return str.len()        // Returns 6
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
'\"'            // value 0x22
'\x3f'          // value 0x3f
'\u123f'        // value of 0x123f
'\U0012345f'    // value of 0x12345f
```

Runes can be used inside a string as well as in `"\xdcbung"` which is equivalent to `"Übung"`.

Strings can be coverted to `[]byte` and the other way round as in the following example:

```go
var arr []byte = <[]byte>"Hallo"
var str string = <string>arr
```

Note that this conversion implies a copy because strings are immutable and slices are not.

### Pointer Type

### Arrays and Slices

Arrays are value types of fixed length.
Assigning one array to another results in a copy of this array.
When accessing an array, Fyr checks that the index is within the bounds of the array.
An out-of-bound index causes the application to abort.

```go
func search(arr [4]int, val int) int {
    for(let i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    let arr [4]int
    arr[0] = 123
    arr[1] = 234
    return search(arr, 234)
}
```

Note that arrays (like all other data types) are initialized with zero.
In the above example, only the first two elements are set to a non-zero value.

In the above example, the array is copied when `search` is called.
This is inefficient, and the search function works only for arrays of a fixed size.
Therefore, Fyr supports slices, which are essentially pointers to an underlying array.

```go
func search(arr &[]int, val int) int {
    for(let i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    let arr [4]int = [123, 234, 345, 456]
    return search(arr[:], 234)
}
```

The above example uses an array initialization, which is just a shortcut to populate an array.

The slice operator `[:]` creates a slice which points to the underlying array and contains all elements of `arr`.
For example, `[2:]` would include all elements of the array starting by the array element at position 2.

An access to a slice checks that the index is within the bounds of the slice.
Out-of-bound access aborts the application.

A slice is denoted as in `[]int`.
Note that slices are pointers to an array.
Assigning one slice to another just assigns this internal pointer, but the array is not copied.

However, in this example the search function accepts a local reference slice of type `&[]int`.
When a function accepts a local reference type as a parameter, the compiler verifies that the function will not store any pointers to this data that live longer than the function invocation.
This allows `main` to hand out a slice to an array which is on the stack, because Fyr can verify that no pointers to `arr` live longer than the stack frame in which `arr` is stored.

If `search` accepts `[]int` instead, `main` must allocate the array on the heap, because otherwise Fyr cannot ensure that there are no dangling pointers to the array after main returns.
Like _GO_, Fyr features pointers and is memory safe.

```go
func search(arr []int, val int) int {
    for(let i, v in arr) {
        if (v == val) {
            return i
        }
    }
    return 0
}

export func main() int {
    let arr []int = [123, 234, 345, 456]
    return search(arr, 234)
}
```

In the above example, `[123, 234, 345, 456]` allocates the array on the heap and returns a slice to it.
Hence, `arr` is now a slice type.
In addition, an array initializer is used to populate the array.

Due to type inference, the following two statements are equivalent:

```go
let arr []int = [123, 234, 345, 456]
let arr = [123, 234, 345, 456]
```

To allocate a slice of variable size, use the `...` operator:

```go
let a = 100
let arr []int = [...a]                          // len 100
let arr2 []int = [123, 234, 345, 456, ...a]     // len 104
```

The length of an array, string or slice can be obtained with the `len` operator.
The length of the array a slice is pointing to can be obtained with the `cap` operator.
The elements of a slice can be copied using the `clone` operator.
It returns a slice which points to the cloned array.
The `append` operator can append to a slice, while `copy` allows copying elements between slices.

### Tuple Type

A tuple type is an anonymous struct.

```go
var result (string, bool) = (null, false)
```

In the above example `(string, bool)` is a tuple type.
The expression `(null, false)` is a literal that is assignable to a tuple.

The main use case of tuples is complex return values.

```go
func lookup(name string) (string, bool) {
    ...
}
``` 

The above function returns a tuple and could thus be assigned to the `result` variable.

```go
result = lookup("foobar")
```

Furthermore, tuples returned by a function can be decomposed upon assignment.

```go
id, ok = lookup("foobar")
```

Tuples can be used in other cases as well, but structs are often easier to use.
The advantage of tuples is that they are anonymous.
If every function returning a tuple uses a struct instead, the code would be cluttered with structs.

```go
type lookupResult struct {
    id string
    ok bool
}

func lookup(name string) lookupResult {
}
```

In the above case tuples are easier to use.

### Or-Type and Symbols

An Or-Type is a union of types with a discriminator.
A value of an Or-Type must match one of these types and the discriminator stores which type that is.

```go
var v string | bool = false
v = "Hello"
```

Using the `is` keyword, we can test the type of value being stored in the Or-Type.

```go
var v string | bool = false
if (v is bool) {
    ...
}
v = "Hello"
if (v is string) {
    ...
}
```

A value can be extracted using a cast operation.
If the Or-Type stores a different value, the program will panic.

```go
var v string | bool = "Joe"
var name = <string>v
```

Or types can be used together with symbols to construct enumerations.
For example, we can define a type to store a person's gender.

```go
type Gender "male" | "female" | string
var g Gender = "male"
if (g is "male") {
    ...
}
g = "female"
if (g == "female") {
    ...
}
g = "complicated"
if (g is string) {
    ...
}
```

In the above example `"male"` is a symbol type.
Note that is denotes a type and not a string value.
A symbol is a type that has only one possible value: a string literal of its own name, e.g. `"male"` in the above example.
Internally, a symbol is not necessarily stored as a string.
The compiler may opt to enumerate the symbols and store a number instead.

Assigning a string value (not string literal!) to the `Gender` type, sets `g's` value to a string type, no matter what the content of the string.

```go
type Gender "male" | "female" | string
var s = "male"                      // The type of s is now string
var g Gender = s                    // The type stored in g is now a string
if (g is string) {                  // True
    ...
}
if (g is "male") {                  // False
    ...
}
```

The default value of an Or-Type is the default value of its first type option.
In the case of 

```go
type Gender "male" | "female" | string

type Person struct {
    name   string
    gender Gender
}

var p Person = {name: "Joe"}
```

the field `gender` is not explicitly initialized and therefore defaults to `"male"`, because the symbol type `"male"` is the first type option on `Gender` and `"male"` is the default value of this symbol type.

### Struct Type

### Map Type

### Interfaces

### Const

### Typecasts

### Pure Values

A pure value can be copied byte by byte.
This is true for for all data-types except pointer-like types.
Unsafe pointers are pure values, however.
Pointer-like types can either not be copied, because copying could result in an object having multiple owning pointers, or an object is not destructed when its pointer is overwritten, or reference-counting does not happen correctly in case of reference pointers.

When using the `copy` or `clone` operators, only pure values can be copied or cloned.

## Functions

### Function Type

### Member Functions

### Closures

### Function Pointer

## Interfaces

### And Type

## Control Structures and Statements

### Assignment

### Increments

### If

### For

## Operators

### Arithmetic Operators

### Comparison Operators

### Logical Operators

### Reference Operator

The `&` operator creates a local reference pointer for a some data structure.

### cap

The `cap` operator can be applied to all slices.
It returns the size of the underlying array.
The type of the return value is `int`.

```go
let slice = [...100][:5]   // The slice has length 5,
                            // but the underlying array has the size 100.
let c = cap(slice)      // c is 100
```
### len

The `len` operator can be applied to slices, arrays and strings.
In the case of strings it returns the size of the string in chars.
It does not return the number of UTF-8 runes encoded in the string.
The type of the return value is `int`.

```go
len("Hello")    // This is 5
```

### append

### copy

### clone

### Slice Expressions

### Index Expressions

### sizeof

The `sizeof` operator returns the number of bytes required for storing a certain type in memory.
The type of the return value is `int`.

```go
sizeof(int64)   // This is 8
```

### alignedSizeof

The `alignedSizeof` operator returns the number of bytes required for storing a certain type in an array includeing alignment.
The returned size is always a multiple of the alignment.
The type of the return value is `int`.

```go
type Odd struct {
    a int64
    b byte
}

alignedSizeof(int64)    // This is 8
alignedSizeof(Odd)      // This is 16, because Odd has a size of 9
                        // but needs an alignment of 8.
```

### take

### Operator Precedence

## Templates

### Template Types

### Template Functions

## Advanced Topics

### Unsafe Pointers