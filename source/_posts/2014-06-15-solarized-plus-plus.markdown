---
layout: post
title: "Solarized++"
date: 2014-06-15 10:28:07 -0700
comments: true
categories: [dotfiles, vim, terminal]
---

A long time ago, I ran across [Solarized](http://ethanschoonover.com/solarized),
a very popular colorscheme for the terminal and most text editors. While my
first reaction was something along the lines of "Eww, blue background?", I
eventually gave it a try because of how highly recommend it was.  In less than a
week it became my favorite color scheme because of how easy on the eyes it is
and how well the syntax highlighting fits together (both results of the scheme's
[careful design](http://ethanschoonover.com/solarized#features)).  After using
the theme for some time though, I ran into a couple problems with it. One was
actually a well known bug that made some text unreadable, and the other was just
something I thought could be made easier. I'm writing about my fixes for both
problems here so that others who have the same problems can solve them faster in
the future.

<!-- MORE -->

1. The "Bright Black" Terminal Color Is Invisible
-------------------------------------------------

{% img right /downloads/pictures/solarized_problems.png 'This is not what the output should look like.' 'Bright black text invisible in solarized.' %}
This is a long standing issue that has been
[extensively](https://github.com/visionmedia/express/issues/1700)
[documented](https://github.com/gruntjs/grunt/issues/181)
[on](https://github.com/altercation/solarized/issues/220)
[github](https://github.com/visionmedia/mocha/issues/802).  When designing
Solarized, Ethan Schoonover had to make some compromises on the colors that
would be available in order to ensure compatibility with 16 color terminals.
This involved using some of the bright/bold versions of certain colors to make
up the grey "content tones" section of the scheme, and using the "bright black"
color for one of the dark background tones. Unfortunately, some programs use
this color, and those using Solarized as their color scheme will find some of
their output unreadable, since it is the same color as the terminal background.
Even with all the issues open on the subject, it remains a problem because the
Solarized palette needs all 16 colors and many program authors are unwilling to
alter their code just so it works in one particular colorscheme.  After digging
through multiple github issues on the topic, it seems that nobody has yet come
up with a solution to the problem.

####The Fix

If we had an extra color to work with, then we could use it for the second dark
background tone and leave bright black as something visible. Unfortunately
we're limited to 16 color codes in the terminal, but most terminal emulators allow
you to set the background color independently of the 16 color palette.
Therefore, my solution to the problem is to redefine the bright black color in
the terminal palette to something other than the background tone (I used the
value for the "base01" color in solarized, but it could be anything), and set
the background of any program that supports it to be transparent (or no color).
This will allow the correct background color, set in the terminal emulator, to
show through. Any text that wants to be this color will also have to be set to
transparent, but not every program has a simple way of configuring this. As a
workaround, set the background of the text in question to be transparent and the
foreground to be whatever you want to background to be, and then invert the
colors. In the shell ANSI escape codes this would look something like
`\e[34;49;7m`.

### Example Tweaking Vim

In vim you can already fix this in most cases by putting `let
g:solarized_termtrans = 1` in your vimrc, but there are a few edge cases that
will still get the incorrect color. To fix this, modify the solarized
colorscheme at line 285 to read `let s:base03 = "NONE"`. This will allow the
background tone to fall through to the terminal emulator background throughout
vim. For some reason the `SignColumn` (where syntastic and other plugins put
their marks) still uses the wrong color, so you also need to change line 657 to
read `exe "hi! SignColumn"     .s:fmt_none   .s:fg_base0  .s:bg_base03`. You can
download a copy with these modifications from
[here](/downloads/code/solarized/solarized-mod.vim) if you'd like. I'll leave it
up to you to modify your terminal's colorscheme.

2. Switching Between The Light And Dark Palette Can Be Easier
-------------------------------------------------------------

One of the biggest selling points of Solarized is that it has two variants, one
with a light background and one with a dark background, and both provide the
same contrast against each text color. While this is certainly a nice feature,
the procedure for switching between the two is just a bit too much. Assuming
you're using Solarized in a terminal you have to:

{% img right /downloads/pictures/solarized_mixed.png 400 'Terminal: Solarized Light, Vim: Solarized Dark' 'Solarized light and dark palettes conflicting.' %}
1. Change the version your terminal emulator is using
2. Switch the version the programs inside your terminal emulator are using.

And if the version you're switching to is not the default that your programs
start up with, you'll have to repeat step 2 every time you open a new instance
of a program that uses Solarized, or have it trying to us the light colorscheme
with the dark palette, which does not work.

####The Fix

If you read the
[Solarized hompage](http://ethanschoonover.com/solarized#usage-development)
you'll see that switching between the light and dark palettes involves switching
the two background colors and the four gray "content tones". Most colorschemes
check which version you are using (e.g. checking the value of `background` in
vim), and then set the colors accordingly. However, since the palette is
controlled by the terminal emulator we should just be able to swap the values
there and let any programs running inside of it think they're always in the
default palette. Since the default is almost always the dark one, I just copied
the dark terminal palette and swapped the values for:

- `black` with `white`
- `brblack` with `brwhite`
- `bryellow` with `brblue`
- `brgreen` with `brcyan`

Using this modified palette in place of the normal light one, you can easily
switch between the two palettes just by changing the pallete in your terminal
emulator, no changes to your programs required.

Final Thoughts
--------------

Of the two issues and solutions I've discussed, one is a long standing issue
with the colorscheme that has certainly seen some people pass over or abandon
it, and the other is just a small change that I think makes using it in the
terminal a bit smoother. So why not submit at least the unreadable text fix in a
pull request and solve everyones problems with it? Part of the reason is the
amount of work that would need to go into that sort of change. All of the
colorschemes for the different terminal emulators and programs would need to be
changed and tested, which makes for quite a few config files written in a
variety of different languages, not to mention individual PRs would need to be
made to each of the program-specific repos. Another is the probable futility of
doing so; the last update to the main repo was almost a year ago, despite a
steady stream of pull requests for various small changes. I find it unlikely
that a pull request rewriting a large portion of the code will be well received,
assuming anyone is still checking incoming issues and PRs at all. It's possible
that at some point in the future I might put in this work anyway, and just
create a new fork of the colorscheme if the PR is not accepted, but that's all
up in the air for the time being. Anyone who wants my combined versions of these
fixes from [my dotfiles](http://github.com/jmatth/dotfiles) can copy them from
that repo (I currently have customized configs for
[vim](https://github.com/jmatth/dotfiles/blob/master/link/.vim/colors/solarized.vim),
[roxterm](https://github.com/jmatth/dotfiles/tree/master/copy/.config/roxterm.sourceforge.net/Colours),
and [iterm](https://github.com/jmatth/dotfiles/tree/master/aux/iterm)). If
anyone runs across this and needs help implementing the fixes for their favorite
program, feel free to drop me a line in the comments or on
[Twitter](http://twitter.com/jmatth92) and I'll try to help out. Happy (low
contrast) hacking.

Josh
