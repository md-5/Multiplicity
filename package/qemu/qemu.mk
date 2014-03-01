################################################################################
#
# qemu
#
################################################################################

QEMU_VERSION = 1.7.0
QEMU_SOURCE = qemu-$(QEMU_VERSION).tar.bz2
QEMU_SITE = http://wiki.qemu.org/download
QEMU_LICENSE = GPLv2 LGPLv2.1 MIT BSD-3c BSD-2c Others/BSD-1c
QEMU_LICENSE_FILES = COPYING COPYING.LIB
#Â NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.

#-------------------------------------------------------------
# Host-qemu

HOST_QEMU_DEPENDENCIES = host-pkgconf host-zlib host-libglib2 host-pixman

#       BR ARCH         qemu
#       -------         ----
#       arm             arm
#       armeb           armeb
#       avr32           not supported
#       bfin            not supported
#       i386            i386
#       i486            i386
#       i586            i386
#       i686            i386
#       x86_64          x86_64
#       m68k            m68k
#       microblaze      microblaze
#       mips            mips
#       mipsel          mipsel
#       mips64          ?
#       mips64el        ?
#       powerpc         ppc
#       sh2a            not supported
#       sh4             sh4
#       sh4eb           sh4eb
#       sh4a            ?
#       sh4aeb          ?
#       sh64            not supported
#       sparc           sparc

HOST_QEMU_ARCH = $(ARCH)
ifeq ($(HOST_QEMU_ARCH),i486)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i586)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i686)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),powerpc)
    HOST_QEMU_ARCH = ppc
endif
HOST_QEMU_TARGETS=$(HOST_QEMU_ARCH)-linux-user

# Note: although QEMU has a ./configure script, it is not a real autotools
# package, and ./configure chokes on options such as --host or --target.
# So, provide out own _CONFIGURE_CMDS to override the defaults.
define HOST_QEMU_CONFIGURE_CMDS
    (cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure   \
        --target-list="$(HOST_QEMU_TARGETS)"    \
        --prefix="$(HOST_DIR)/usr"              \
        --interp-prefix=$(STAGING_DIR)          \
        --cc="$(HOSTCC)"                        \
        --host-cc="$(HOSTCC)"                   \
        --extra-cflags="$(HOST_CFLAGS)"         \
        --extra-ldflags="$(HOST_LDFLAGS)"       \
    )
endef

$(eval $(host-autotools-package))

# variable used by other packages
QEMU_USER = $(HOST_DIR)/usr/bin/qemu-$(HOST_QEMU_ARCH)

#-------------------------------------------------------------
# Target-qemu

QEMU_DEPENDENCIES = host-pkgconf host-python libglib2 zlib pixman

# Need the LIBS variable because librt and libm are
# not automatically pulled. :-(
QEMU_LIBS = -lrt -lm

QEMU_OPTS =

QEMU_VARS =                                                                         \
    PYTHON=$(HOST_DIR)/usr/bin/python                                               \
    PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages    \
    SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config                                    \

ifeq ($(BR2_PACKAGE_QEMU_SYSTEM),y)
QEMU_OPTS += --enable-system
else
QEMU_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_QEMU_LINUX_USER),y)
QEMU_OPTS += --enable-linux-user
else
QEMU_OPTS += --disable-linux-user
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS)),)
QEMU_OPTS += --target-list="$(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS))"
endif

ifeq ($(BR2_PACKAGE_QEMU_VNC),y)
QEMU_OPTS += --enable-vnc
else
QEMU_OPTS += --disable-vnc
endif

ifeq ($(BR2_PACKAGE_QEMU_VNC_PNG),y)
QEMU_OPTS += --enable-vnc-png
QEMU_DEPENDENCIES += libpng
else
QEMU_OPTS += --disable-vnc-png
endif

ifeq ($(BR2_PACKAGE_QEMU_VNC_JPEG),y)
QEMU_OPTS += --enable-vnc-jpeg
QEMU_DEPENDENCIES += jpeg
else
QEMU_OPTS += --disable-vnc-jpeg
endif

ifeq ($(BR2_PACKAGE_QEMU_VNC_TLS),y)
QEMU_OPTS += --enable-vnc-tls
QEMU_DEPENDENCIES += gnutls
else
QEMU_OPTS += --disable-vnc-tls
endif

ifeq ($(BR2_PACKAGE_QEMU_SDL),y)
QEMU_OPTS += --enable-sdl
QEMU_DEPENDENCIES += sdl
QEMU_VARS += SDL_CONFIG=$(BR2_STAGING_DIR)/usr/bin/sdl-config
else
QEMU_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_QEMU_CURSES),y)
QEMU_OPTS += --enable-curses
QEMU_DEPENDENCIES += ncurses
else
QEMU_OPTS += --disable-curses
endif

ifeq ($(BR2_PACKAGE_QEMU_SPICE),y)
QEMU_OPTS += --enable-spice
QEMU_DEPENDENCIES += spice
else
QEMU_OPTS += --disable-spice
endif

ifeq ($(BR2_PACKAGE_QEMU_VIRTFS),y)
QEMU_OPTS += --enable-virtfs
else
QEMU_OPTS += --disable-virtfs
endif

ifeq ($(BR2_PACKAGE_QEMU_CURL),y)
QEMU_OPTS += --enable-curl
QEMU_DEPENDENCIES += libcurl
else
QEMU_OPTS += --disable-curl
endif

ifeq ($(BR2_PACKAGE_QEMU_ISCSI),y)
QEMU_OPTS += --enable-libiscsi
QEMU_DEPENDENCIES += libiscsi
else
QEMU_OPTS += --disable-libiscsi
endif

ifeq ($(BR2_PACKAGE_QEMU_USBREDIR),y)
QEMU_OPTS += --enable-usb-redir
QEMU_DEPENDENCIES += usbredir
else
QEMU_OPTS += --disable-usb-redir
endif

ifeq ($(BR2_PACKAGE_QEMU_AIO),y)
QEMU_OPTS += --enable-linux-aio
QEMU_DEPENDENCIES += libaio
else
QEMU_OPTS += --disable-linux-aio
endif

ifeq ($(BR2_PACKAGE_QEMU_BLUEZ),y)
QEMU_OPTS += --enable-bluez
QEMU_DEPENDENCIES += bluez_utils
else
QEMU_OPTS += --disable-bluez
endif

ifeq ($(BR2_PACKAGE_QEMU_VDE),y)
QEMU_OPTS += --enable-vde
QEMU_DEPENDENCIES += vde2
else
QEMU_OPTS += --disable-vde
endif

QEMU_SND_DRV =
ifeq ($(BR2_PACKAGE_QEMU_SOUND_ALSA),y)
QEMU_SND_DRV += alsa
QEMU_DEPENDENCIES += alsa-lib
endif
ifeq ($(BR2_PACKAGE_QEMU_SOUND_SDL),y)
QEMU_SND_DRV += sdl
QEMU_DEPENDENCIES += sdl
endif


ifeq ($(BR2_PACKAGE_QEMU_FDT),y)
QEMU_OPTS += --enable-fdt
QEMU_DEPENDENCIES += dtc
else
QEMU_OPTS += --disable-fdt
endif

ifeq ($(BR2_PACKAGE_QEMU_UUID),y)
QEMU_OPTS += --enable-uuid
QEMU_DEPENDENCIES += util-linux
else
QEMU_OPTS += --disable-uuid
endif

# There's no configure flag to disable use of libcap
# so we must use an environment variable
ifeq ($(BR2_PACKAGE_QEMU_CAP),y)
QEMU_OPTS += --enable-cap-ng
QEMU_DEPENDENCIES += libcap libcap-ng
else
QEMU_OPTS += --disable-cap-ng
QEMU_VARS += cap=no
endif

ifeq ($(BR2_PACKAGE_QEMU_ATTR),y)
QEMU_OPTS += --enable-attr
else
QEMU_OPTS += --disable-attr
endif



ifeq ($(BR2_PACKAGE_QEMU_TOOLS_ON_TARGET),y)
QEMU_OPTS += --enable-tools
else
QEMU_OPTS += --disable-tools
endif

ifeq ($(BR2_PACKAGE_QEMU_BLOBS),)
QEMU_OPTS += --disable-blobs
endif

ifeq ($(BR2_HAVE_DOCUMENTATION),y)
QEMU_OPTS += --enable-docs
else
QEMU_OPTS += --disable-docs
endif

ifeq ($(BR2_PACKAGE_QEMU_STATIC),y)
QEMU_OPTS += --static
endif

# Post-install removal of unwanted keymaps:
# - if we want 'all', we do nothing;
# - if we want none, we completely remove the keymap dir
# - otherwise:
#   - we completely remove the keymap dir; and recreate it empty
#   - we recursively copy only those keymaps we want (as keymaps may include
#     some common files)
#
# NOTE-1: we need the un-quoted list of keymaps, so it is interpreted as a glob
#         by the shell.
# NOTE-2: yes, all (current!) keymaps do include the 'common' keymap, which in
#         turn includes the 'modifiers' keymap, so we could unconditionally
#         copy those two, for a much simpler code. Doing it the way it's done
#         is more generic, and will adapt to any future keymaps which has
#         multiple includes, or none.
# NOTE-3: we can't use $(SED), because it expands to include the '-i' option,
#         which we do *not* want here, because we are not munging a file, but
#         using sed as a enhanced grep.
#
QEMU_KEYMAPS = $(call qstrip,$(BR2_PACKAGE_QEMU_KEYMAPS))

ifeq ($(QEMU_KEYMAPS),all)      #--- Keep all keymaps ---#
define QEMU_POST_INSTALL_KEYMAPS
    @: Nothing
endef

else ifeq ($(QEMU_KEYMAPS),)    #--- Remove all keymaps ---#
define QEMU_POST_INSTALL_KEYMAPS
    rm -rf "$(TARGET_DIR)/usr/share/qemu/keymaps"
endef

else                            #--- Keep selected keymaps ---#
define QEMU_POST_INSTALL_KEYMAPS
    rm -rf "$(TARGET_DIR)/usr/share/qemu/keymaps"
    mkdir -p "$(TARGET_DIR)/usr/share/qemu/keymaps"
    add_keymap() {                                                  \
        local k="$${1}"; local dest="$${2}";                        \
        if [ -n "$${k}" -a ! -f "$${dest}/$${k}" ]; then            \
            cp -v "$${k}" "$${dest}";                               \
            for k in $$(sed -r -e '/^include[[:space:]]+(.*)$$/!d;' \
                               -e 's//\1/;' "$${k}" ); do           \
                add_keymap "$${k}" "$${dest}";                      \
            done;                                                   \
        fi;                                                         \
    };                                                              \
    cd $(@D)/pc-bios/keymaps;                                       \
    for k in $(QEMU_KEYMAPS); do                                    \
        add_keymap "$${k}" "$(TARGET_DIR)/usr/share/qemu/keymaps";  \
    done
endef

endif # Keymaps to keep

QEMU_POST_INSTALL_TARGET_HOOKS += QEMU_POST_INSTALL_KEYMAPS

define QEMU_CONFIGURE_CMDS
    ( cd $(@D);                                 \
        LIBS='$(QEMU_LIBS)'                     \
        $(TARGET_CONFIGURE_OPTS)                \
        $(TARGET_CONFIGURE_ARGS)                \
        $(QEMU_VARS)                            \
        ./configure                             \
            --prefix=/usr                       \
            --cross-prefix=$(TARGET_CROSS)      \
            --with-system-pixman                \
            --enable-kvm                        \
            --enable-vhost-net                  \
            --disable-bsd-user                  \
            --disable-xen                       \
            --disable-slirp                     \
            --disable-vnc-sasl                  \
            --disable-brlapi                    \
            --disable-guest-base                \
            --disable-rbd                       \
            --disable-strip                     \
            --disable-sparse                    \
            $(QEMU_OPTS)                        \
    )
endef

define QEMU_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_INSTALL_TARGET_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(QEMU_MAKE_ENV) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
