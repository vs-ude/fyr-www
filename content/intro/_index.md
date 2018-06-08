---
title: "Quick Start"
date: 2017-11-13T21:30:52+01:00
draft: false
---

The quick start guide shows how to download and install Fyr and how to compile and execute the generated code.

## Download

### Fyr Compiler

Git is required to download the Fyr sources.

Clone the Fyr git repository.

{{% notice note %}}
Fyr is currently being developed on an internal Git.
Making Fyr available on GitHub is the next milestone.
{{% /notice %}}

### WebAssembly

This step is only required when compiling Fyr to WebAssembly.

The Fyr compiler currently relies on the [WebAssembly Binary Toolkit](https://github.com/WebAssembly/wabt).
It uses the `wat2wasm` tool to translate `.wat` files into `.wasm` files.

Install the WebAssembly Binary Toolkit and make sure that `wabt` is in your path.

### C Compiler

Fyr uses a C compiler to generate native applications.
By default, Fyr uses `gcc`, which must be installed.

{{% notice note %}}
Support for `clang` or `avr-gcc` will follow.
{{% /notice %}}

## Install

### Build the Fyr Compiler

The Fyr compiler is written in [TypeScript](http://typescriptlang.org).
Install the latest version and make sure that `tsc` is in your path.

To execute the Fyr compiler, install the latest version of [Node.js](https://nodejs.org/en/).
Make sure that `node` is in your path.

Fyr uses [NPM](https://www.npmjs.com/package/npm) to download required packages. Make sure that `npm` is in your path.

To download all dependencies, go to the `fyr` directory and execute:

```bash
npm install
```

To build the software (output is written to `/lib`), execute:

```bash
npm run build
```

Running `npm run build:parser` will only generate fresh JavaScript from the `parser.pegjs` parser definition.
Running `npm run build:lib` re-compiles the minimal native Fyr runtime.

### Determine the Architecture

Fyr is designed for cross compilation.
Therefore, paths to object files or executables have a architecture-specific subdirectory.
Use the `fyrarch` command to get the default architecture.
In the following we refer to `<architecture>` which must be set to the output of `fyrarch` unless cross compiling for another architecture.

### Setup Environment Variables

Now set the path to the fyr installation directory like this:

```bash
export FYRBASE=/your/path/to/fyr
```

Fyr will use this path to find its library files.

Add the directory `$FYRBASE/bin` to your path so that `fyrc` and `runwasm` are in your path.
The directory `$FYRBASE/src` contains packages of the Fyr standard library.

Set `$FYRPATH` to a directry that contains your personal sources in `$FYRPATH/src`.
If `$FYRPATH` is not set, it defaults to `$HOME/fyr`.
Optionally `$FYRPATH` can contain multiple pathes separated by colon.
Make sure to put `$FYRPATH/bin/<architecture>` in your path, because this is the location where the compiled programs are put.

## Compile and Run

Use `fyrc` to compile `.fyr` files.
The following example compiler a fyr source file into a C file.

```bash
fyrc -c example.fyr
```

The output of the above command is `example.c` in the same directory.
Furthermore, the C-files are compiled and linked resuting in `example`.

To compile a package (i.e. all `.fyr` files in a directory`, go to the sources directory of the package and run

```bash
fyrc -c .
```

If the package is in the sources path of `$FYRBASE` or `$FYRPATH`, the object files are put to `pkg/<architecture>` in the respective path, and executables are put to `bin/<architecture>`.
This is preferable, since it does not clutter the source files with generated files.

### Running WebAssembly Code

Some examples come with an HTML page.
Make it available for example with `python -m SimpleHTTPServer 8000` and open the HTML page.
It will load the WASM code and execute it.

Other examples are made to run in Node.js.
Use the `runwasm` tool to execute WASM in Node.js as follows:

```bash
runwasm mandelbrot.wasm main
```

Here `main` is the function to execute.
Make sure that this function is exported like this:

```go
export func main() {
    ...
}
```

If the function returns a value, it is displayed on the console.

For benchmarking execute 

```bash
time runwasm mandelbrot.wasm main
```

The performance overhead of launching node is around 100ms on a modern machine.
Hence, benchmarks must run significantly longer to produce meaningful results.
