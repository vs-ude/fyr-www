---
title: "Data Types"
slug: "datatypes"
draft: false
weight: 10
---

Fyr supports the following data types:

```go
uint8, uint16, uint32, uint64   // Unsigned integers of fixed size
int8, int16, int32, int64       // Signed integers of fixed size
float32, float64                // 32bit and 64bit floating point numbers
byte                            // Platform dependant
                                // Smallest addressable unsigned unit
                                // Usually 8 bits
char                            // Platform dependant
                                // Smallest addressable signed unit
                                // Usually 8 bits
bool                            // A boolean of 8 bits size that is false or true
string                          // Immutable UTF-8 strings
rune                            // A 32-bit unicode character
int                             // Platform dependant
                                // Signed value, usually 32 bits even on 64-bit platforms
uint                            // Platform dependant
                                // Signed value, usually 32 bits even on 64-bit platforms
```

WebAssembly uses a 32-bit address space by default, hence Fyr treats `int` as an alias for `int32` in WebAssembly. On Arduinos, `int` is an alias for `int16`. When compiling for other targets than WebAssembly MVP, `int` can be an alias for `int16` or `int32` or `int64` depending on the target platform, but the default is `int64` on the PC.

The `char` type is required to interface with C functions.
Idiomatic Fyr code should not use `char` otherwise, since it is a platform-dependent type by definition.

All data types have a default value of 0.

Fyr does not perform any implicit type conversion.
Explicit casts are required as in the following example:

```go
var x int32 = 42
var y int16 = `int16(x)
```

All numeric types including `bool` can be explicitly casted into each other.

## Numeric Literals

Boolean literals are `true` and `false`.

Integer literals are either written as decimals as in `1234` or in hexadecimal as in `0xffef` or octal as in `0666`.

Floating point literal are of the form `12.34` or `.34`.

Fyr supportts numeric literals which are larger than 64bit.

```go
// This works
var x uint64 = 1<<64 - 1
// This fails
var y uint8 = 1<<8
```

In the above example `1<<64` is larger than uint64.
This is ok, because the compiler evaluates `1<<64 -1`, determines that it fits into 64 bit and therefore generated no error.
The value `1<<8` is too large for uint8, therefore the compiler will report an error.

## Strings and Runes

Fyr strings are immutable and store data in UTF-8 encoding.
Strings are stored as pointers to string data.
Hence, string assignment is very fast.
String comparison, however, compares the value of the strings these internal pointers are pointing at.

The index operator `[index]` returns bytes of the UTF-8 encoding.

To obtain the byte count of a string, call its `len()` member function.
To access the single unicode characters (of type `rune`) encoded in the UTF-8 string, a `for` loop can be used.

```go
func print(i int, r rune) {
    ...
}

func Main() {
    var str = "Übung"
    for i, r := range str {
        print(i, r)         // Loops 5 times
    }
    println(str.len())      // Prints 6
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
var arr []byte = `[]byte("Hallo")
var str string = `string(arr)
```

Note that this conversion implies a copy because strings are immutable and slices are not.

## Pointer Type

## Arrays and Slices

Arrays are value types of fixed length.
Assigning one array to another results in a copy of this array.
When accessing an array, Fyr checks that the index is within the bounds of the array.
An out-of-bound index causes the application to abort.

```go
func search(arr [4]int, val int) int {
    for i, v := range arr {
        if v == val {
            return i
        }
    }
    return 0
}

func Main() {
    var arr [4]int = []
    arr[0] = 123
    arr[1] = 234
    println(search(arr, 234))
}
```

Note that variables need explicit initialization before the variable can be used.
The initialization expression `[]` initializes an array or slice with its default value, which is zero in this case.

In the above example, the array is copied when `search` is called.
This is inefficient, and the search function works only for arrays of a fixed size.
Therefore, Fyr supports slices, which are essentially pointers to an underlying array.

```go
func search(arr []int, val int) int {
    for i, v := range arr {
        if v == val {
            return i
        }
    }
    return 0
}

func Main() {
    var arr [4]int = [123, 234, 345, 456]
    println(search(arr[:], 234))
}
```

The above example uses an array initialization, which is just a shortcut to populate an array.
It is possible to combine this with the default initialization with `[12, 23, ...]`.
In this case the first two array elements are initialized with `12` and `23` and all remaining elements are initialized with the default value.

The slice operator `[:]` creates a slice which points to the underlying array and contains all elements of `arr`.
For example, `[2:]` would include all elements of the array starting by the array element at position 2.

An access to a slice checks that the index is within the bounds of the slice.
Out-of-bound access aborts the application.

A slice is denoted for example as `[]int`.
Note that slices are pointers to an array.
Assigning one slice to another just assigns this internal pointer, but the array is not copied.

The following example does almost the same, except that `arr` is stored on the heap.

```go
func Main() {
    let arr []int = [123, 234, 345, 456]
    println(search(arr, 234))
}
```

In the above example, `[123, 234, 345, 456]` allocates the array on the heap and returns a slice to it.
Hence, `arr` is now a slice type.
Due to type inference, the following two statements are equivalent:

```go
let arr []int = [123, 234, 345, 456]
let arr = [123, 234, 345, 456]
```

To allocate a slice of variable size, use the `new` operator:

```go
let a = 100
let arr []int = new []int(100)        // len 100
let arr2 []int = new []int(100, 200)  // len 100, cap 200
```

The length of an array, string or slice can be obtained with the `len` operator.
The length of the array a slice is pointing to can be obtained with the `cap` operator.
The elements of a slice can be copied using the `clone` operator.
It returns a slice which points to the cloned array.
The `append` operator can append to a slice, while `copy` allows copying elements between slices.

## Tuple Type

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

## Or-Type and Symbols

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

## Struct Type

## Map Type

## Interfaces

## Const

## Typecasts

### Slice to String

A slice of bytes or chars can be converted to a string via `<string>slice`.
In this case the memory owned by the slice is used for the string.
The expression of the typecast (`slice` in the above example) will therefore become inaccessible, because this typecast freezes the slice since strings are immutable.
A `take` might be required to take ownership of the byte array.
The last byte of the slice must be zero, otherwise the program aborts, because Fyr strings are always zero terminated.

If the slice start is not equivalent to the start of the underlying array, the conversion moves the data to the beginning of the array.
This has O(n) complexity as in the following example.

```go
let slice []byte = [65, 66, 67, 68, 0]
let str = <string>slice[1:] 
```

To get O(1) complexity, the slice start must be equivalent with the start of the underlying array, as in the following example.

```go
let slice []byte = [65, 66, 67, 68, 0]
let str = <string>slice 
```

Converting a `null` slice results in a `null` string.
Converting a slice of length zero aborts the program, because the last byte of the slice must be zero.

A slice of bytes or chars can be converted to a string by allocating new memory via `<string>clone(slice)`.
This is a special case, because the compiler will allocate one additional byte when cloning the slice and set it to zero.
This allows the following string conversion to succeed.
In this construction, the slice does not have to end with a zero byte.

```go
// No trailing zero in the slice
let slice []byte = [65, 66, 67, 68]
let str = <string>clone(slice) 
```

Converting a `null` slice results in a `null` string.
Converting a slice of length zero results in a string of length zero.

### String to Slice

A string can be casted to a slice or unique slice.
This copies the slice and returns ownership of the new slice.
The last byte of the slice is a zero, because Fyr strings are zero terminated.

```go
let slice = <[]byte>"Hallo"
let slice2 = <^[]byte>"Hallo"
```

A `null` string results in a `null` slice.

## Pure Values

A pure value can be copied byte by byte.
This is true for for all data-types except pointer-like types.
Unsafe pointers are pure values, however.
Pointer-like types can either not be copied, because copying could result in an object having multiple owning pointers, or an object is not destructed when its pointer is overwritten, or reference-counting does not happen correctly in case of reference pointers.

When using the `copy` or `clone` operators, only pure values can be copied or cloned.