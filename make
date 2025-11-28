#!/bin/sh -eu

if [ $# -ne 3 ]; then
	echo "$0 host sitetitle discussemail" >&2
	exit 1
fi

host="$1"
sitetitle="$2"
discussemail="$3"

for mdpath in $(cd src/root && find . -type f -name '*.md'); do
	mdpath="${mdpath#./}"

	html="build/${mdpath%.md}.html"
	md="src/root/$mdpath"

	if [ -e "$html" ]; then
		continue
	fi

	mkdir -p "$(dirname $html)"

	# If the page is in /articles/ and is not /articles/index.md.
	if [ "${mdpath#articles/}" != "$mdpath" ] \
	&& [ "${mdpath#articles/}" != 'index.md' ]; then
		email="$discussemail"
	else
		email=""
	fi

	printf "Generating $html."

	./scripts/getpage "$sitetitle" "$host" "$md" "$email" > "$html"

	printf "\r\033[KGenerated $html.\n"
done

if [ ! -e 'build/articles/rss.xml' ]; then
	printf "Generating build/articles/rss.xml."

	desc=$(cat 'src/root/articles/index.desc' | tr '\n' ' ')
	pages=$(find src/root/articles -type f -name '*.md' \
	                               ! -path 'src/root/articles/index.md')

	./scripts/getrss "$host" "$discussemail" "$sitetitle" 'articles' \
	                 > 'build/articles/rss.xml'

	printf "\r\033[KGenerated build/articles/rss.xml.\n"
fi

if [ ! -e 'build/robots.txt' ]; then
	cp 'src/robots.txt' 'build/robots.txt'
	echo "Generated build/robots.txt."
fi

./scripts/genicons

if [ ! -e 'build/public' ]; then
	cp -r 'public' 'build'
	echo "Copied public/ to build/public/."
fi

if [ ! -e 'build/favicon.ico' ]; then
	mv 'favicon.ico' 'build'
	echo "Generated build/favicon.ico."
fi
