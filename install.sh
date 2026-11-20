#!/bin/sh
# Drax installer: builds the interpreter (and the package manager dmr) from source.
#
#   curl -fsSL https://drax-lang.github.io/install.sh | sh
#
# With options (note the "-s --"):
#
#   curl -fsSL https://drax-lang.github.io/install.sh | sh -s -- --prefix /usr/local
#   curl -fsSL https://drax-lang.github.io/install.sh | sh -s -- --ref v0.1.0 --no-dmr
#
# Options:
#   --prefix DIR   install into DIR/bin (default: $HOME/.local, or /usr/local for root)
#   --ref REF      branch, tag or commit to build (default: main)
#   --source DIR   build the sources in DIR instead of downloading them
#   --no-dmr       do not build or install dmr, the package manager
#   --light        build without libedit (no line editing in the interactive shell)
#   --uninstall    remove drax and dmr from DIR/bin
#   -h, --help     show this help
#
# Environment:
#   DRAX_SHA256    expected SHA-256 of the downloaded archive; the install stops if it differs
#   CC             the C compiler (default: gcc, cc or clang, the first one found)
#
# What it does: downloads the source archive from GitHub over HTTPS, builds it in a
# temporary directory with make, copies bin/drax (and dmr) to DIR/bin and runs
# "drax --version". It never uses sudo: when DIR/bin is not writable it stops and tells
# you what to do. Nothing outside DIR/bin and the temporary directory is changed.
#
# The whole script is inside main(), which is called at the last line: a download that is
# cut in half does not run.

REPO="drax-lang/drax"

say()  { printf '%s\n' "$*"; }
note() { printf 'drax-install: %s\n' "$*"; }
fail() { printf 'drax-install: error: %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF_USAGE'
Drax installer: builds the interpreter (and the package manager dmr) from source.

  curl -fsSL https://drax-lang.github.io/install.sh | sh
  curl -fsSL https://drax-lang.github.io/install.sh | sh -s -- --prefix /usr/local

Options:
  --prefix DIR   install into DIR/bin (default: $HOME/.local, or /usr/local for root)
  --ref REF      branch, tag or commit to build (default: main)
  --source DIR   build the sources in DIR instead of downloading them
  --no-dmr       do not build or install dmr, the package manager
  --light        build without libedit (no line editing in the interactive shell)
  --uninstall    remove drax and dmr from DIR/bin
  -h, --help     show this help

Environment:
  DRAX_SHA256    expected SHA-256 of the downloaded archive; the install stops if it differs
  CC             the C compiler (default: gcc, cc or clang, the first one found)

It never uses sudo. When DIR/bin is not writable it stops and tells you what to do.
EOF_USAGE
}

have() { command -v "$1" >/dev/null 2>&1; }

# the first of the arguments that is installed
first_of() {
  for c in "$@"; do
    if have "$c"; then printf '%s' "$c"; return 0; fi
  done
  return 1
}

install_hint() {
  # what to install, by system
  if have apt-get; then say "  sudo apt-get install build-essential curl tar"
  elif have dnf; then say "  sudo dnf install gcc make curl tar"
  elif have pacman; then say "  sudo pacman -S base-devel curl tar"
  elif have apk; then say "  sudo apk add build-base curl tar"
  elif have brew; then say "  xcode-select --install"
  elif [ "$(uname -s)" = "Darwin" ]; then say "  xcode-select --install"
  else say "  install a C compiler (gcc or clang), GNU make, curl and tar with your package manager"
  fi
}

download() { # url, destination
  if have curl; then
    curl -fsSL --proto '=https' --proto-redir '=https' --tlsv1.2 --retry 3 -o "$2" "$1"
  elif have wget; then
    wget -q --https-only -O "$2" "$1"
  else
    fail "curl or wget is needed to download Drax"
  fi
}

sha256_of() {
  if have sha256sum; then sha256sum "$1" | cut -d ' ' -f 1
  elif have shasum; then shasum -a 256 "$1" | cut -d ' ' -f 1
  elif have openssl; then openssl dgst -sha256 "$1" | sed 's/^.*= //'
  else fail "DRAX_SHA256 was set but there is no sha256sum, shasum or openssl to check it"
  fi
}

# can the compiler build with libedit (line editing in the shell)?
has_libedit() { # compiler
  printf '#include <editline/readline.h>\nint main(void) { return 0; }\n' | \
    "$1" -x c - -ledit -o /dev/null >/dev/null 2>&1
}

path_has() {
  case ":$PATH:" in
    *":$1:"*) return 0 ;;
    *) return 1 ;;
  esac
}

main() {
  prefix=""
  ref="main"
  source_dir=""
  with_dmr=1
  light=0
  uninstall=0

  while [ $# -gt 0 ]; do
    case "$1" in
      --prefix)    [ $# -ge 2 ] || fail "--prefix needs a directory (example: --prefix /usr/local)"; prefix=$2; shift 2 ;;
      --prefix=*)  prefix=${1#--prefix=}; shift ;;
      --ref)       [ $# -ge 2 ] || fail "--ref needs a branch, tag or commit (example: --ref v0.1.0)"; ref=$2; shift 2 ;;
      --ref=*)     ref=${1#--ref=}; shift ;;
      --source)    [ $# -ge 2 ] || fail "--source needs a directory"; source_dir=$2; shift 2 ;;
      --source=*)  source_dir=${1#--source=}; shift ;;
      --no-dmr)    with_dmr=0; shift ;;
      --light)     light=1; shift ;;
      --uninstall) uninstall=1; shift ;;
      -h|--help)   usage; exit 0 ;;
      *)           fail "unknown option '$1'. Use --help to see the options." ;;
    esac
  done

  if [ -z "$prefix" ]; then
    if [ "$(id -u 2>/dev/null || echo 1)" = "0" ]; then prefix=/usr/local; else prefix=$HOME/.local; fi
  fi
  [ -n "$prefix" ] && [ "$prefix" != "/" ] || fail "the prefix '$prefix' is not valid"
  bindir=$prefix/bin

  # the reference goes into a URL: only the characters of branch, tag and commit names
  case "$ref" in
    ""|*[!A-Za-z0-9._/-]*|*..*|/*) fail "the reference '$ref' is not valid (letters, digits, . _ - and / only)" ;;
  esac

  # --- uninstall -------------------------------------------------------
  if [ "$uninstall" = "1" ]; then
    removed=0
    for f in drax dmr; do
      if [ -f "$bindir/$f" ]; then
        rm -f "$bindir/$f" || fail "cannot remove $bindir/$f (permission denied? try with sudo, or the same --prefix you installed with)"
        say "removed $bindir/$f"
        removed=1
      fi
    done
    [ "$removed" = "1" ] || say "nothing to remove in $bindir"
    exit 0
  fi

  # --- system ------------------------------------------------------------
  os=$(uname -s 2>/dev/null || echo unknown)
  case "$os" in
    Linux|Darwin|FreeBSD|OpenBSD|NetBSD|DragonFly) ;;
    MINGW*|MSYS*|CYGWIN*) fail "Windows is not supported by this script. Build with MinGW-w64: see https://drax-lang.github.io/installation/" ;;
    *) fail "unknown system '$os'. Build from source: see https://drax-lang.github.io/installation/" ;;
  esac

  # --- tools -------------------------------------------------------------
  missing=""
  cc=${CC:-}
  if [ -n "$cc" ]; then
    have "$cc" || fail "the compiler CC='$cc' was not found"
  else
    cc=$(first_of gcc cc clang) || { missing="$missing a C compiler (gcc or clang),"; cc=""; }
  fi

  # the Makefile needs GNU make (gmake on the BSDs)
  mk=$(first_of gmake make) || { missing="$missing make,"; mk=""; }
  if [ -n "$mk" ] && ! "$mk" --version 2>/dev/null | grep -q "GNU Make"; then
    fail "GNU make is needed, and '$mk' is not GNU make. Install it (on the BSDs: the package 'gmake')."
  fi

  have tar || missing="$missing tar,"
  if [ -z "$source_dir" ] && ! have curl && ! have wget; then missing="$missing curl or wget,"; fi

  if [ -n "$missing" ]; then
    printf 'drax-install: error: missing:%s\n' "${missing%,}" >&2
    say "Install them first, for example:" >&2
    install_hint >&2
    exit 1
  fi

  # --- where it goes -------------------------------------------------------
  if [ ! -d "$bindir" ]; then
    mkdir -p "$bindir" 2>/dev/null || fail "cannot create $bindir. Choose a directory you can write with --prefix, or run with sudo (example: --prefix /usr/local)"
  fi
  [ -w "$bindir" ] || fail "cannot write in $bindir. Choose a directory you can write with --prefix (example: --prefix \$HOME/.local), or run this script with sudo"

  work=$(mktemp -d "${TMPDIR:-/tmp}/drax-install.XXXXXX") || fail "cannot create a temporary directory"
  trap 'rm -rf "$work"' EXIT INT TERM

  # --- the source ------------------------------------------------------------
  if [ -n "$source_dir" ]; then
    [ -f "$source_dir/Makefile" ] && [ -d "$source_dir/src" ] || fail "'$source_dir' does not look like the Drax source (no Makefile and src/)"
    note "building the source in $source_dir"
    mkdir -p "$work/src" && cp -R "$source_dir/." "$work/src/" || fail "cannot copy the source"
    src=$work/src
  else
    url="https://github.com/$REPO/archive/$ref.tar.gz"
    note "downloading $url"
    download "$url" "$work/drax.tar.gz" || fail "cannot download $url (is the reference '$ref' right? check your connection)"

    if [ -n "${DRAX_SHA256:-}" ]; then
      got=$(sha256_of "$work/drax.tar.gz")
      [ "$got" = "$DRAX_SHA256" ] || fail "the SHA-256 of the download is $got, but DRAX_SHA256 is $DRAX_SHA256. Nothing was installed."
      note "SHA-256 checked"
    fi

    mkdir -p "$work/src" || fail "cannot create a directory in $work"
    tar -xzf "$work/drax.tar.gz" -C "$work/src" --strip-components=1 || fail "cannot extract the archive (it may not be a valid download)"
    src=$work/src
  fi

  [ -f "$src/Makefile" ] || fail "the archive has no Makefile: '$ref' is not a Drax source tree"

  # --- build -------------------------------------------------------------------
  if [ "$light" = "0" ] && ! has_libedit "$cc"; then
    note "libedit was not found: building without it (no line editing in the interactive shell)."
    note "to get it: libedit-dev on Debian/Ubuntu, libedit-devel on Fedora."
    light=1
  fi

  note "building drax with $cc"
  (
    cd "$src" || exit 1
    mkdir -p bin
    if [ "$light" = "1" ]; then
      "$mk" all CC="$cc" LIGHT=1
    else
      "$mk" all CC="$cc"
    fi
  ) >"$work/build.log" 2>&1 || {
    tail -n 25 "$work/build.log" >&2
    fail "the build failed (the last lines of the log are above)"
  }
  [ -x "$src/bin/drax" ] || fail "the build finished but bin/drax does not exist"

  if [ "$with_dmr" = "1" ]; then
    if [ -d "$src/dmr" ]; then
      note "building dmr"
      ( cd "$src/dmr" && "$mk" CC="$cc" ) >"$work/build-dmr.log" 2>&1 || {
        tail -n 25 "$work/build-dmr.log" >&2
        fail "the build of dmr failed (use --no-dmr to install only drax)"
      }
      [ -x "$src/dmr/bin/dmr" ] || fail "the build finished but dmr/bin/dmr does not exist"
    else
      note "this version has no dmr: installing only drax"
      with_dmr=0
    fi
  fi

  # --- install -----------------------------------------------------------------
  copy_bin() { # source, destination name
    cp "$1" "$bindir/$2.new" && chmod 755 "$bindir/$2.new" && mv -f "$bindir/$2.new" "$bindir/$2" \
      || { rm -f "$bindir/$2.new"; fail "cannot write $bindir/$2"; }
  }

  copy_bin "$src/bin/drax" drax
  if [ "$with_dmr" = "1" ]; then copy_bin "$src/dmr/bin/dmr" dmr; fi

  version=$("$bindir/drax" --version 2>&1) || fail "drax was installed in $bindir but does not run: $version"

  say ""
  say "$version"
  say "installed in $bindir:"
  say "  drax"
  [ "$with_dmr" = "1" ] && say "  dmr"

  if ! path_has "$bindir"; then
    say ""
    say "$bindir is not in your PATH. Add this line to your shell profile (~/.profile, ~/.bashrc or ~/.zshrc):"
    say ""
    say "  export PATH=\"$bindir:\$PATH\""
  fi

  say ""
  say "try it:  echo 'print(\"hello\")' > hello.dx && drax hello.dx"
  say "docs:    https://drax-lang.github.io/documentation/"
}

main "$@"
