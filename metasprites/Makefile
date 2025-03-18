GBDK_PATH = ../Build/GBDK-2020/
LCC_PATH = $(GBDK_PATH)bin/lcc
PNG2ASSET_PATH = $(GBDK_PATH)/bin/png2asset

# Set platforms to build here, spaced separated. (These are in the separate Makefile.targets)
# They can also be built/cleaned individually: "make gg" and "make gg-clean"
# Possible are: gb gbc pocket megaduck sms gg
TARGETS = gbc

LCC_MEMORY_BANK_CONTROLLER_TYPE_FLAG = -Wl-yt0x1B
LCC_GBC_EXCLUSIVE_MODE_FLAG = -Wm-yC
LCC_AUTOBANK_FLAG = -autobank
LCC_ADDITIONAL_MBC_AND_AUTOBANKING_FLAGS = -Wl-j -Wm-yoA -Wm-ya4 -Wb-ext=.rel -Wb-v

LCC_FLAGS = \
	$(LCC_MEMORY_BANK_CONTROLLER_TYPE_FLAG) \
	$(LCC_GBC_EXCLUSIVE_MODE_FLAG) \
	$(LCC_AUTOBANK_FLAG) \
	$(LCC_ADDITIONAL_MBC_AND_AUTOBANKING_FLAGS)

OBJECTS_DIRECTORY_NAME = Objects
RESOURCES_DIRECTORY_NAME = Resources

OUTPUT_ROM_FILENAME = Dadish.gbc

SRCDIR      = src
RESOBJSRC   = $(OBJECTS_DIRECTORY_NAME)/Resources
BINDIR      = build/$(EXT)
MKDIRS      = $(OBJECTS_DIRECTORY_NAME) $(BINDIR) $(RESOBJSRC) # See bottom of Makefile for directory auto-creation

BINS	    = $(OBJECTS_DIRECTORY_NAME)/$(OUTPUT_ROM_FILENAME)
# For png2asset: converting metasprite source pngs -> .c -> .o
METAPNGS    = $(foreach dir,$(RESOURCES_DIRECTORY_NAME),$(notdir $(wildcard $(dir)/*.png)))
METASRCS    = $(METAPNGS:%.png=$(RESOBJSRC)/%.c)
METAOBJS    = $(METASRCS:$(RESOBJSRC)/%.c=$(OBJECTS_DIRECTORY_NAME)/%.o)

CSOURCES    = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.c))) $(foreach dir,$(RESOURCES_DIRECTORY_NAME),$(notdir $(wildcard $(dir)/*.c)))
ASMSOURCES  = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.s)))
OBJS        = $(CSOURCES:%.c=$(OBJECTS_DIRECTORY_NAME)/%.o) $(ASMSOURCES:%.s=$(OBJECTS_DIRECTORY_NAME)/%.o)


# Builds all targets sequentially
all: $(TARGETS)

# Use png2asset to convert the png into C formatted metasprite data
# -sh 48   : Sets sprite height to 48 (width remains automatic)
# -spr8x16 : Use 8x16 hardware sprites
# -c ...   : Set C output file
# Convert metasprite .pngs in Resources/ -> .c files in obj/<platform ext>/src/
$(RESOBJSRC)/%.c:	$(RESOURCES_DIRECTORY_NAME)/%.png
	$(PNG2ASSET_PATH) $< -sh 48 -spr8x8 -noflip -c $@

# Compile the Metasprite pngs that were converted to .c files
# .c files in obj/<platform ext>/src/ -> .o files in obj/
$(OBJECTS_DIRECTORY_NAME)/%.o:	$(RESOBJSRC)/%.c
	$(LCC_PATH) $(LCC_FLAGS) -c -o $@ $<

# Compile .c files in "src/" to .o object files
$(OBJECTS_DIRECTORY_NAME)/%.o:	$(SRCDIR)/%.c
	$(LCC_PATH) $(LCC_FLAGS) -c -o $@ $<

# Compile .c files in "Resources/" to .o object files
$(OBJECTS_DIRECTORY_NAME)/%.o:	$(RESOURCES_DIRECTORY_NAME)/%.c
	$(LCC_PATH) $(LCC_FLAGS) -c -o $@ $<

# Compile .s assembly files in "src/" to .o object files
$(OBJECTS_DIRECTORY_NAME)/%.o:	$(SRCDIR)/%.s
	$(LCC_PATH) $(LCC_FLAGS) -c -o $@ $<

# If needed, compile .c files in "src/" to .s assembly files
# (not required if .c is compiled directly to .o)
$(OBJECTS_DIRECTORY_NAME)/%.s:	$(SRCDIR)/%.c
	$(LCC_PATH) $(LCC_FLAGS) -S -o $@ $<

# Convert and build MetaSprites first so they're available when compiling the main sources
$(OBJS):	$(METAOBJS)

# Link the compiled object files into a .gb ROM file
$(BINS):	$(OBJS)
	$(LCC_PATH) $(LCC_FLAGS) -o $(BINDIR)/$(OUTPUT_ROM_FILENAME) $(METAOBJS) $(OBJS)

clean:
	@echo Cleaning
	@for target in $(TARGETS); do \
		$(MAKE) $$target-clean; \
	done

# Include available build targets
include Makefile.targets


# create necessary directories after Makefile is parsed but before build
# info prevents the command from being pasted into the makefile
ifneq ($(strip $(EXT)),)           # Only make the directories if EXT has been set by a target
$(info $(shell mkdir -p $(MKDIRS)))
endif
