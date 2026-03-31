# Copied and adapted from:
# https://github.com/microsoft/vcpkg/blob/7adc2e4d49e8d0efc07a369079faa6bc3dbb90f3/scripts/toolchains/linux.cmake
#
# Adapted for ARM64 cross-compilation with clang/LLVM.

if(NOT _VCPKG_LINUX_CLANG_TOOLCHAIN)
    set(_VCPKG_LINUX_CLANG_TOOLCHAIN 1)

    if(POLICY CMP0056)
        cmake_policy(SET CMP0056 NEW)
    endif()
    if(POLICY CMP0066)
        cmake_policy(SET CMP0066 NEW)
    endif()
    if(POLICY CMP0067)
        cmake_policy(SET CMP0067 NEW)
    endif()
    if(POLICY CMP0137)
        cmake_policy(SET CMP0137 NEW)
    endif()
    list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
        VCPKG_CRT_LINKAGE VCPKG_TARGET_ARCHITECTURE
        VCPKG_C_FLAGS VCPKG_CXX_FLAGS
        VCPKG_C_FLAGS_DEBUG VCPKG_CXX_FLAGS_DEBUG
        VCPKG_C_FLAGS_RELEASE VCPKG_CXX_FLAGS_RELEASE
        VCPKG_LINKER_FLAGS VCPKG_LINKER_FLAGS_RELEASE VCPKG_LINKER_FLAGS_DEBUG
    )

    set(CMAKE_SYSTEM_NAME Linux CACHE STRING "")
    set(CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "")  # Force ARM64

    # Use clang with explicit target for ARM64
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_ASM_COMPILER clang)
    set(CMAKE_C_COMPILER_TARGET aarch64-unknown-linux-gnu)
    set(CMAKE_CXX_COMPILER_TARGET aarch64-unknown-linux-gnu)
    set(CMAKE_ASM_COMPILER_TARGET aarch64-unknown-linux-gnu)

    # Force cross-compiling (even if host is also Linux)
    set(CMAKE_CROSSCOMPILING ON CACHE BOOL "")

    # Use LLVM tools for all binutils operations
    set(CMAKE_AR llvm-ar CACHE STRING "")
    set(CMAKE_RANLIB llvm-ranlib CACHE STRING "")
    set(CMAKE_LINKER lld CACHE STRING "")
    set(CMAKE_NM llvm-nm CACHE STRING "")
    set(CMAKE_OBJCOPY llvm-objcopy CACHE STRING "")
    set(CMAKE_OBJDUMP llvm-objdump CACHE STRING "")
    set(CMAKE_STRIP llvm-strip CACHE STRING "")

    # Ensure the linker is called with the correct emulation
    set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
    set(CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
    set(CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")

    # Paths for cross-compilation (adjust if your LLVM tools are not in PATH)
    set(CMAKE_C_FLAGS_INIT "-target aarch64-unknown-linux-gnu -fPIC ${VCPKG_C_FLAGS}")
    set(CMAKE_CXX_FLAGS_INIT "-target aarch64-unknown-linux-gnu -fPIC ${VCPKG_CXX_FLAGS}")
    set(CMAKE_ASM_FLAGS_INIT "-target aarch64-unknown-linux-gnu ${VCPKG_C_FLAGS}")

    # Debug/Release flags
    string(APPEND CMAKE_C_FLAGS_DEBUG_INIT " ${VCPKG_C_FLAGS_DEBUG} ")
    string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT " ${VCPKG_CXX_FLAGS_DEBUG} ")
    string(APPEND CMAKE_C_FLAGS_RELEASE_INIT " ${VCPKG_C_FLAGS_RELEASE} ")
    string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT " ${VCPKG_CXX_FLAGS_RELEASE} ")

    # Linker flags
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${VCPKG_LINKER_FLAGS} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${VCPKG_LINKER_FLAGS} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${VCPKG_LINKER_FLAGS} ")
    if(VCPKG_CRT_LINKAGE STREQUAL "static")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT "-static ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT "-static ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT "-static ")
    endif()
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT " ${VCPKG_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " ${VCPKG_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " ${VCPKG_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELEASE_INIT " ${VCPKG_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT " ${VCPKG_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT " ${VCPKG_LINKER_FLAGS_RELEASE} ")
endif()
