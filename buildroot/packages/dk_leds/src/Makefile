# ----------------------------------------------------------------------------
# Makefile for building tapp
#

TARGET				= dk_leds


all: $(TARGET)

dk_leds: led.c
	$(CC) $(CFLAGS) $< -o $@

clean distclean:
	rm -rf *.o $(TARGET)


# ----------------------------------------------------------------------------

.PHONY: $(PHONY) install clean distclean

# End of file
# vim: syntax=make

