# Zsh Navigation Tools

Videos: [https://youtu.be/kznhIdLFrbk](https://youtu.be/kznhIdLFrbk) [https://youtu.be/JfQd7B0kKPM](https://youtu.be/JfQd7B0kKPM)

Screenshot (more at the [wiki](https://github.com/psprint/zsh-navigation-tools/wiki)):

![n-history](http://imageshack.com/a/img905/8408/TyjE8H.gif)

A tool generating a selectable curses-based list of elements that has access to
current `Zsh` session, i.e. has broad capabilities to work together with it.
That's `n-list`. The files `n-cd`, `n-env`, `n-kill`, etc. are applications of
the tool. Feature highlights include incremental multi-word searching, ANSI
coloring, unique mode, horizontal scroll, non-selectable elements, grepping and
various integrations with `Zsh`.

This is an alternative approach to idea of visual shell, when compared to
Midnight Commander. Here the command line is the main way the shell is used.
From that mode of operation, user call tools that do not require mouse or
typing, only navigating.

## Installation

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zsh-navigation-tools/master/install.sh)"
```

To update run the command again.

`ZNT` will be installed at `~/.config/znt/zsh-navigation-tools`, config files will be copied to `~/.config/znt`.

After installing and reloading shell give `ZNT` a quick try with `Ctrl-R` – this keyboard shortcut will open `n-history`.

## Manual Installation
Copy (or link) all `n-*` files to **/usr/share/zsh/site-functions/** (or **/usr/local/share/zsh/site-functions/**, check with `echo $fpath[1]`) and then add:

    autoload n-list n-cd n-env n-kill n-panelize n-options n-aliases n-functions n-history

to `~/.zshrc`.

Create aliases to avoid typing of the minus sign "-":

```zsh
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize
```

Don't forget to copy [configuration files](https://github.com/psprint/zsh-navigation-tools/tree/master/.config/znt). They should go to `~/.config/znt`. Moreover, `n-cd` works together with option `AUTO_PUSHD` and you should have:

```zsh
setopt AUTO_PUSHD
```

in `.zshrc` (also recommend `PUSHD_IGNORE_DUPS`). Without the option `n-cd`
will just work as incremental searcher of directory bookmarks.

## History Widget

To have `n-history` as the incremental searcher bound to `Ctrl-R` copy `znt-*`
files into the `*/site-functions` dir (unless you do single file install) and
add:

```zsh
autoload znt-history-widget
zle -N znt-history-widget
bindkey "^R" znt-history-widget
```

to `.zshrc`. This is done automatically when using the installer.

## Single File Manual Installation

Running script `doc/generate_plugin` will create single-file version of `ZNT`.
It can be sourced from `.zshrc` or added to `oh-my-zsh` (create directory
`plugins/zshnavigationtools` and copy the plugin there). Don't forget
about configuration files as described above.

## Introduction

The tools are:

- `n-aliases` - browses aliases, relegates editing to `vared`
- `n-cd` - browses dirstack and bookmarked directories, allows to enter selected directory
- `n-functions` - browses functions, relegates editing to `zed` or `vared`
- `n-history` - browses history, allows to edit and run commands from it
- `n-kill` - browses processes list, allows to send signal to selected process
- `n-env` - browses environment, relegates editing to `vared`
- `n-options` - browses options, allows to toggle their state
- `n-panelize` - loads output of given command into the list for browsing

All tools support horizontal scroll with `<`,`>` or `{`,`}`. Other keys are:

- `[`,`]` - jump directory bookmarks in `n-cd` and typical signals in `n-kill`
- `Ctrl-d`, `Ctrl-u` - half page up or down
- `Ctrl-p`, `Ctrl-n` - previous and next (also done with vim's j,k)
- `Ctrl-l` - redraw of whole display
- `g, G` - beginning and end of the list
- `Ctrl-o`, `o` - enter uniq mode (no duplicate lines)
- `/` - start incremental search
- `Enter` - finish incremental search, retaining filter
- `Esc` - exit incremental search, clearing filter
- `Ctrl-w` (in incremental search) - delete whole word
- `Ctrl-k` (in incremental search) - delete whole line

## Programming

The function `n-list` is used as follows:

```zsh
n-list {element1} [element2] ... [elementN]
```

This is all that is needed to be done to have the features like ANSI coloring,
incremental multi-word search, unique mode, horizontal scroll, non-selectable
elements (grepping is done outside `n-list`, see the tools for how it can be
done). To set up non-selectable entries add their indices into array
`NLIST_NONSELECTABLE_ELEMENTS`:

```zsh
typeset -a NLIST_NONSELECTABLE_ELEMENTS
NLIST_NONSELECTABLE_ELEMENTS=( 1 )
```

Result is stored as `$reply[REPLY]` (`$` isn't needed before `REPLY` because
of arithmetic context inside `[]`). The returned array might be different from
input arguments as `n-list` can process them via incremental search or uniq
mode. `$REPLY` is the index in that possibly processed array. If `$REPLY`
equals `-1` it means that no selection have been made (user quitted via `q`
key).

To set up entries that can be jumped to with `[`,`]` keys add their indices to
`NLIST_HOP_INDEXES` array:

```zsh
typeset -a NLIST_HOP_INDEXES
NLIST_HOP_INDEXES=( 1 10 )
```

`n-list` can automatically colorize entries according to a `Zsh` pattern.
Following example will colorize all numbers with blue:

```zsh
local NLIST_COLORING_PATTERN="[0-9]##"
local NLIST_COLORING_COLOR=$'\x1b[00;34m'
local NLIST_COLORING_END_COLOR=$'\x1b[0m'
local NLIST_COLORING_MATCH_MULTIPLE=1

n-list "This is a number 123" "This line too has a number: 456"
```

Blue is the default color, it doesn't have to be set. See `zshexpn` man page
for more information on `Zsh` patterns. Briefly, comparing to regular
expressions, `(#s)` is `^`, `(#e)` is `$`, `#` is `*`, `##` is `+`. Alternative
will work when in parenthesis, i.e. `(a|b)`.
