################################################################################
#
# ledplayer
#
################################################################################
LED_PLAYER_VERSION = 1.0
#LED-PLAYER_SOURCE = led-player-$(LED-PLAYER_VERSION).tar.gz
LED_PLAYER_LICENSE = GPLv3+
#LED-PLAYER_LICENSE_FILES = COPYING
LED_PLAYER_INSTALL_STAGING = NO
#LED-PLAYER_CONFIG_SCRIPTS = libfoo-config
#LED-PLAYER_DEPENDENCIES = host-libaaa libbbb
LED_PLAYER_SITE=$(TOPDIR)/../packages/led_player/src
#LED-PLAYER_OVERRIDE_SRCDIR=$(TOPDIR)/../packages/led-player/src
LED_PLAYER_SITE_METHOD=local
LED_PLAYER_INSTALL_TARGET=YES

define LED_PLAYER_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) all
endef


define LED_PLAYER_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/led-player $(TARGET_DIR)/bin
endef


$(eval $(generic-package))