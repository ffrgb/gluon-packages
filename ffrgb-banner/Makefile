include $(TOPDIR)/rules.mk

PKG_NAME:=ffrgb-banner
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/ffrgb-banner
  SECTION:=ffrgb
  CATEGORY:=FFRGB
  TITLE:=Banner file replacement
  DEPENDS:=+gluon-core +busybox
  MAINTAINER:=Freifunk Regensburg <mephisto@regensburg.freifunk.net>
endef

define Package/ffrgb-banner/description
	Banner file replacement
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffrgb-banner/preinst
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
#preserve stock banner
if [ -h "./banner" ] ; then
	/bin/rm "./banner"
elif [ -f "./banner" ] ; then
	/bin/mv "./banner" "./banner.openwrt"
fi
/bin/ln -s "./banner.openwrt" "./banner"
#preserve stock profile
if [ -h "./profile" ] ; then
	/bin/rm "./profile"
elif [ -f "./profile" ] ; then
	/bin/mv "./profile" "./profile.openwrt"
fi
/bin/ln -s "./profile.openwrt" "./profile"
exit 0
endef

define Package/ffrgb-banner/postinst
#!/bin/sh
#set links
cd "$${IPKG_INSTROOT}/etc/"
[ -h "./banner" ] && /bin/rm -f "./banner"
/bin/ln -s "./banner.ffrgb" "./banner"
[ -h "./profile" ] && /bin/rm -f "./profile"
/bin/ln -s "./profile.ffrgb" "./profile"
exit $$?
endef

define Package/ffrgb-banner/prerm
#!/bin/sh
#restore stock banner
cd "$${IPKG_INSTROOT}/etc/"
if [ -h "./banner" ] ; then
	[[ "$$(readlink -n ./banner)" == "./banner.ffrgb" ]] && \
	/bin/rm -f "./banner" && \
	[ -f "./banner.openwrt" ] && \
	/bin/ln -s "./banner.openwrt" "./banner"
fi
#restore stock profile
if [ -h "./profile" ] ; then
	[[ "$$(readlink -n ./profile)" == "./profile.ffrgb" ]] && \
	/bin/rm -f "./profile" && \
	[ -f "./profile.openwrt" ] && \
	/bin/ln -s "./profile.openwrt" "./profile"
fi
exit 0
endef

define Package/ffrgb-banner/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DATA) ./files/etc/banner.ffrgb $(1)/etc/
	$(INSTALL_DATA) ./files/etc/profile.ffrgb $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DATA) ./usr/bin/nodeinfo $(1)/usr/bin/
endef

$(eval $(call BuildPackage,ffrgb-banner))
