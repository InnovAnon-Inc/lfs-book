#! /usr/bin/env -S awk -f

NF && $1 !~ /^#/        { FLAG=0 }

$1 == "#dump-commands:" { FLAG=1 }

FLAG && $0 !~ /rm -rf/  { sub(/^#/,"") }
FLAG && $0  ~ /rm -rf/  { sub(/.*/,"") }

$1 == "all:"            { sub(/#/ ,"") }

                        { print }

