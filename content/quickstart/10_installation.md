---
title: "Installation"
slug: "installation"
draft: false
weight: 10
---

The compiler currently only supports UNIX-like systems, Windows support is planned for a future release.  

## As Native Package

{{% notice note %}}
We are currently in the process of rewriting the compiler using _Go_.
The package provided here are based on the old version.
Currently, latest Fyr must be cloned from GitHub and compiled.
{{% /notice %}}

### Linux


#### Current Debian, Ubuntu, and Fedora

We provide _deb_ and _rpm_ packages hosted on [packagecloud](https://packagecloud.io/vs-ude/fyrlang).
These are built for a few versions of Debian, Ubuntu, and Fedora.  
Guides on how to install them are available on [their site](https://packagecloud.io/vs-ude/fyrlang/install).
Once the _fyrlang_ package is installed, the _fyrc_ binary should be available on your PATH.


#### Debian Stretch, Ubuntu 18.04, Mint, and Derivatives

Since both Debian Stretch and Ubuntu 18.04 and earlier ship with ancient versions of _npm_, our build system fails on these.
Because of this, we do not provide prebuilt packages for these and other distributions based in them, including Linux Mint 19.1.

Since the compiler itself is hosted on _nodejs_ and the _gcc_ calls work on C99 code, packages from other versions should work fine.
We have tested some of them on different versions and have not seen any issues.  


##### Example Workaround

There are multiple ways to get different versions of the packages on a system.
The script provided by packagecloud supports specifying the distro and version:

```
curl -s https://packagecloud.io/install/repositories/vs-ude/fyrlang/script.deb.sh | sudo os=ubuntu dist=disco bash
```

Manually editing the sources in _/etc/apt/sources.list.d/vs-ude\_fyrlang.list_ is another way:

```
deb https://packagecloud.io/vs-ude/fyrlang/ubuntu/ disco main
deb-src https://packagecloud.io/vs-ude/fyrlang/ubuntu/ disco main
```

After this, a simple `apt update && apt install fyrlang` should do the trick.
If you encounter issues while installing, please do not hesitate to contact us on GitHub.


#### Others

While we cannot support all Linux distributions ourselves, the community might create packages for them at some point.
Other distributions might be supported, you can just search for a _fyrlang_ package.  
We will list other distro's known packages here.

- Arch Linux AUR [package](https://aur.archlinux.org/packages/fyrlang/)

If you are interested in packaging Fyr for your distribution and have questions, please do not hesitate to contact us.


### macOS/Homebrew

Additionally, we maintain a [Homebrew Tap](https://github.com/vs-ude/homebrew-fyr) containing the _fyrlang_ formula.

Once you have [Homebrew](https://brew.sh/) installed, installing fyr is as easy as `brew install vs-ude/fyr/fyrlang`.
The _fyrc_ binary will be linked into your Homebrew path.


## From Source

Simply clone [the repository](https://github.com/vs-ude/fyrlang) and run `make`.
The _fyrc_ executable can be found in the same directory.

Now set the environment variables in the cloned directory like this:

```
export FYRBASE=`pwd`
export PATH=$PATH:$FYRBASE
```

To test your installation run `make test`.