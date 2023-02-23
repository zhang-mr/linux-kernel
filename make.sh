#/bin/bash

#set -x

BUILD_JOBS=8
CORSS_PATH=../prebuilts/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-

usage()
{
   echo "USAGE: [-U] [-CK] [-A] [-p] [-o] [-u] [-v VERSION_NAME]  "
    echo "No ARGS means use default build option                  "
    echo "WHERE: -U = build uboot                                 "
    echo "       -M = build kernel for meauconfig                 "
    echo "       -K = build kernel                                "
    echo "       -S = save defconfig for jz2440     			  "
    echo "       -p = will build packaging in IMAGE      		  "
    echo "       -o = build OTA package                           "
    echo "       -u = build update.img                            "
    echo "       -v = build android with 'user' or 'userdebug'    "
    echo "       -d = huild kernel dts name    "
    echo "       -V = build version    "
    echo "       -J = build jobs    "
    exit 1
}

# check pass argument
while getopts "UMKSBpouv:d:V:J:" arg
do
    case $arg in
        U)
            echo "will build u-boot"
            BUILD_UBOOT=true
            ;;
        K)
            echo "will build kernel"
            BUILD_KERNEL=true
            ;;
		M)
            echo "will build kernel menuconfig"
            BUILD_MENUCONFIG=true
            ;;
        S)
            echo "Save deconfig for jz2440"
            BUILD_DEFCONFIG=true
            ;;
        B)
            echo "will build AB Image"
            BUILD_AB_IMAGE=true
            ;;
        p)
            echo "will build packaging in IMAGE"
            BUILD_PACKING=true
            ;;
        o)
            echo "will build ota package"
            BUILD_OTA=true
            ;;
        u)
            echo "will build update.img"
            BUILD_UPDATE_IMG=true
            ;;
        v)
            BUILD_VARIANT=$OPTARG
            ;;
        V)
            BUILD_VERSION=$OPTARG
            ;;
        d)
            KERNEL_DTS=$OPTARG
            ;;
        J)
            BUILD_JOBS=$OPTARG
            ;;
        ?)
            usage ;;
    esac
done

if [ "$BUILD_KERNEL" = true ] ; then
	cd ./kernel
	make ARCH=arm CROSS_COMPILE=$CORSS_PATH -j$BUILD_JOBS uImage
	cp -rf arch/arm/boot/uImage ../../tftp_img/
fi

if [ "$BUILD_MENUCONFIG" = true ] ; then
	cd ./kernel
#	make ARCH=arm CROSS_COMPILE=$CORSS_PATH jz2440_defconfig
	make ARCH=arm CROSS_COMPILE=$CORSS_PATH menuconfig
fi

if [ "$BUILD_DEFCONFIG" = true ] ; then
	cd ./kernel
	make ARCH=arm CROSS_COMPILE=$CORSS_PATH savedefconfig && mv defconfig arch/arm/configs/jz2440_defconfig
fi

