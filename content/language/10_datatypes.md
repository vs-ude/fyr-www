---
title: "Data Types"
slug: "datatypes"
draft: false
weight: 10
---

Fyr supports the following basic data types:

```go
uint8, uint16, uint32, uint64   // Unsigned integers of fixed size
int8, int16, int32, int64       // Signed integers of fixed size
float32, float64                // 32bit and 64bit floating point numbers
byte                            // Platform dependent
                                // Smallest addressable unsigned unit
                                // Usually 8 bits
bool                            // A boolean of 8 bits size that is false or true
string                          // Immutable UTF-8 strings
rune                            // A 32-bit unicode character
int                             // Platform dependent
                                // Signed value, usually 32 bits even on 64-bit platforms
uint                            // Platform dependent
                                // Signed value, usually 32 bits even on 64-bit platforms
uintptr                         // Platform dependent
                                // Unsigned value large enough to store a pointer in it.
```

Many C-systems use 32-bit ints with a 64-bit address space by default.
Fyr treats `int` as an alias for C's `int`. On Arduinos, `int` is an alias for `int16`.
When compiling for other targets, the size of `int` can vary.

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

In the above example `1<<64` is larger than `uint64`.
This is ok, because the compiler evaluates `1<<64 -1`, determines that the result fits into 64 bit and therefore generated no error.
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
        println(i, r)         // Loops 5 times
    }
    println(len(str))      // Prints 6
}
```

The above example would call `println` 5 times although the string is 6 bytes long.
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

The following example does almost the same as the one above, except that `arr` is stored on the heap.

```go
func Main() {
    let arr []int = [123, 234, 345, 456]
    println(search(arr, 234))
}
```

In this example, `[123, 234, 345, 456]` allocates the array on the heap and returns a slice to it.
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

## Or-Type and Symbols

{{% notice note %}}
Or-types and symbols have been supported by the first version of Fyr.
The new compiler does not support it yet.
{{% /notice %}}

An Or-Type is a union of types with a discriminator.
A value of an Or-Type must match one of these types and the discriminator stores which type that is.

```go
var v string | bool = false
v = "Hello"
```

Using the `is` keyword, we can test the type of value being stored in the Or-Type.

```go
var v string | bool = false
if v is bool {
    ...
}
v = "Hello"
if v is string {
    ...
}
```

A value can be extracted using a cast operation.
If the Or-Type stores a different value, the program will panic.

```go
var v string | bool = "Joe"
var name = `string(v)
```

Or types can be used together with symbols to construct enumerations.
For example, we can define a type to store a person's gender.

```go
type Gender $male | $female | string
var g Gender = $male
if g is $male {
    ...
}
g = "complicated"
if g is string {
    ...
}
```

In the above example `$male` is a symbol type.
A symbol is a type that has only one possible value: itself, e.g. `$male` in the above example.
Internally, a symbol is just a number.
A symbol `$Male` defined in one package will always be equivalent to a symbol of the same name defined in any other package.
Symbols with a lower-case first letter are not exported, as is the case for all types. 

The default value of an Or-Type is the default value of its first type option.
In the case of 

```go
type Gender $male | $female | string

type Person struct {
    name   string
    gender Gender
}

var p Person = {name: "Joe"}
```

the field `gender` is not explicitly initialized and therefore defaults to `$male`, because the symbol type `$male` is the first type option on `Gender` and `$male` is the default value of this symbol type.

## Struct Type

## Map Type

## Interfaces

## Const

## Typecasts

### Slice to String

A slice of bytes or chars can be converted to a string via ``\`string(slice)``.
In this case the memory owned by the slice is used for the string.
The expression of the typecast (`slice` in the above example) will therefore become inaccessible, because this typecast freezes the slice since strings are immutable.
A `take` might be required to take ownership of the byte array.
The last byte of the slice must be zero, otherwise the program aborts, because Fyr strings are always zero terminated.

If the slice start is not equivalent to the start of the underlying array, the conversion moves the data to the beginning of the array.
This has O(n) complexity as in the following example.

```go
let slice []byte = [65, 66, 67, 68, 0]
let str = `string(slice[1:])
```

To get O(1) complexity, the slice start must be equivalent with the start of the underlying array, as in the following example.

```go
let slice []byte = [65, 66, 67, 68, 0]
let str = `string(slice)
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
let str = `string(clone(slice))
```

Converting a `null` slice results in a `null` string.
Converting a slice of length zero results in a string of length zero.

### String to Slice

A string can be casted to a slice or unique slice.
This copies the slice and returns ownership of the new slice.

```go
let slice = `[]byte("Hallo")
```

A `null` string results in a `null` slice.

## Pure Values

A pure value is a data structure that has no pointers.
Unsafe pointers are considered pure values as well.

## Copying

A pure value can be copied byte by byte.
Data types that can not be copied include data types which point to an isolated group.
By definition, only one pointer must exist that points inside this group.
Therefore, copying is not allowed.
The same applies to pointers to immutable objects, because these required atomic reference counting.
Just copying those pointers would break reference counting.

These copying restrictions are important for the operators `copy` or `clone` as well as for by-value assignment or when passing an argument by-value to a function.

Use `take` to take a data structure from one place and put it somewhere else.
`take` is not subject to the aforementioned copying rules, because it does not create a copy.