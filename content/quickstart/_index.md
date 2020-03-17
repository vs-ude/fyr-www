---
title: "Quick Start"
draft: false
weight: 1
---

The quick start guide shows how to use the compiler to generate code and binaries from Fyr code.
To install the compiler, please follow the instructions in [Installation](installation).

### C Compiler

Fyr uses a C compiler to generate native applications.
By default, Fyr uses `gcc` or `clang`, which must be installed.

{{% notice note %}}
Support for `avr-gcc` will follow.
{{% /notice %}}

## Compile and Run

The package comes with the _fyrc_ binary, which can be used to compile Fyr code into C or binary executables.  

### Native Binaries

A simple _hello\_world.fyr_ looks like this:

```
func Main() {
    println("Hello World")
}
```

It can be compiled with `fyrc -n hello_world.fyr`.
The generated executable is _hello\_world_ and yields `Hello World` when run.

More examples can be found in the _examples/_ folder of the repository.

### Compiling a package

To compile a package (i.e. all `.fyr` files in a directory`, go to the sources directory of the package and run

```bash
fyrc -n .
```

If the package is in the sources path of `$FYRBASE` or `$FYRPATH`, the object files are put to `pkg/<architecture>` in the respective path, and executables are put to `bin/<architecture>`.
This is preferable, since it does not clutter the source files with generated files.

### Environment Variables

The `$FYRBASE` variable must be set to the cloned git repository.
If you installed Fyr via a package manager this variable should be set accordingly.

You may set `$FYRPATH` to a directory that contains your personal sources in `$FYRPATH/src`.
The compiler will use it to search for additional packages referenced in your code.

If `$FYRPATH` is not set, it defaults to `$HOME/fyr`.
Optionally `$FYRPATH` can contain multiple paths separated by colons.
