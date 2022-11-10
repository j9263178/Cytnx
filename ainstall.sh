rm -rf build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/home/j9263178/cytnx_noboost/ -DUSE_MKL=on -DBUILD_PYTHON=on -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ../
make -j `nproc`
make install
