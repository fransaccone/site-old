include config.mk

PAGES = index.html \
        git/index.html \
        articles/index.html \
        articles/nixos-the-ultimate-computing-solution/index.html \

PAGE404 = 404.html
PAGE5XX = 5xx.html

FAVICON  = favicon.ico
RSS      = $(RSSDIR)/rss.xml
SITEMAP  = sitemap.xml
ICON4096 = public/icon4096.png
ICON2048 = public/icon2048.png
ICON1024 = public/icon1024.png
ICON512  = public/icon512.png
ICON256  = public/icon256.png
ICON128  = public/icon128.png
ICON64   = public/icon64.png
ICON48   = public/icon48.png
ICON32   = public/icon32.png
ICON24   = public/icon24.png
ICON16   = public/icon16.png

RSSDIR   = articles

ICONSVG = public/icon.svg

HEADER = header.html
FOOTER = footer.html

.PHONY: all clean install uninstall

all: $(PAGES) $(PAGE404) $(PAGE5XX) $(FAVICON) $(RSS) $(SITEMAP) $(ICON4096) \
     $(ICON2048) $(ICON1024) $(ICON512) $(ICON256) $(ICON128) $(ICON64) \
     $(ICON48) $(ICON32) $(ICON24) $(ICON16)

clean:
	rm -f $(PAGES) $(PAGE404) $(PAGE5XX) $(FAVICON) $(RSS) $(SITEMAP) \
	$(ICON4096) $(ICON2048) $(ICON1024) $(ICON512) $(ICON256) $(ICON128) \
	$(ICON64) $(ICON48) $(ICON32) $(ICON24) $(ICON16)

install: $(PAGES) $(RSS) $(SITEMAP)
	for f in $(PAGES) $(FAVICON) $(RSS) $(SITEMAP) $(ICON4096) \
	         $(ICON2048) $(ICON1024) $(ICON512) $(ICON256) $(ICON128) \
	         $(ICON64) $(ICON48) $(ICON32) $(ICON24) $(ICON16) public \
	         robots.txt; do \
		mkdir -p $(DESTDIR)$(PREFIX)/$$(dirname $$f); \
		cp -rf $$f $(DESTDIR)$(PREFIX)/$$(dirname $$f); \
	done

uninstall:
	for f in $(PAGES) $(FAVICON) $(RSS) $(SITEMAP) $(ICON4096) \
	         $(ICON2048) $(ICON1024) $(ICON512) $(ICON256) $(ICON128) \
	         $(ICON64) $(ICON48) $(ICON32) $(ICON24) $(ICON16) public \
	         robots.txt; do \
		rm -rf $(DESTDIR)$(PREFIX)/$$f; \
	done

$(PAGES) $(PAGE404) $(PAGE5XX):
	title=$$(cat $(@:.html=.title) 2> /dev/null || echo ''); \
	title=$$(if [ -n "$$title" ]; then echo " — $$title"; fi); \
	title="$(TITLE)$$title"; \
	cat $(HEADER) \
	| sed "s/@TITLE@/$$title/g" \
	| sed "s/@DESCRIPTION@/$$(tr '\n' ' ' < $(@:.html=.desc))/g" \
	| tr -d '\n\t' | sed -e 's/  \+/ /g' > $@

	LOWDOWN=$(LOWDOWN) ./utils/genhtml $(HOST) $(@:.html=.md) >> $@

	cat $(FOOTER) | tr -d '\n\t' | sed 's/  \+/ /g' >> $@

$(FAVICON): $(ICON256) $(ICON128) $(ICON64) $(ICON48) $(ICON32) $(ICON24) \
            $(ICON16)
	$(MAGICK) $^ $@

$(ICON4096):
	$(INKSCAPE) -w 4096 -h 4096 $(ICONSVG) -o $@

$(ICON2048):
	$(INKSCAPE) -w 2048 -h 2048 $(ICONSVG) -o $@

$(ICON1024):
	$(INKSCAPE) -w 1024 -h 1024 $(ICONSVG) -o $@

$(ICON512):
	$(INKSCAPE) -w 512 -h 512 $(ICONSVG) -o $@

$(ICON256):
	$(INKSCAPE) -w 256 -h 256 $(ICONSVG) -o $@

$(ICON128):
	$(INKSCAPE) -w 128 -h 128 $(ICONSVG) -o $@

$(ICON64):
	$(INKSCAPE) -w 64 -h 64 $(ICONSVG) -o $@

$(ICON48):
	$(INKSCAPE) -w 48 -h 48 $(ICONSVG) -o $@

$(ICON32):
	$(INKSCAPE) -w 32 -h 32 $(ICONSVG) -o $@

$(ICON24):
	$(INKSCAPE) -w 24 -h 24 $(ICONSVG) -o $@

$(ICON16):
	$(INKSCAPE) -w 16 -h 16 $(ICONSVG) -o $@

$(RSS):
	LOWDOWN=$(LOWDOWN) ./utils/genrss $(HOST) "$(RSSTITLE)" $(RSSDIR) \
	                                  $(PAGES) > $@

$(SITEMAP):
	./utils/gensitemap $(HOST) $(PAGES) > $@
