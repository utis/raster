FONTS-DIR := fonts
RPLUGIN-CMD := cd $(GRAV-ROOT); bin/plugin raster-utils font

# This should com from the plugin with the --list option
# -- and then auto generate the Make-rules.
FONTS := lato

font-targets := $(patsubst %,build/typography/_font-%.scss,$(FONTS))

GRIDS := lato-20-

DEP-DIR := build/d
dep-files := $(font-targets:build/typography/%=build/d/%.d)

test:
	cd $(GRAV-ROOT); bin/plugin raster-utils grid lato-20-9x6

# test:
# 	@echo $(dep-files)

# TMP
.PHONY: typography
typography: $(font-targets)

# $(font-targets): build/typography/_font-%.scss: fonts/%.yaml
# #	@echo $(RPLUGIN-CMD) font % > $@


build/typography/_font-lato.scss: fonts/lato.yaml fonts/lato/_font-lato.scss
	$(RPLUGIN-CMD) lato > $(theme-root)/$@ # Is that clean?
