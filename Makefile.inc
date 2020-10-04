##
# Makefile.inc - preconfigured goals for all available asciidoctor outputs.
#
# How to use:
#
# In your project create a Makefile with this content:
# SRCS = <your main adoc file/s>
# # additional arguments for asciidoctor (ex: custom extensions)
# ASCIIDOCTOR_EXTRA_ARGS=--load-path lib/
#
# # install gems if not found
# ifeq ($(shell find . -name vendor | wc -l), 0)
# $(info installing gems...)
# $(shell bundler install > /dev/null)
# endif
#
# # include goals
# TOOLS_DIR = $(shell bundler info asciidoctor-tools | grep "Path" | sed -e 's/Path://')
# include $(TOOLS_DIR)/Makefile.inc
##
OUTPUT = dist
DEPS_DIR = .deps
ASCIIDOCTOR = asciidoctor
ASCIIDOCTOR_ARGS = --require asciidoctor-tools --attribute allow-uri-read

ifneq (,$(TARGET))
ifeq ($(TARGET), html5)
TARGET_EXT = html
endif

ifeq ($(TARGET), pdf)
ASCIIDOCTOR = asciidoctor-pdf
TARGET_EXT = pdf
endif

ifeq ($(TARGET), docbook)
TARGET_EXT = xml
endif

ifeq ($(TARGET), manpage)
TARGET_EXT = 1
endif

TARGET_UPPER=$(shell printf '  %-7s' $(TARGET) | tr '[:lower:]' '[:upper:]')
TARGET_PATTERN = $(OUTPUT)/$(TARGET)/%.$(TARGET_EXT)
DEPS_PATTERN = .$(TARGET).d
endif

.PHONY: default
default: html pdf

.PHONY: all
all: html pdf docbook manpage

.PHONY: clean
clean:
	@rm -rf $(OUTPUT) $(DEPS_DIR)

.PHONY: mrproper
mrproper: clean
	@rm -rf vendor

.PHONY: help
help:
	@echo -e "available goals:"
	@echo -e "  \e[1;32m* html\e[0m                   generate static html pages."
	@echo -e "  \e[1;32m* pdf\e[0m                    generate pdf documents."
	@echo -e "    docbook                generate docbook files."
	@echo -e "    manpage                generate man page files."
	@echo -e ""
	@echo -e "    all                    generate all previous goals."
	@echo -e "    default                generate default goals."
	@echo -e "    clean                  delete generated files."
	@echo -e "    mrproper               delete vendor folder plus clean goal."
	@echo -e "    help                   this help message."
	@echo -e ""
	@echo -e "NOTE: goals mark with an asterisc (*) are build by default."

vendor:
	@bundler install

.PHONY: html
html:
	@$(MAKE) -s __build TARGET=html5

.PHONY: pdf
pdf:
	@$(MAKE) -s __build TARGET=pdf

.PHONY: docbook
docbook:
	@$(MAKE) -s __build TARGET=docbook

.PHONY: manpage
manpage:
	@$(MAKE) -s __build TARGET=manpage

.PHONY: __build
__build: $(patsubst %.adoc, $(TARGET_PATTERN), $(SRCS))

$(TARGET_PATTERN): $(patsubst $(TARGET_PATTERN), $(DEPS_DIR)/%$(DEPS_PATTERN), $@)
	@echo -e "$(TARGET_UPPER) \e[1;32m$@\e[0m ..."
	@bundler exec $(ASCIIDOCTOR) $(ASCIIDOCTOR_EXTRA_ARGS) $(ASCIIDOCTOR_ARGS) -b $(TARGET) -D $(dir $@) $<

$(DEPS_DIR)/%$(DEPS_PATTERN): %.adoc vendor
	@mkdir -p $(dir $@)
	@echo "$(patsubst %.adoc, $(TARGET_PATTERN), $<): $< $(shell bundler exec extract-dependencies --recursive $< | tr "\n" " ")" > $@

ifneq (,$(TARGET))
include $(patsubst %, $(DEPS_DIR)/%, $(SRCS:.adoc=$(DEPS_PATTERN)))
endif

