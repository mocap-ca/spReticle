mkdir build_2018
cd build_2018
cmake -H.. -B. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
nmake
cd ..

mkdir build_2019
cd build_2019
cmake -H.. -B. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
nmake
cd ..

mkdir build_2020
cd build_2020
cmake -H.. -B. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
nmake
cd ..

