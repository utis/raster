FONTS-DIR := fonts
TYPO-SASS-DIR := build/scss

rplugin-cmd := cd $(grav-root); bin/plugin raster-utils

# This should com from the plugin with the --list option
# -- and then auto generate the Make-rules.
fonts := $(shell $(rplugin-cmd) font --list)



font-targets := $(patsubst %,$(TYPO-SASS-DIR)/_font-%.scss,$(fonts))

GRIDS := lato-20-

DEP-DIR := build/d
dep-files := $(font-targets:build/typography/%=build/d/%.d)

#	cd $(GRAV-ROOT); bin/plugin raster-utils grid lato-20-9x6
#	@echo $(FONTS)
# test:
# 	@echo $(dep-files)

# TMP


.PHONY: typography
typography: $(font-targets)

# $(font-targets): build/typography/_font-%.scss: fonts/%.yaml
# #	@echo $(RPLUGIN-CMD) font % > $@

$(TYPO-SASS-DIR):
	mkdir -p $(TYPO-SASS-DIR)

define fonts_TEMPLATE =
$(TYPO-SASS-DIR)/_font-$(1).scss: $(FONTS-DIR)/$(1).yaml $(FONTS-DIR)/$(1)/_font-$(1).scss | $(TYPO-SASS-DIR)
	$(rplugin-cmd) font $(1) > $(theme-root)/$$@
endef

# $(eval $(call fonts_TEMPLATE,lato))

# define test_TEMPLATE =
# $(TYPO-SASS-DIR)/_font-$(1).scss: $(FONTS-DIR)/$(1).yaml $(FONTS-DIR)/$(1)/_font-$(1).scss
# 	@echo "here" $$< $$@
# endef

$(eval $(call fonts_TEMPLATE,lato))
$(eval $(call fonts_TEMPLATE,humanist))


# $(foreach f,$(fonts),$(eval $(call fonts_TEMPLATE,$f)))
# build/typography/_font-lato.scss: fonts/lato.yaml fonts/lato/_font-lato.scss
# 	$(RPLUGIN-CMD) lato > $(theme-root)/$@ # Is that clean?
