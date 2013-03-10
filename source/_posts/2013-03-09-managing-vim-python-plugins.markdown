---
layout: post
title: "Managing Vim Python Plugins"
date: 2013-03-10 16:30
comments: true
categories: [vim, dotfiles, python]
---

##Conditionally installing the coolest new Vim plugins.

Anyone who uses Vim regularly is probably familiar with its ever growing list
of useful plugins. Most of these have been traditionally written in Vim's native
scripting language Vimscript. However, it seems there is a growing trend of
developers moving away from this in favor of writing their new plugins in
languages like Python and Ruby, which newer versions of Vim can be compiled with
support for. Unfortunately, this can create a problem for users who what to use
these new plugins, but work on several machines which may or may not meet the
requirements of these plugins. In this post, I'll show how to get around this
problem with [Vundle](https://github.com/gmarik/vundle) and a little bit of
vimrc scripting

<!--more-->

The first step to installing plugins based on the local Vim configuration is
simple: move plugin management inside of Vim. To do this we'll install the
plugin [Vundle](https://github.com/gmarik/vundle), which allows you to specify
which plugins to install in your vimrc. While there is plenty of documentation
on how to install Vundle on its github page, the short version is:

1. Run `git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

2. Add the following to the top of your vimrc:

```vim vimrc
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/

Bundle 'gmarik/vundle'
```

Don't worry about the `filetype off` part, we'll turn it back on after we define
our bundles. If you keep your dotfiles in a git repo, you should also add that
git clone command to your install script so that Vundle will always be
available.

Once we have Vundle installed, we can start adding plugin bundles. I'm a big fan
of fuzzy file searching, so as an example we'll install
[ctrlp](http://github.com/kien/ctrlp.vim)

```vim vimrc
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/

Bundle 'gmarik/vundle'

" Plugin bundles
Bundle 'kien/ctrlp.vim'
```

Now restart Vim or reload your vimrc and enter `:BundleInstall`. This should
open a new window where you can see the progress as the new plugin is installed.

So using Vundle to manage plugins is easy, but what about those cool Python
plugins I mentioned up at the top of the page? For that, let's try installing
[UltiSnips](https://github.com/sirver/ultisnips), a new snippet manager that has
become increasingly popular. The requirements state that it needs to run in a
version of Vim with python or python3 support compiled in and the system must
have Python 2.6 or greater installed. The first requirement is easy, since you
can check what features Vim has been compiled with by using the `has()` function
in your vimrc:

```vim vimrc
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/

Bundle 'gmarik/vundle'

" Plugin bundles
Bundle 'kien/ctrlp.vim'

" Python plugin bundles
if has('python') || has('python3')
	Bundle 'SirVer/ultisnips'
endif
```

Now when you run `:BundleInstall`, whether or not the plugin is installed will
depend on what options Vim was compiled with. Unfortunately, this will not
account for the second condition of the Python version, so on systems with older
versions of Python Vim could install this plugin and break. So the last thing we
need is a way to check the Python version from inside of Vim. To do this we will
set a variable directly in the Python interpreter:

```vim vimrc
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/

Bundle 'gmarik/vundle'

" Plugin bundles
Bundle 'kien/ctrlp.vim'

let s:python_ver = 0
silent! python import sys, vim;
\ vim.command("let s:python_ver="+"".join(map(str,sys.version_info[0:3])))

" Python plugin bundles
if (has('python') || has('python3')) && s:python_ver >= 260
	Bundle 'SirVer/ultisnips'
endif
```

What this addition does is set the script variable `python_ver` to 0, and then
attempts to run Python to change it to the full Python version. If we are in a
version of Vim without Python support, then the variable will simply remain set
to 0, and won't pass the `>= 260` check.

Once last thing we can do is add some fallback plugins to be installed in case
the system we're on doesn't meet the requirements for the new Python versions:

```vim vimrc
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/

Bundle 'gmarik/vundle'

" Plugin bundles
Bundle 'kien/ctrlp.vim'

let s:python_ver = 0
silent! python import sys, vim;
\ vim.command("let s:python_ver="+"".join(map(str,sys.version_info[0:3])))

" Python plugin bundles
if (has('python') || has('python3')) && s:python_ver >= 260
	Bundle 'SirVer/ultisnips'
else
	Bundle 'garbas/vim-snipmate'
endif
```

And there you have it. Now you can drop this config onto virtually any system
and `:BundleInstall` will pull down the correct plugins. For adding plugins from
locations other than GitHub, take a look at the
[Vundle Quick Start](https://github.com/gmarik/vundle#quick-start), and feel
free to drop me a line in the comments if you run into trouble.
