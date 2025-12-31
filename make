#!/bin/sh -eu

build=${BUILD:-'build'}

src='src'
root="$src/root"

sitetitle=$(cat src/title)

if [ $# -ne 2 ]; then
	echo "$0 host discussemail" >&2
	exit 1
fi

host="$1"
discussemail="$2"

for mdpath in $(cd "$root" && find . -type f -name '*.md'); do
	mdpath="${mdpath#./}"

	html="$build/${mdpath%.md}.html"
	md="$root/$mdpath"

	if [ -e "$html" ]; then
		continue
	fi

	mkdir -p "$(dirname $html)"

	# If the page is in /blog/ and is not /blog/index.md.
	if [ "${mdpath#blog/}" != "$mdpath" ] \
	&& [ "${mdpath#blog/}" != 'index.md' ]; then
		email="$discussemail"
	else
		email=""
	fi

	printf "Generating $html."

	./scripts/getpage "$sitetitle" "$host" "$md" "$src/header.html" \
	                  "$src/footer.html" "$email" > "$html"

	printf "\r\033[KGenerated $html.\n"
done

if [ ! -e "$build/sitemap.xml" ]; then
	printf "Generating $build/sitemap.xml."

	./scripts/getsitemap "$host" "$root" \
	                     $(find src/root -type f -name '*.md' \
	                                     ! -path "$root/404.md" \
	                                     ! -path "$root/5xx.md") \
	                     > "$build/sitemap.xml"

	printf "\r\033[KGenerated $build/sitemap.xml.\n"
fi

if [ ! -e "$build/blog/rss.xml" ]; then
	printf "Generating $build/blog/rss.xml."

	desc=$(cat "$root/blog/index.desc" | tr '\n' ' ')
	pages=$(find "$root/blog" -type f -name '*.md' \
	                              ! -path "$root/blog/index.md")

	./scripts/getrss "$host" "$discussemail" "$sitetitle" "$desc" \
	                 "$root" 'blog' $pages > "$build/blog/rss.xml"

	printf "\r\033[KGenerated $build/blog/rss.xml.\n"
fi

if [ ! -e "$build/robots.txt" ]; then
	cp "$src/robots.txt" "$build/robots.txt"
	echo "Generated $build/robots.txt."
fi

mkdir -p "$build/public"

for f in public/*; do
	if [ ! -e "$build/$f" ]; then
		cp -r "$f" "$build/public"
		echo "Copied $f to $build/public/."
	fi
done

for f in fonts.css style.css script.js; do
	if [ ! -e "$build/public/$f" ]; then
		./scripts/minimize < "src/$f" > "$build/public/$f"
		echo "Generated $build/public/$f."
	fi
done

for svg in "$src"/icon/*.svg; do
	./scripts/genicons "$svg" "$build/public"

	if [ ! -e "$build/public/$(basename $svg)" ]; then
		cp "$svg" "$build/public"
		echo "Copied $svg to $build/public/."
	fi
done

if [ ! -e "$build/favicon.ico" ]; then
	./scripts/genfavicon "$build/favicon.ico" "$build/public/icon48.png" \
	                                          "$build/public/icon32.png" \
	                                          "$build/public/icon16.png"

	echo "Generated $build/favicon.ico."
fi
