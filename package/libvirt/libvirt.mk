################################################################################
#
# libvirt
#
################################################################################

LIBVIRT_VERSION       = 1.2.1
LIBVIRT_SOURCE        = libvirt-$(LIBVIRT_VERSION).tar.gz
LIBVIRT_SITE          = http://libvirt.org/sources/
LIBVIRT_LICENSE       = GPLv2 LGPLv2.1
LIBVIRT_LICENSE_FILES = COPYING COPYING.LESSER
LIBVIRT_DEPENDENCIES  = host-pkgconf lvm2 libnl libxml2 yajl

$(eval $(autotools-package))
