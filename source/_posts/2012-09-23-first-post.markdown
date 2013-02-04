---
layout: post
title: "First Post"
date: 2012-09-23 01:30
comments: true
categories: 
---
My First Blog Post
==================
(Also, My First Blog)
---------------------
So at this time, I still need a blog title and a custom theme. Not that there's anything wrong with the default one, it just feels too lazy using it. Oh, and then my blog would look like everyone else's who used the default. That's about it, here's some code from the link script I use to manage my dotfiles:

``` bash link.sh excerpt https://github.com/jmatth/dotfiles/blob/master/link.sh
for file in $(git ls-files | egrep -v $IGNORE)
do
	if [ "$(readlink ~/.$file)" != "$DIR/$file" ]
	then
		echo $file
		if test ! -d `dirname ~/.$file`
		then
			mkdir -p `dirname ~/.$file`
		fi
		if test -h ~/.$file
		then
			unlink ~/.$file
		fi
		rm -rf ~/.file 2>&1 >/dev/null
		ln -sf $DIR/$file ~/.$file
	fi
done
```
