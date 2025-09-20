base-theme-name := raster
base-theme-dir := ../$(base-theme-name)

theme-root := $(PWD)
theme-name := $(notdir $(theme-root))


MK-DIR := $(base-theme-dir)/lib/mk




IMG-SRC-DIR := images
IMG-TGT-DIR := images/opt


grav-root := $(shell realpath --no-symlinks $(PWD)/../../..)




# all: img-optimize sass
all: typography sass

TYPO-SASS-DIR := build/scss


include $(MK-DIR)/typography.mk
include $(MK-DIR)/sass.mk

## ---------------------------------------------------------------------------
# Courtesy of Toby Speight https://codereview.stackexchange.com/users/75307/toby-speight
ifdef verbose
describe := @true
quiet :=
else
describe := @echo
quiet := @
endif

## ---------------------------------------------------------------------------
## IMAGES

img-src-files := $(shell find $(IMG-SRC-DIR) -type f)

img-src-dirs := $(shell find $(IMG-SRC-DIR) -type d)

img-tgt-dirs := $(patsubst $(IMG-SRC-DIR)/%,$(IMG-TGT-DIR)/%,$(img-src-dirs))
tgt-files := $(patsubst $(IMG-SRC-DIR)/%,$(IMG-TGT-DIR)/%,$(img-src-files))

.PHONY: img-optimize
img-optimize: directories $(tgt-files)

.PHONY: directories
directories: | $(IMG-TGT-DIR) $(img-tgt-dirs)

$(IMG-TGT-DIR) $(img-tgt-dirs) :
	@mkdir -p $@

define SVG-TEMPLATE =
$(1): $$(patsubst $$(IMG-TGT-DIR)/%,$$(IMG-SRC-DIR)/%,$(1))
	@svgo -o $$@ $$<
endef

define PNG-TEMPLATE =
$(1): $$(patsubst $$(IMG-TGT-DIR)/%,$$(IMG-SRC-DIR)/%,$(1))
	@pngquant -Q 30 -o $$@ $$<
endef


# SVG
$(foreach target,$(filter %.svg,$(tgt-files)),$(eval $(call SVG-TEMPLATE,$(target))))

# PNG
$(foreach target,$(filter %.png,$(tgt-files)),$(eval $(call PNG-TEMPLATE,$(target))))


## ---------------------------------------------------------------------------
## WATCH

WATCHMAKE := sass # img-optimize 
watchdirs := $(IMG-SRC-DIR) $(SASS-DIR) $(SASS-LIB-DIR)


.PHONY: watch

watch:
	@while true; do \
		make --no-print-directory $(WATCHMAKE); \
		inotifywait -qre close_write $(watchdirs); \
	done

## ---------------------------------------------------------------------------
## CLEAN

.PHONY: clean
clean: sass-clean typography-clean
