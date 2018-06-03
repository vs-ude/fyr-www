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

## Install

### Build the Fyr Compiler

The Fyr compiler is written in [TypeScript](http://typescriptlang.org). Install the latest version and make sure that `tsc` is in your path.

To execute the Fyr compiler, install the latest version of [Node.js](https://nodejs.org/en/). Make sure that `node` is in your path.

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

### Setup Environment Variables

Now set the path to the fyr directory like this:

```bash
export FYRBASE=/your/path/to/fyr
```

Fyr will use this path to find its library files.

Add the directory `$FYRBASE/bin` to your path so that `fyrc` and `runwasm` are in your path.

## Compile and Run

Use `fyrc` to compile `.fyr` files.
The following example compiler a fyr source file into a C file.

```bash
fyrc -c -T example.fyr
```

The output of the above command is `example.c` in the same directory.
A C compiler (for example gcc) is required to generate an executable.

```bash
gcc -O3 -c example.c fyr.c
gcc -o example example.o fyr.o
./example
``` 

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
