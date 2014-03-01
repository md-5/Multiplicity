################################################################################
#
# qemu
#
################################################################################

QEMU_VERSION = 1.7.0
QEMU_SOURCE = qemu-$(QEMU_VERSION).tar.bz2
QEMU_SITE = http://wiki.qemu.org/download/
QEMU_LICENSE = GPLv2 LGPLv2.1 MIT BSD-3c BSD-2c Others/BSD-1c
QEMU_LICENSE_FILES = COPYING COPYING.LIB
QEMU_DEPENDENCIES = host-pkgconf host-python libglib2 pixman

define QEMU_CONFIGURE_CMDS
    ( cd $(@D);                                 \
        $(TARGET_CONFIGURE_OPTS)                \
        $(TARGET_CONFIGURE_ARGS)                \
        $(QEMU_VARS)                            \
        ./configure                             \
            --cross-prefix=$(TARGET_CROSS)      \
            --target-list=x86_64-softmmu        \
            $(QEMU_OPTS)                        \
    )
endef

define QEMU_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_INSTALL_TARGET_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
