# Fyr

Fyr is a **scalable application programming language** running in Web Browsers (as [WebAssembly](http://webassembly.org)), on the desktop and servers (native or inside _Node.JS_), and on simple Arduino-like IoT-devices.

Fyr is a compiled language with static type checking, a lean memory footprint, and generates high-performance code. Fyr currently compiles to _WebAssemlby_ and _C99_ code. WebAssembly is supported by _Chrome_, _Firefox_, _Safari_, _Edge_, _Node.JS_ and more.
Thus, WebAssembly allows Fyr code to run on desktop, server and mobile devices.
Using _C_ as output, Fyr code can even run efficiently on small embedded devices. 

Fyr is designed to implement all tiers of **modern distributed IoT applications**, i.e. embedded devices, server-side code and of course the Web UI. 

## Design Rational

Todays application programming languages like _GO_ , _Java_, _Swift_ etc. work well on desktop, servers and mobile devices, but all attempts of porting them to either Web browsers or small IoT devices are challenging, because they require a complex run-time system that is supposed to run on a machine with plenty of resources.
Compiling such code to WebAssembly or JavaScript inadvertantly leads to huge binaries, resulting in poor page loading times and high resource usage on the client.

_JavaScript_ / _TypeScript_ is currently the default choice for a language that runs well on the browser and on the server-side.
This shows that there is a benefit in a language covering all tiers of a distributed application, compared to working with a different language on each tier.
However, an optimizing JS-engine like _V8_ is not suitable for small embedded devices and on the server side its performance is not comparable to _GO_, _Java_, or even _C / C++_.

The design goal of Fyr is therefore to produce **small binaries** (comparable to JS), **efficient code** (somewhere between GO / Java and C / C++) and a **productive programming environment**.

## Project Status

Fyr is a research project of the [_Distributed Systems_](http://www.vs.uni-due.de) research group at the [_University Duisburg Essen_](http://www.uni-due.de).
Fyr is still in alpha status.
The Fyr compiler for WebAssembly is working, although not all planned features are imlemented yet.
The C99 backend is working for a subset of the language, but is not as complete as WebAssembly support.

Some initial benchmarks indicate that Fyr in WebAssembly executes faster than JavaScript or even C (when compiled to JavaScript) in the browser.
Since WebAssembly is still in its infancies, performance will be boosted even more in the future.
Fyr code compiled to C99 and then compiled to native binaries with _gcc_ can be significantly faster than _GO_ and with a smaller memory footprint.
Performance does of course depend heavily of the benchmark chosen.
However, initial results indicate that the project goal is reachable.
Of course, there is a long way to go still, from a research project to a productive programming language.

## WebAssembly Support

Fyr features **garbage collection** and **coroutines**.
Both see no dedicated support in the WebAssembly MVP.
Thus, a first goal of Fyr is to evaluate how GC and coroutines can be implemented on top of the current WebAssemly MVP and how it affects performance and size of binaries.
Dedicated GC and coroutine support is being actively discussed by the WebAssembly community, but these features have some pros and cons.
The first goal of Fyr is therefore to provide pratical experience and measurements to support the further development of WebAssembly.
WebAssembly is the prime compilation target for Fyr, although the generated C99 code is (today) still significantly faster than WebAssembly.
But WebAssembly is portable, desgined for small binaries and quick loading, widely supported, and it can only become faster in the days to come.
