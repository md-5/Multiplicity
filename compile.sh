#!/bin/bash

BASE=`pwd`
cd buildroot/
make multiplicity_defconfig BR2_EXTERNAL=$BASE
make BR2_EXTERNAL=$BASE
