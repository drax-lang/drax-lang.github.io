---
layout: page
title: "Getting started"
menu_exclude: true
---

# Getting started

This page is a quick tour. Every example below was run with the interpreter, and the output is what you get. If you have not installed Drax yet, see [Installation](/installation/).

Drax is dynamically typed and functional. There are no `for` or `while` loops: repetition is recursion, and [tail calls](/docs/recursion-and-tail-calls.html) run in constant memory. Files use the `.dx` extension and comments start with `#`.

## Printing

`print` writes a string as it is, and everything else in its text form. `inspect` writes the value the way it is written in the code, with strings quoted and escaped, and returns it, which is handy inside a pipe. The interactive shell, lists and frames always show strings quoted, so `"1"` and `1`, or `"a, b"` and two elements, can not be mistaken.

```drax
print("hello")     # hello
inspect("hello")   # "hello"
print(["a", 1])   # ["a", 1]
print(0.1 + 0.2)   # 0.30000000000000004
```

Numbers are written with the fewest digits that read back as the same number, and `Number.to_string` gives the same text.

## Running code

```sh
drax file.dx      # runs a file
drax              # interactive shell
```

## Values

```drax
name = "Drax"
nums = [1, 2, 3, 4]
user = { name: "Tom", age: 30 }
```

Strings can use `'...'`, `"..."` or `"""..."""` for several lines. Numbers accept `0x`, `0b` and `0o` prefixes. `true`, `false` and `nil` are constants. See [Types](/docs/types.html).

## Functions

The last expression of a function is its result. A function body starts with `do` and always ends with `end`.

```drax
fun double(x) do x * 2 end

fun greet(n) do "Hello, " ++ n end
fun greet(n, g) do g ++ ", " ++ n end

print(greet("Drax"))
print(greet("Drax", "Hi"))
```

```
Hello, Drax
Hi, Drax
```

The same name can have several definitions with different numbers of arguments. `++` joins strings and lists. See [Functions](/docs/functions.html).

## if / else

The condition goes in parentheses, and `if` is an expression:

```drax
fun sign(n) do
  if (n < 0) do "negative" else "positive" end
end

print(sign(-1))      # negative
```

## Lists, lambdas and the pipe operator

```drax
print(List.map([1, 2, 3, 4], double))               # [2, 4, 6, 8]
print(List.filter([1, 2, 3, 4], fun (x) x > 2 end)) # [3, 4]
print([1, 2, 3, 4] |> List.map(double) |> List.sum())  # 20
```

Lists and frames are immutable: `List.pop`, `Frame.put` and the others return a new value. See [Pipe operator](/docs/pipe-operator.html).

## Frames

```drax
user = { name: "Tom", age: 30 }

print(user.name)                      # Tom
print(Frame.put(user, "city", "Rio")) # {'name': "Tom", 'age': 30, 'city': "Rio"}
```

## Loops are recursion

```drax
fun count(n, acc) do
  if (n == 0) do acc else count(n - 1, acc + n) end
end

print(count(1000000, 0))   # 500000500000
```

The call to `count` is the last thing the function does, so it reuses the same frame and a million iterations use constant memory.

## Modules and files

A file passes a value to the outside with `export`, and another file reads it with `import`.

`util.dx`:

```drax
fun twice(x) do x * 2 end

export({ twice: twice })
```

`main.dx`:

```drax
u = import("./util.dx")
print(u.twice(21))      # 42
```

See [Imports](/docs/imports.html) and [Import and Export](/docs/import-and-export.html).

## Where to go next

* [Standard library](/docs/stdlib.html): every function of `List`, `Frame`, `String`, `Number`, `Math`, `Os`, `Core`, `TCPServer` and `Http`.
* [HTTP server](/docs/http.html): a web server in a few lines.
* [Packages](/docs/packages.html): dependencies with `dmr`.
* [Editor support](/docs/editors.html).
