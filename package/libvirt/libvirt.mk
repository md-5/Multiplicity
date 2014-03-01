################################################################################
#
# libvirt
#
################################################################################

LIBVIRT_VERSION           = 1.2.1
LIBVIRT_SOURCE            = libvirt-$(LIBVIRT_VERSION).tar.gz
LIBVIRT_SITE              = http://libvirt.org/sources/
LIBVIRT_LICENSE           = LGPLv2.1+
LIBVIRT_LICENSE_FILES     = COPYING.LIB
# Note: both COPYING and COPYING.LIB are present, but they both contain
#       the text of LGPLv2.1, so we only reference one of them.
LIBVIRT_DEPENDENCIES       = host-pkgconf lvm2 libnl libxml2 yajl

$(eval $(autotools-package))
