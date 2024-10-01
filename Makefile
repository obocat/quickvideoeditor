prefix ?= /usr/local
bindir = $(prefix)/bin
appDisplayName = quickvideoeditor

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/$(appDisplayName)" "$(bindir)/$(appDisplayName)"
	@echo "$(appDisplayName) installed successfully."

uninstall:
	rm -rf "$(bindir)/$(appDisplayName)"
	@echo "$(appDisplayName) uninstalled successfully."

clean:
	rm -rf .build

.PHONY: build install uninstall clean
