FONTS-DIR := fonts
TYPO-SASS-DIR := build/scss
SASS-DEP-DIR := build/d

theme-cfg := $(theme-name).yaml

rplugin-cmd := cd $(grav-root); bin/plugin raster-utils

fonts := $(shell $(rplugin-cmd) font --list)
grids := $(shell $(rplugin-cmd) grid --list)

# Targets here are the scss files (containing font specs and @fontface
# rules) required for the sass part of typography.
font-targets := $(patsubst %,$(TYPO-SASS-DIR)/_font-%.scss,$(fonts))
grid-targets := $(patsubst %,$(TYPO-SASS-DIR)/_grid-%.scss,$(grids))

# dep-files := $(font-targets:build/typography/%=$(SASS-DEP-DIR)/%.d)

.PHONY: typography
typography: $(font-targets) $(grid-targets)

$(TYPO-SASS-DIR):
	mkdir -p $(TYPO-SASS-DIR)

# Construct rules for generating the font sass files via the
# raster-utils plugin. The latter requires the font name (not file
# name) as an argument, so we can't just use pattern matching for the
# rule.
define fonts_TEMPLATE =
$(TYPO-SASS-DIR)/_font-$(1).scss: $(FONTS-DIR)/$(1).yaml $(FONTS-DIR)/$(1)/_font-$(1).scss | $(TYPO-SASS-DIR)
	$(rplugin-cmd) font $(1) > $(theme-root)/$$@
endef

define grids_TEMPLATE =
$(TYPO-SASS-DIR)/_grid-$(1).scss: $(theme-cfg) | $(TYPO-SASS-DIR)
	$(rplugin-cmd) grid $(1) > $(theme-root)/$$@
endef

$(foreach f,$(fonts),$(eval $(call fonts_TEMPLATE,$f)))
$(foreach f,$(grids),$(eval $(call grids_TEMPLATE,$f)))

# Same as above for grids.
# ...


.PHONY: typography-clean
typography-clean:
	rm $(TYPO-SASS-DIR)/*
