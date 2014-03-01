#!/bin/bash

BASE=`pwd`
cd buildroot/
make menuconfig BR2_EXTERNAL=$BASE
make savedefconfig BR2_DEFCONFIG=$BASE/configs/multiplicity_defconfig
