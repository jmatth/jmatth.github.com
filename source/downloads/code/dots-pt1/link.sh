#!/usr/bin/env bash

# Ignore certain files
IGNORE="link\.sh"

# Get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "\e[1;35mSymlinking config files:\e[m"
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
		rm -rf ~/.$file 2>&1 >/dev/null
		ln -sf $DIR/$file ~/.$file
	fi
done
