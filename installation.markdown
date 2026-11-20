---
layout: page
title: Installation
permalink: /installation/
---

Drax is a single C99 program. There is nothing to download but the source: you only need a C compiler and `make`.

## Requirements

| Needed | For |
|---|---|
| `gcc` or `clang` (C99) and `make` | building the interpreter |
| `git` | cloning the source and `dmr` (the package manager) |
| `libedit` *(optional)* | line editing and history in the interactive shell |

## Quick install

On Linux, macOS and BSD one command downloads the source, builds `drax` and `dmr` and copies them to `~/.local/bin` (it never uses sudo):

```sh
curl -fsSL https://drax-lang.github.io/install.sh | sh
```

Options go after `sh -s --`, for example `--prefix /usr/local`, `--ref v0.1.0`, `--no-dmr`, `--light` or `--uninstall`. You can [read the script](/install.sh) first, or download it and run `sh install.sh --help`.

## Build from source

```sh
git clone https://github.com/drax-lang/drax.git
cd drax

make config        # creates the ./bin directory
make all           # builds ./bin/drax
```

If your system does not have `libedit`, build without it. Everything works the same, only the interactive shell has no line editing:

```sh
make all LIGHT=1
```

Check that it works:

```sh
$ ./bin/drax --version
Drax Language (v0.0.1-dev) (LC-0.0.0-dev)
```

## Install on your system

`make install` copies `drax` and `dmr` to `/usr/local/bin`. Build `dmr` first, because the install step copies the binary that is already built:

```sh
make -C dmr        # builds ./dmr/bin/dmr
sudo make install  # builds drax and copies drax and dmr to /usr/local/bin
```

If you only want the interpreter, copy it yourself:

```sh
sudo cp ./bin/drax /usr/local/bin/drax
```

## Your first program

Create `hello.dx`:

```drax
fun say(name) do
  print("Welcome, " ++ name)
end

say("Tom")
```

and run it:

```sh
$ drax hello.dx
Welcome, Tom
```

Running `drax` with no arguments opens the interactive shell:

```sh
$ drax
Drax (v0.0.1-dev) (LC-0.0.0-dev)
> 1 + 1
2
```

Continue with [Getting started](/docs/getting-started.html).

## Package manager: dmr

`dmr` downloads the dependencies listed in `package.toml` into `./lib`, which is the directory Drax searches when you write `import('name')`.

```sh
make -C dmr            # from the drax repository
dmr init               # creates a default package.toml
dmr add drax-lang/griht   # adds a dependency (GitHub, git url or path)
dmr install            # reads package.toml, writes ./lib and package.lock
```

See [Packages](/docs/packages.html).

## Editor support

Syntax highlighting, go to definition, hover, completion and diagnostics for VS Code, Vim and Neovim: [Editor support](/docs/editors.html). In VS Code, install the extension with `code --install-extension drax-lang.drax-lang`.

## Run the tests

```sh
make test
```

## Other platforms

The `Makefile` detects Linux, macOS and BSD and builds with the same commands. A Windows target (`TARGET_OS=WIN32`, MinGW-w64) exists in the `Makefile`, but it is not tested by the project's CI yet. `dmr` supports POSIX systems only.

## Troubleshooting

| Problem | Fix |
|---|---|
| `mkdir: cannot create directory 'bin': File exists` on `make config` | The directory already exists. Ignore it and run `make all`. |
| `fatal error: histedit.h: No such file or directory` | Install the `libedit` development package (`libedit-dev` on Debian and Ubuntu, `libedit-devel` on Fedora) or build with `make all LIGHT=1`. |
| `sudo make install` fails with `dmr/bin/dmr: No such file` | Run `make -C dmr` first. |
