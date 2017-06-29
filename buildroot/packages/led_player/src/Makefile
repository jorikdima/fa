# ----------------------------------------------------------------------------
# Makefile for building tapp
#
# Copyright 2010 FriendlyARM (http://www.arm9.net/)
#

TARGET				= led-player


all: $(TARGET)

led-player: led-player.c
	$(CC) $(CFLAGS) $< -o $@


clean distclean:
	rm -rf *.o $(TARGET)


# ----------------------------------------------------------------------------

.PHONY: $(PHONY) install clean distclean

# End of file
# vim: syntax=make

