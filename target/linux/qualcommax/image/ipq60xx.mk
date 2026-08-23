DTS_DIR := $(DTS_DIR)/qcom
DEVICE_VARS += TPLINK_SUPPORT_STRING

define Build/wax610-netgear-tar
	mkdir $@.tmp
	mv $@ $@.tmp/nand-ipq6018-apps.img
	md5sum $@.tmp/nand-ipq6018-apps.img | cut -c 1-32 > $@.tmp/nand-ipq6018-apps.md5sum
	echo "WAX610" > $@.tmp/metadata.txt
	echo "WAX610-610Y_V99.9.9.9" > $@.tmp/version
 	tar -C $@.tmp/ -cf $@ .
	rm -rf $@.tmp
endef

define Build/netgear-rbx350-qsdk-ipq-factory
	$(CP) $(FLASH_SCRIPT) $(KDIR_TMP)/
	echo "VERSION : V5.0.0.0_$(LINUX_VERSION)" > $@.metadata
	echo "MODEL_ID : $(DEVICE_MODEL)" >> $@.metadata
	$(TOPDIR)/scripts/mkits-qsdk-ipq-image.sh $@.its $(FLASH_SCRIPT) txt $@.metadata ubi $@
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv $@.new $@
endef

define Device/8devices_mango-dvk
	$(call Device/FitImageLzma)
	DEVICE_VENDOR := 8devices
	DEVICE_MODEL := Mango-DVK
	IMAGE_SIZE := 27776k
	BLOCKSIZE := 64k
	SOC := ipq6010
	SUPPORTED_DEVICES += 8devices,mango
	IMAGE/sysupgrade.bin := append-kernel | pad-to 64k | append-rootfs | pad-rootfs | check-size | append-metadata
	DEVICE_PACKAGES := ipq-wifi-8devices_mango
endef
TARGET_DEVICES += 8devices_mango-dvk

define Device/alfa-network_ap120c-ax
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := ALFA Network
	DEVICE_MODEL := AP120C-AX
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	SOC := ipq6000
	DEVICE_PACKAGES := ipq-wifi-alfa-network_ap120c-ax
endef
TARGET_DEVICES += alfa-network_ap120c-ax

define Device/cambiumnetworks_xe3-4
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Cambium Networks
	DEVICE_MODEL := XE3-4
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	DEVICE_DTS_CONFIG := config@cp01-c3-xv3-4
	SOC := ipq6010
	DEVICE_PACKAGES := ipq-wifi-cambiumnetworks_xe34 ath11k-firmware-qcn9074 kmod-ath11k-pci
endef
TARGET_DEVICES += cambiumnetworks_xe3-4

define Device/glinet_gl-common
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := GL.iNet
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	DEVICE_DTS_CONFIG := config@cp03-c1
	SOC := ipq6000
	IMAGES += factory.bin
	IMAGE/factory.bin := append-ubi | append-gl-metadata
endef

define Device/glinet_gl-ax1800
	$(call Device/glinet_gl-common)
	DEVICE_MODEL := GL-AX1800
	DEVICE_PACKAGES := ipq-wifi-glinet_gl-ax1800
	SUPPORTED_DEVICES += glinet,ax1800
endef
TARGET_DEVICES += glinet_gl-ax1800

define Device/glinet_gl-axt1800
	$(call Device/glinet_gl-common)
	DEVICE_MODEL := GL-AXT1800
	DEVICE_PACKAGES := ipq-wifi-glinet_gl-axt1800 kmod-hwmon-pwmfan
	SUPPORTED_DEVICES += glinet,axt1800
endef
TARGET_DEVICES += glinet_gl-axt1800

define Device/jdcloud_re-cs-02
	$(call Device/FitImage)
	DEVICE_VENDOR := JDCloud
	DEVICE_MODEL := RE-CS-02
	SOC := ipq6010
	BLOCKSIZE := 64k
	KERNEL_SIZE := 6144k
	DEVICE_DTS_CONFIG := config@cp03-c3
	DEVICE_PACKAGES := ath11k-firmware-qcn9074 ipq-wifi-jdcloud_re-cs-02 kmod-ath11k-pci
endef
TARGET_DEVICES += jdcloud_re-cs-02

define Device/jdcloud_re-cs-07
	$(call Device/FitImage)
	DEVICE_VENDOR := JDCloud
	DEVICE_MODEL := RE-CS-07
	SOC := ipq6010
	BLOCKSIZE := 64k
	KERNEL_SIZE := 6144k
	DEVICE_DTS_CONFIG := config@cp03-c4
	DEVICE_PACKAGES := -ath11k-firmware-ipq6018 -kmod-ath11k-ahb -wpad-openssl
endef
TARGET_DEVICES += jdcloud_re-cs-07

define Device/jdcloud_re-ss-01
	$(call Device/FitImage)
	DEVICE_VENDOR := JDCloud
	DEVICE_MODEL := RE-SS-01
	SOC := ipq6000
	BLOCKSIZE := 64k
	KERNEL_SIZE := 6144k
	DEVICE_DTS_CONFIG := config@cp03-c2
	DEVICE_PACKAGES := ipq-wifi-jdcloud_re-ss-01
	IMAGES += factory.bin
	IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | append-metadata
endef
TARGET_DEVICES += jdcloud_re-ss-01

define Device/link_nn6000-v1
	$(call Device/FitImage)
	$(call Device/EmmcImage)
	DEVICE_VENDOR := Link
	DEVICE_MODEL := NN6000 v1
	SOC := ipq6000
	KERNEL_SIZE := 6144k
	DEVICE_DTS_CONFIG := config@cp03-c1
	DEVICE_PACKAGES := ipq-wifi-link_nn6000 kmod-fs-f2fs f2fs-tools
	IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | append-metadata
endef
TARGET_DEVICES += link_nn6000-v1

define Device/link_nn6000-v2
	$(Device/link_nn6000-v1)
	DEVICE_MODEL := NN6000 v2
endef
TARGET_DEVICES += link_nn6000-v2
