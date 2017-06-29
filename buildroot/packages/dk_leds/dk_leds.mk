################################################################################
#
# dk_leds
#
################################################################################
DK_LEDS_VERSION = 1.0
#DK_LEDS_SOURCE = dk_leds-$(DK_LEDS_VERSION).tar.gz
DK_LEDS_LICENSE = GPLv3+
#DK_LEDS_LICENSE_FILES = COPYING
DK_LEDS_INSTALL_STAGING = NO
#DK_LEDS_CONFIG_SCRIPTS = libfoo-config
#DK_LEDS_DEPENDENCIES = host-libaaa libbbb
DK_LEDS_SITE=$(TOPDIR)/../packages/dk_leds/src
DK_LEDS_SITE_METHOD=local
DK_LEDS_INSTALL_TARGET=YES

define DK_LEDS_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) all
endef


define DK_LEDS_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/dk_leds $(TARGET_DIR)/bin
endef


$(eval $(generic-package))
