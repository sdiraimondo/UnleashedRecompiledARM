# UnleashedRecompiled for ARM devices

Based on Vennstones tutorial : https://interfacinglinux.com/2026/03/26/sonic-unleashed-running-natively-on-arm-linux-is-wild/

## Compilation
### Step 1: Install Dependencies
*Before building anything, you need to install some tools and libraries for aarch64 cross compilation.*

sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
sudo apt install autoconf automake libtool pkg-config curl cmake ninja-build clang clang-tools libgtk-3-dev zip unzip tar libpipewire-0.3-dev libpulse-dev libasound2-dev clang lld mesa-vulkan-drivers git

### Step 2: Clone the repository from Github
git clone --recurse-submodules https://github.com/hedge-dev/UnleashedRecomp.git ; cd UnleashedRecomp

###  Step 3: Configure the CMake Build
*This tells CMake to configure the project for a release build targeting ARM64 Linux. The VCPKG_FORCE_SYSTEM_BINARIES environment variable forces vcpkg to use the system-installed binaries.*

export VCPKG_FORCE_SYSTEM_BINARIES=1
cmake . --preset linux-release -DVCPKG_TARGET_TRIPLET=arm64-linux

### Step 4: Donwload & Build DirectX Shader Compiler
Clone and initialise the repo*

git clone https://github.com/microsoft/DirectXShaderCompiler ; cd DirectXShaderCompiler ; git submodule update --init --recursive

*Configure for ARM64*

cmake -B build -DCMAKE_BUILD_TYPE=Release \
  -C cmake/caches/PredefinedParams.cmake \
  -DLLVM_TARGETS_TO_BUILD="" \
  -DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-linux-gnu \
  -DLLVM_ENABLE_EH=ON \
  -DLLVM_ENABLE_RTTI=ON

* And compile!*
cmake --build build -- -j$(nproc)

* Copy the binaries into the project*
cp build/lib/libdxcompiler.so ~/Downloads/UnleashedRecomp/tools/XenosRecomp/thirdparty/dxc-bin/lib/arm64/
cp build/bin/dxc ~/Downloads/UnleashedRecomp/tools/XenosRecomp/thirdparty/dxc-bin/bin/arm64/dxc-linux

'Bravo ! Back to the project root.
cd ..
