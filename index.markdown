---
layout: home
---

**Drax** is a small, dynamically typed, functional language with a focus on integrations. It is a single C program: build it, run a file, done.

```drax
fun say(name) do
  print("Welcome, " ++ name)
end

say("Tom")
```

```sh
git clone https://github.com/drax-lang/drax.git
cd drax && make config && make all
./bin/drax hello.dx
```

* **Functional.** Immutable lists and frames, lambdas, the pipe operator `|>` and no loops: recursion with [tail calls](/docs/recursion-and-tail-calls.html) runs in constant memory.
* **Batteries for integrations.** [HTTP server](/docs/http.html), `Os`, `List`, `Frame`, `String` and `Math` modules in the [standard library](/docs/stdlib.html).
* **Packages.** [`dmr`](/docs/packages.html) installs dependencies from git or a local path into `lib/`.
* **Tooling.** [VS Code, Vim and Neovim support](/docs/editors.html) with a language server.

[Install](/installation/) · [Getting started](/docs/getting-started.html) · [Documentation](/documentation/)
