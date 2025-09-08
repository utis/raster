
SASS-LIB-DIR := ..
CSS-TARGET := exstyle.css
SASS-SRC := exstyle.scss
SASS-EXTENSION := scss

SASS-CMD := sassc
SASS-EXTRA-ARGS :=

all: sass

describe := @echo

## ---------------------------------------------------------------------------
## SASS

sass-libs := $(shell find $(SASS-LIB-DIR) -type f -name '_*.$(SASS-EXTENSION)')
sass-lib-dirs := $(sort $(foreach f,$(sass-libs),$(dir $f)))

# Replace space separators with `:`
# nullstring :=
# space := $(nullstring) # end of line
# sass-inc-path := $(subst $(space),:,$(sass-lib-dirs))

sass-inc-path := $(SASS-LIB-DIR)


vpath %.scss $(sass-inc-dirs)

.PHONY: sass
sass: $(CSS-TARGET)

exstyle.css: exstyle.scss $(sass-libs)
	$(describe) Compiling $@ from $<
	$(quiet)$(SASS-CMD) -I $(sass-inc-path) $(SASS-EXTRA-ARGS) $< > $@



