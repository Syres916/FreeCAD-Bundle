# create a new environment in the AppDir
conda create \
    -p AppDir/usr \
    freecad=0.18.1 calculix blas=*=openblas gitpython \
    numpy matplotlib scipy sympy pandas six pyyaml \
    --copy \
    --no-default-packages \
    -c conda-forge/label/dev_cf201901 \
    -c conda-forge/label/cf201901 \
    -y


# installing some additional libraries with pip
# version_name=$(conda run -p AppDir/usr python get_freecad_version.py)
version_name="FreeCAD_0.18_stable"
conda run -p AppDir/usr pip install https://github.com/looooo/freecad_pipintegration/archive/master.zip

# this will create a huge env. We have to find some ways to make the env smaller
# deleting some packages explicitly?
conda remove -p AppDir/usr --force -y \
    ruamel_yaml conda system tk json-c llvmdev \
    nomkl readline mesalib \
    curl gstreamer libtheora asn1crypto certifi chardet \
    gst-plugins-base idna kiwisolver pycosat pycparser pysocks \
    sip solvespace tornado xorg* cffi \
    cryptography-vectors pyqt soqt wheel \
    requests libstdcxx-ng xz sqlite ncurses

conda list -p AppDir/usr

# delete unnecessary stuff
rm -rf AppDir/usr/include
find AppDir/usr -name \*.a -delete
mv AppDir/usr/bin AppDir/usr/bin_tmp
mkdir AppDir/usr/bin
cp AppDir/usr/bin_tmp/FreeCAD AppDir/usr/bin/
cp AppDir/usr/bin_tmp/FreeCADCmd AppDir/usr/bin/
cp AppDir/usr/bin_tmp/ccx AppDir/usr/bin/
cp AppDir/usr/bin_tmp/python AppDir/usr/bin/
cp AppDir/usr/bin_tmp/pip AppDir/usr/bin/
cp AppDir/usr/bin_tmp/pyside2-rcc AppDir/usr/bin/
sed -i '1s|.*|#!/usr/bin/env python|' AppDir/usr/bin/pip
rm -rf AppDir/usr/bin_tmp
#+ deleting some specific libraries not needed. eg.: stdc++

# add documentation
cp ../../doc/* AppDir/usr/doc/

# create the appimage
chmod a+x ./AppDir/AppRun
rm *.AppImage
ARCH=x86_64 ../../appimagetool-x86_64.AppImage \
  AppDir  ${version_name}.AppImage
