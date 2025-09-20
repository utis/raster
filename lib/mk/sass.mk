## ---------------------------------------------------------------------------
## SASS

SASS-DIR := scss
SASS-EXTENSION := scss
SASS-LIB-DIR := lib/

CSS-DIR := css

SASS-CMD := sassc
SASS-EXTRA-ARGS :=


sass-srcs := $(wildcard $(SASS-DIR)/[^_]*.$(SASS-EXTENSION))
sass-tgts := $(patsubst $(SASS-DIR)/%.$(SASS-EXTENSION),$(CSS-DIR)/%.css,$(sass-srcs))

# sass-src-subs := $(shell find $(SASS-DIR) -type f -name '_*.$(SASS-EXTENSION)')

# sass-libs := $(shell find $(SASS-LIB-DIR) -maxdepth 2 -type f -name '_*.$(SASS-EXTENSION)')

# Getting dirnames and sorting them, making sure that local ones come
# before library ones.
# sass-inc-dirs-local := $(sort $(foreach f,$(sass-src-subs),$(dir $f)))
# sass-inc-dirs-lib := $(sort $(foreach f,$(sass-libs),$(dir $f)))
# sass-inc-dirs := $(sass-inc-dirs-local) $(sass-inc-dirs-lib)

# sass-inc-dirs := $(SASS-DIR) $(SASS-LIB-DIR)
sass-inc-dirs := $(TYPO-SASS-DIR) $(SASS-LIB-DIR)


# Replace space separators with `:`
nullstring :=
space := $(nullstring) # end of line
sass-inc-path := $(subst $(space),:,$(sass-inc-dirs))

vpath %.scss $(sass-inc-dirs)

.PHONY: sass
sass: $(sass-tgts)

$(CSS-DIR)/%.css: $(SASS-DIR)/%.$(SASS-EXTENSION) $(sass-src-subs) $(sass-libs)
	$(SASS-CMD) -I $(sass-inc-path) $(SASS-EXTRA-ARGS) $< > $@


sass-clean:
	rm -f $(CSS-DIR)/*
