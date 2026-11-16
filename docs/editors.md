---
layout: page
title: "Editor support"
menu_exclude: true
---

# Editor support

The [drax-ls](https://github.com/drax-lang/drax-ls) project provides a language server and plugins for VS Code, Vim and Neovim.

## What you get

| Feature | VS Code | Vim / Neovim |
|---|---|---|
| Syntax highlighting for `.dx` | yes | yes |
| Comment, bracket and indent rules | yes | yes |
| Snippets (`fun`, `if`, `imp`, `map`, ...) | yes | |
| File icons for `.dx` and `.dgraph` | yes | |
| Diagnostics (missing `end`, unbalanced brackets, missing `do`, unterminated strings) | yes | yes, with the language server |
| Go to definition (Ctrl+click), including `import('...')` paths and `module.key` across files | yes | yes, with the language server |
| Hover with the signature and the `#` comments above a function | yes | yes, with the language server |
| Completion (keywords, builtins, `List.`, `Frame.`, keys of imported modules) | yes | yes, with the language server |
| References, rename (same file), outline and workspace symbols | yes | yes, with the language server |

The language server is a lightweight analyser, not a type checker. Go to definition follows lexical scopes and can be wrong in very dynamic code.

## VS Code

Build and install the **Drax** extension from the `drax-ls` repository (it needs Node.js):

```sh
git clone https://github.com/drax-lang/drax-ls.git
cd drax-ls/vscode
npm install
npm run package
code --install-extension drax-lang-0.1.0.vsix
```

The language server is bundled in the extension, you do not need to install anything else. It can be turned off with the setting `drax.languageServer.enabled`.

## Neovim

Clone `drax-ls` and install the dependencies of the server (Node.js is required):

```sh
git clone https://github.com/drax-lang/drax-ls.git ~/.local/share/nvim/site/pack/drax/start/drax-ls
cd ~/.local/share/nvim/site/pack/drax/start/drax-ls/server && npm install
```

The runtime files live in `vim/`, so add that directory to the runtime path and start the server in your `init.lua`:

```lua
vim.opt.runtimepath:append(vim.fn.expand('~/.local/share/nvim/site/pack/drax/start/drax-ls/vim'))
require('drax.lsp').setup()
```

Use `vim.lsp.buf.definition()` for go to definition and `K` for hover.

## Vim

The syntax, indent and filetype files work with any plugin manager, for example with vim-plug:

```vim
Plug '~/path/to/drax-ls/vim'
```

For the language server in Vim 9, install [yegappan/lsp](https://github.com/yegappan/lsp). The plugin registers the server by itself. Run `cd server && npm install` once.
