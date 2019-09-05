---
title: "Quick Start"
draft: false
weight: 1
---

The quick start guide shows how to use the compiler to generate code and binaries from Fyr code.
To install the compiler, please follow the instructions in [Installation](installation).

### C Compiler

Fyr uses a C compiler to generate native applications.
By default, Fyr uses `gcc`, which must be installed.

{{% notice note %}}
Support for `clang` or `avr-gcc` will follow.
{{% /notice %}}

## Compile and Run

The package comes with the _fyrc_ binary, which can be used to compile Fyr code into C or binary executables.  

### Native Binaries

A simple _hello\_world.fyr_ looks like this:

```
export func main() int {
    println("Hello World")
    return 0
}
```

It can be compiled with `fyrc -n hello_world.fyr`.
The generated executable is _hello\_world_ and yields `Hello World` when run.

More examples can be found in the _src/_ folder of the repository.

### Compiling to C-Code

The following example compiles a fyr source file into a C file.
The flag `-c` selects C as a compiler backend.

```bash
fyrc -c example.fyr
```

The output of the above command is `example.c` in the same directory.
Furthermore, the C-files are compiled and linked resulting in `example`.

To compile a package (i.e. all `.fyr` files in a directory`, go to the sources directory of the package and run

```bash
fyrc -n .
```

If the package is in the sources path of `$FYRBASE` or `$FYRPATH`, the object files are put to `pkg/<architecture>` in the respective path, and executables are put to `bin/<architecture>`.
This is preferable, since it does not clutter the source files with generated files.

### Environment Variables

You may set `$FYRPATH` to a directory that contains your personal sources in `$FYRPATH/src`.
The compiler will use it to search for additional packages referenced in your code.

If `$FYRPATH` is not set, it defaults to `$HOME/fyr`.
Optionally `$FYRPATH` can contain multiple paths separated by colons.
