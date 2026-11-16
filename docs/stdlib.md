---
layout: page
title: "Standard library"
menu_exclude: true
---

# Standard library

Every function below is available without importing anything. A function is written as `name/arity`; functions that accept more than one number of arguments list all of them (`copy/2,3`).

See [Modules](/docs/modules.html) for examples of some of them.

## Global functions

| Function | Arity |
|---|---|
| `assert` | 2 |
| `typeof` | 1 |
| `sleep` | 1 |
| `read` | 1 |
| `print` | 1 |
| `inspect` | 1 |
| `help` | 1 |

## List

Lists (immutable)

| Function | Arity |
|---|---|
| `List.concat` | 2 |
| `List.head` | 1 |
| `List.tail` | 1 |
| `List.length` | 1 |
| `List.is_empty` | 1 |
| `List.is_present` | 1 |
| `List.remove_at` | 2 |
| `List.insert_at` | 3 |
| `List.replace_at` | 3 |
| `List.slice` | 3 |
| `List.sum` | 1 |
| `List.at` | 2 |
| `List.sparse` | 1 |
| `List.hypot` | 1 |
| `List.dot` | 2 |
| `List.zip` | 2 |
| `List.pop` | 1 |
| `List.shift` | 1 |
| `List.map` | 2 |
| `List.filter` | 2 |
| `List.tap` | 2 |

## Frame

Frames (immutable key/value maps)

| Function | Arity |
|---|---|
| `Frame.put` | 3 |
| `Frame.merge` | 2 |
| `Frame.to_list` | 1 |
| `Frame.keys` | 1 |
| `Frame.values` | 1 |
| `Frame.has_key` | 2 |
| `Frame.remove` | 2 |
| `Frame.get` | 2 |
| `Frame.get_or_else` | 3 |
| `Frame.is_empty` | 1 |
| `Frame.is_present` | 1 |
| `Frame.new` | 0 |
| `Frame.new_from_list` | 1 |

## String

Strings

| Function | Arity |
|---|---|
| `String.split` | 2 |
| `String.length` | 1 |
| `String.copy` | 2, 3 |
| `String.at` | 2 |
| `String.to_uppercase` | 1 |
| `String.to_lowercase` | 1 |
| `String.to_number` | 1 |
| `String.contains` | 2 |

## Number

Numbers

| Function | Arity |
|---|---|
| `Number.to_string` | 1 |
| `Number.rand` | 0 |
| `Number.max` | 2 |
| `Number.min` | 2 |
| `Number.is_even` | 1 |
| `Number.is_odd` | 1 |
| `Number.floor_div` | 2 |

## Math

Math

| Function | Arity |
|---|---|
| `Math.cos` | 1 |
| `Math.cosh` | 1 |
| `Math.acos` | 1 |
| `Math.floor` | 1 |
| `Math.ceil` | 1 |
| `Math.pow` | 2 |
| `Math.tan` | 1 |
| `Math.tanh` | 1 |
| `Math.sqrt` | 1 |
| `Math.atan` | 1 |
| `Math.atan2` | 2 |
| `Math.exp` | 1 |
| `Math.fabs` | 1 |
| `Math.frexp` | 1 |
| `Math.ldexp` | 2 |
| `Math.log` | 1 |
| `Math.log10` | 1 |
| `Math.modf` | 1 |
| `Math.sin` | 1 |
| `Math.sinh` | 1 |
| `Math.asin` | 1 |
| `Math.hypot` | 2 |

## Os

Operating system

| Function | Arity |
|---|---|
| `Os.cmd` | 1 |
| `Os.cmd_with_status` | 1 |
| `Os.system` | 1 |
| `Os.get_env` | 1 |
| `Os.mkdir` | 1 |
| `Os.pmkdir` | 2 |

## Core

The virtual machine

| Function | Arity |
|---|---|
| `Core.gc_swap` | 0 |
| `Core.gc_meta_info` | 0 |
| `Core.exit` | 1 |

## TCPServer

TCP sockets (see [HTTP server](/docs/http.html))

| Function | Arity |
|---|---|
| `TCPServer.new` | 1 |
| `TCPServer.close` | 1 |
| `TCPServer.accept` | 1 |
| `TCPServer.receive` | 1 |
| `TCPServer.send` | 2 |
| `TCPServer.disconnect` | 1 |

## Http

HTTP requests and responses (see [HTTP server](/docs/http.html))

| Function | Arity |
|---|---|
| `Http.read_request` | 1 |
| `Http.response` | 3 |
