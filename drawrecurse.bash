#!/bin/bash
function recurse () {
	SUBS=$(find $1 -mindepth 1 -maxdepth 1 -type d)
	FILES=$(find $1 -mindepth 1 -maxdepth 1 -type f)
	for b in $FILES
	do
		HASH=$(hashdeep $b -l|tail -n 1|sed 's#\(.*\),\(.*\),\(.*\),\(.*\)#\4\\nsize:\1bytes\\nmd5:\2\\nsha256:\3#') 
		echo $HASH
		echo "\"$1\" -> \"$HASH\";" >> $DOTFILE
	done
	for a in $SUBS
	do
		echo "\"$1\" -> \"$a\";" >> $DOTFILE
		recurse $a
	done
}
DOTFILE=tree.dot
export IFS=$'\n'
echo "digraph unix {" > $DOTFILE
echo "overlap=false;" >> $DOTFILE
echo "rankdir=LR;" >> $DOTFILE
echo "node [color=blue, style=filled, fillcolor=lightblue2, shape=box, fontname=Consolas];" >> $DOTFILE
recurse $1
echo "}" >> $DOTFILE
dot -Tpdf $DOTFILE > dot.pdf
neato -Tpdf $DOTFILE > neato.pdf
circo -Tpdf $DOTFILE > circo.pdf
sfdp -Tpdf $DOTFILE > sfdp.pdf
