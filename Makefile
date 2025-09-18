base-theme-name := raster
base-theme-dir := ../$(base-theme-name)

theme-root := $(PWD)

MK-DIR := $(base-theme-dir)/lib/mk




IMG-SRC-DIR := images
IMG-TGT-DIR := images/opt

SASS-DIR := scss
SASS-EXTENSION := scss
SASS-LIB-DIR := lib/
CSS-DIR := css

SASS-CMD := sassc
SASS-EXTRA-ARGS :=

grav-root := $(shell realpath --no-symlinks $(PWD)/../../..)




# all: img-optimize sass
all: sass typography

include $(MK-DIR)/typography.mk


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
## SASS

sass-srcs := $(wildcard $(SASS-DIR)/[^_]*.$(SASS-EXTENSION))
sass-tgts := $(patsubst $(SASS-DIR)/%.$(SASS-EXTENSION),$(CSS-DIR)/%.css,$(sass-srcs))

# sass-src-subs := $(shell find $(SASS-DIR) -type f -name '_*.$(SASS-EXTENSION)')

sass-libs := $(shell find $(SASS-LIB-DIR) -maxdepth 2 -type f -name '_*.$(SASS-EXTENSION)')

# Getting dirnames and sorting them, making sure that local ones come
# before library ones.
# sass-inc-dirs-local := $(sort $(foreach f,$(sass-src-subs),$(dir $f)))
# sass-inc-dirs-lib := $(sort $(foreach f,$(sass-libs),$(dir $f)))
# sass-inc-dirs := $(sass-inc-dirs-local) $(sass-inc-dirs-lib)

sass-inc-dirs := $(SASS-DIR) $(SASS-LIB-DIR)

# Replace space separators with `:`
nullstring :=
space := $(nullstring) # end of line
sass-inc-path := $(subst $(space),:,$(sass-inc-dirs))

vpath %.scss $(sass-inc-dirs)

.PHONY: sass
sass: $(sass-tgts)

$(CSS-DIR)/%.css: $(SASS-DIR)/%.$(SASS-EXTENSION) $(sass-src-subs) $(sass-libs)
	$(describe) Compiling $@ from $<
	$(quiet)$(SASS-CMD) -I $(sass-inc-path) $(SASS-EXTRA-ARGS) $< > $@

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

clean:
	rm -f $(sass-tgts)
