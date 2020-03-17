# Fyr

Fyr is a **modern systems programming language** that combines the versatility of C with the ease and safety of application programming languages like _Java_, _Go_ or _TypeScript_.
Like C/C++, Fyr can be used for low-level hardware-oriented programming and high-level application programming.
In contrast to C, the Fyr compiler guarantees **memory safety and thread safety** at compilation time.

As a systems programming language, Fyr targets all computing platforms.
Currently the Fyr compiler generates code that can be compiled on UNIX-like operating systems.
Therefore, Fyr generates _C99_ code that can be compiled to a binary using the system native C-compiler.
Support for platforms like web browser (as [WebAssembly](http://webassembly.org)), and simple IoT-devices like _Arduino Uno_ or _ESP32_ are on the roadmap.
An inital but incomplete version targeting _Vulkan_ has already been created.
It is planned to support GPUs and other non-standard hardware setups as well.

Fyr is a compiled language with **static type checking, a lean memory footprint, and generates high-performance code**.
Using _C99_ as intermediate output, Fyr code can even run efficiently on small embedded devices, because it profits from the optimizations and platform support available by well supported C-compilers.

Fyr is designed to implement all tiers of **distributed IoT applications**, i.e. embedded devices, server-side code and the Web UI. 

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
Unlike _GO v1_, Fyr offers templates, because they contribute to static type checking.

The goal of Fyr is to produce **small binaries** (comparable to C/C++), **efficient code** (somewhere between GO / Java and C / C++) and a **productive programming environment**.

## Project Status

{{% notice note %}}
We are currently in the process of rewriting the compiler using _Go_. 
{{% /notice %}}

Fyr is a **research project** of the [_Distributed Systems_](http://www.vs.uni-due.de) research group at the [_University Duisburg Essen_](http://www.uni-due.de).
Fyr is still in alpha status.
The Fyr compiler for C99 is working, although not all planned features are implemented yet.