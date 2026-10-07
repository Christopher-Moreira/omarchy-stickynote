VERSION ?= 1.0.0
NAME := omarchy-stickynote
DIST_ROOT := dist/$(NAME)-$(VERSION)
ARCHIVE := dist/$(NAME)-$(VERSION).tar.gz

.PHONY: test dist clean

test:
	python -m py_compile omarchy-stickynote omarchy-stickynote-waybar
	bash -n install.sh omarchy-stickynote-toggle
	desktop-file-validate data/com.omarchy.stickynote.desktop

dist: test clean
	install -Dm755 omarchy-stickynote "$(DIST_ROOT)/omarchy-stickynote"
	install -Dm755 omarchy-stickynote-toggle "$(DIST_ROOT)/omarchy-stickynote-toggle"
	install -Dm755 omarchy-stickynote-waybar "$(DIST_ROOT)/omarchy-stickynote-waybar"
	install -Dm644 data/com.omarchy.stickynote.desktop "$(DIST_ROOT)/data/com.omarchy.stickynote.desktop"
	install -Dm644 data/icons/hicolor/scalable/apps/com.omarchy.stickynote.svg "$(DIST_ROOT)/data/icons/hicolor/scalable/apps/com.omarchy.stickynote.svg"
	install -Dm644 README.md "$(DIST_ROOT)/README.md"
	install -Dm644 CHANGELOG.md "$(DIST_ROOT)/CHANGELOG.md"
	install -Dm644 LICENSE "$(DIST_ROOT)/LICENSE"
	tar --sort=name --mtime='UTC 2026-10-07' --owner=0 --group=0 --numeric-owner -czf "$(ARCHIVE)" -C dist "$(NAME)-$(VERSION)"
	sha256sum "$(ARCHIVE)"

clean:
	rm -rf "$(DIST_ROOT)" "$(ARCHIVE)"

