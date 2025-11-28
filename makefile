include config.mk

PAGES = index.html \
        git/index.html \
        articles/index.html \
        articles/nixos-the-ultimate-computing-solution/index.html \

PAGE404 = 404.html
PAGE5XX = 5xx.html

FAVICON  = favicon.ico
SITEMAP  = sitemap.xml

RSSDIR = articles
RSS    = $(RSSDIR)/rss.xml

ICON4096       = public/icon4096.png
ICON2048       = public/icon2048.png
ICON1024       = public/icon1024.png
ICON512        = public/icon512.png
ICON256        = public/icon256.png
ICON128        = public/icon128.png
ICON64         = public/icon64.png
ICON48         = public/icon48.png
ICON32         = public/icon32.png
ICON24         = public/icon24.png
ICON16         = public/icon16.png
ICONBG4096     = public/iconbg4096.png
ICONBG2048     = public/iconbg2048.png
ICONBG1024     = public/iconbg1024.png
ICONBG512      = public/iconbg512.png
ICONBG256      = public/iconbg256.png
ICONBG128      = public/iconbg128.png
ICONBG64       = public/iconbg64.png
ICONBG48       = public/iconbg48.png
ICONBG32       = public/iconbg32.png
ICONBG24       = public/iconbg24.png
ICONBG16       = public/iconbg16.png
ICONCIRCLE4096 = public/iconcircle4096.png
ICONCIRCLE2048 = public/iconcircle2048.png
ICONCIRCLE1024 = public/iconcircle1024.png
ICONCIRCLE512  = public/iconcircle512.png
ICONCIRCLE256  = public/iconcircle256.png
ICONCIRCLE128  = public/iconcircle128.png
ICONCIRCLE64   = public/iconcircle64.png
ICONCIRCLE48   = public/iconcircle48.png
ICONCIRCLE32   = public/iconcircle32.png
ICONCIRCLE24   = public/iconcircle24.png
ICONCIRCLE16   = public/iconcircle16.png

ICONS = $(ICON4096) $(ICON2048) $(ICON1024) $(ICON512) $(ICON256) $(ICON128) \
        $(ICON64) $(ICON48) $(ICON32) $(ICON24) $(ICON16)
ICONBGS = $(ICONBG4096) $(ICONBG2048) $(ICONBG1024) $(ICONBG512) $(ICONBG256) \
          $(ICONBG128) $(ICONBG64) $(ICONBG48) $(ICONBG32) $(ICONBG24) \
          $(ICONBG16)
ICONCIRCLES = $(ICONCIRCLE4096) $(ICONCIRCLE2048) $(ICONCIRCLE1024) \
              $(ICONCIRCLE512) $(ICONCIRCLE256) $(ICONCIRCLE128) \
              $(ICONCIRCLE64) $(ICONCIRCLE48) $(ICONCIRCLE32) $(ICONCIRCLE24) \
              $(ICONCIRCLE16)

ICONSVG       = public/icon.svg
ICONBGSVG     = public/iconbg.svg
ICONCIRCLESVG = public/iconcircle.svg

HEADER = header.html
FOOTER = footer.html

.PHONY: all clean install uninstall

all: $(PAGES) $(PAGE404) $(PAGE5XX) $(FAVICON) $(RSS) $(SITEMAP) $(ICONS) \
     $(ICONBGS) $(ICONCIRCLES)

clean:
	rm -f $(PAGES) $(PAGE404) $(PAGE5XX) $(FAVICON) $(RSS) $(SITEMAP) \
	      $(ICONS) $(ICONBGS) $(ICONCIRCLES)

install: $(PAGES) $(RSS) $(SITEMAP)
	for f in $(PAGES) $(FAVICON) $(RSS) $(SITEMAP) $(ICONS) \
	         $(ICONBGS) $(ICONCIRCLES) public robots.txt; do \
		mkdir -p $(DESTDIR)$(PREFIX)/$$(dirname $$f); \
		cp -rf $$f $(DESTDIR)$(PREFIX)/$$(dirname $$f); \
	done

uninstall:
	for f in $(PAGES) $(FAVICON) $(RSS) $(SITEMAP) $(ICONS) \
	         $(ICONBGS) $(ICONCIRCLES) public robots.txt; do \
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

	LOWDOWN=$(LOWDOWN) ./scripts/genhtml $(HOST) $(EMAIL) \
	                                     $(@:.html=.md) >> $@

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

$(ICONBG4096):
	$(INKSCAPE) -w 4096 -h 4096 $(ICONBGSVG) -o $@

$(ICONBG2048):
	$(INKSCAPE) -w 2048 -h 2048 $(ICONBGSVG) -o $@

$(ICONBG1024):
	$(INKSCAPE) -w 1024 -h 1024 $(ICONBGSVG) -o $@

$(ICONBG512):
	$(INKSCAPE) -w 512 -h 512 $(ICONBGSVG) -o $@

$(ICONBG256):
	$(INKSCAPE) -w 256 -h 256 $(ICONBGSVG) -o $@

$(ICONBG128):
	$(INKSCAPE) -w 128 -h 128 $(ICONBGSVG) -o $@

$(ICONBG64):
	$(INKSCAPE) -w 64 -h 64 $(ICONBGSVG) -o $@

$(ICONBG48):
	$(INKSCAPE) -w 48 -h 48 $(ICONBGSVG) -o $@

$(ICONBG32):
	$(INKSCAPE) -w 32 -h 32 $(ICONBGSVG) -o $@

$(ICONBG24):
	$(INKSCAPE) -w 24 -h 24 $(ICONBGSVG) -o $@

$(ICONBG16):
	$(INKSCAPE) -w 16 -h 16 $(ICONBGSVG) -o $@

$(ICONCIRCLE4096):
	$(INKSCAPE) -w 4096 -h 4096 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE2048):
	$(INKSCAPE) -w 2048 -h 2048 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE1024):
	$(INKSCAPE) -w 1024 -h 1024 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE512):
	$(INKSCAPE) -w 512 -h 512 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE256):
	$(INKSCAPE) -w 256 -h 256 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE128):
	$(INKSCAPE) -w 128 -h 128 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE64):
	$(INKSCAPE) -w 64 -h 64 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE48):
	$(INKSCAPE) -w 48 -h 48 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE32):
	$(INKSCAPE) -w 32 -h 32 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE24):
	$(INKSCAPE) -w 24 -h 24 $(ICONCIRCLESVG) -o $@

$(ICONCIRCLE16):
	$(INKSCAPE) -w 16 -h 16 $(ICONCIRCLESVG) -o $@

$(RSS):
	LOWDOWN=$(LOWDOWN) ./scripts/genrss $(HOST) $(EMAIL) "$(RSSTITLE)" \
	                                    $(RSSDIR) $(PAGES) > $@

$(SITEMAP):
	./scripts/gensitemap $(HOST) $(PAGES) > $@
