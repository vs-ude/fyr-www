# Fyr

Fyr is a **modern systems programming language** that combines the versatility of C with the ease and safety of application programming languages like _Java_, _Go_ or _TypeScript_.
Like C/C++, Fyr can be used for low-level hardware-oriented programming and high-level application programming.
In contrast to C, the Fyr compiler guarantees **memory safety and thread safety** at compilation time.

As a systems programming language, Fyr targets all computing platforms.
Currently the Fyr compiler generates code running in Web Browsers (as [WebAssembly](http://webassembly.org)), desktops and servers (native or inside _Node.JS_), and simple IoT-devices like Arduino Uno or ESP32.
It is planned to support GPUs and other non-standard hardware setups as well.

Fyr is a compiled language with **static type checking, a lean memory footprint, and generates high-performance code**.
Fyr currently compiles to _WebAssembly_ and _C99_ code.
WebAssembly is supported by all modern browsers like _Chrome_, _Firefox_, _Safari_, _Edge_, and _Node.JS_.
Thus, WebAssembly allows Fyr code to run on desktops, servers and mobile devices.
Using _C99_ as output, Fyr code can even run efficiently on small embedded devices.

Fyr is designed to implement all tiers of **distributed IoT applications**, i.e. embedded devices, server-side code and the Web UI. 
Furthermore, it can be combined with existing _C_ and _JavaScript_ code.

## Design Rationale

The motivation behind Fyr is that we are lacking a modern systems programming language that could replace C.

C has been created in 1972 and it is still in heavy use today for projects including operating systems, interpreters, GPU programming or embedded programming.
Two properties contribute to the success of C.
The language itself is not bound to a runtime system and it makes only few assumptions about the hardware it is running on.
As a consequence, C code can run on almost any hardware, ranging from PCs, to GPUs and embedded.
The drawback of C (and C++) is that the language is neither memory safe nor thread safe.
Especially for modern IoT applications this increases the risk of bugs and security vulnerabilities.

Fyr is designed as a safe replacement of C.
However, replacing C entirely is a very long term goal.
In the meantime, Fyr can be easily combined with existing C sources, because Fyr can compile to C code.
If some hardware can run C then it can run Fyr as well.

Fyr has no garbage collector, because on restricted hardware there is not enough RAM to generate garbage in the first place.
There might not even be a heap where dynamic data could be allocated.
Fyr uses its type system and static code analysis to determine where memory is allocated and free'd (if there is a heap).
In this respect it follows _Rust_ and _Swift_, which have no garbage collector either.
However, Fyr's type system is less restrictive than that of _Rust_ and closer to the hardware than that of _Swift_.

Fyr is by intention a small language that is easy to write and easy to read.
It is very much inspired by _GO_.
Unlike _C++_, Fyr offers no complex OO-constructs and no meta-programming capabilities.
Unlike _GO_, Fyr offers templates, because they contribute to static type checking.

The goal of Fyr is to produce **small binaries** (comparable to JavaScript), **efficient code** (somewhere between GO / Java and C / C++) and a **productive programming environment**.

## Project Status

{{% notice note %}}
We are currently in the process of rewriting the compiler using _Go_. Implementation of new features is halted until we reach feature parity with the old implementation.
{{% /notice %}}

Fyr is a **research project** of the [_Distributed Systems_](http://www.vs.uni-due.de) research group at the [_University Duisburg Essen_](http://www.uni-due.de).
Fyr is still in alpha status.
The Fyr compiler for C99 is working, although not all planned features are implemented yet.
The WebAssembly backend is working for a subset of the language, but requires some more work.

Some initial benchmarks indicate that Fyr in WebAssembly executes faster than JavaScript or even C (when compiled to WebAssembly) in the browser.
Since WebAssembly is still in its infancies, performance will be boosted even more in the future.
Fyr code compiled to C99 and then compiled to native binaries with _gcc_ can be significantly faster than _GO_ and with a smaller memory footprint.
Performance does of course depend heavily on the benchmark chosen.
However, initial results indicate that the project goal is reachable.
Of course, it's still a long way from a research project to a productive programming language.
