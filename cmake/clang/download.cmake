if(NOT CUSTOM_CLANG)
  set(CLANG_VERSION "3.7.0")
  message(STATUS "Locating trusted Clang/LLVM ${CLANG_VERSION}")

  set(CLANG_URL "http://llvm.org/releases/${CLANG_VERSION}" )
  if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CLANG_DIRNAME "clang+llvm-${CLANG_VERSION}-x86_64-apple-darwin")
    set(CLANG_SHA256 "057e56b445ac5dfbf0d5475badab374edebe8db5428001c8829340e40724b50d")
    set(CLANG_FILENAME "${CLANG_DIRNAME}.tar.xz")
  elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    if(64_BIT_PLATFORM)
      set(CLANG_DIRNAME "clang+llvm-${CLANG_VERSION}-x86_64-linux-gnu-ubuntu-14.04")
      set(CLANG_SHA256 "093a94ff8982ae78461f0d2604c98f6b454c15e2ef768d34c235c6676c336460")
      set(CLANG_FILENAME "${CLANG_DIRNAME}.tar.xz")
    else()
      message(FATAL_ERROR "No pre-built Clang ${CLANG_VERSION} binaries for 32 bit Linux; this system is not supported")
    endif()
  elseif(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    if(64_BIT_PLATFORM)
      set(CLANG_DIRNAME "clang+llvm-${CLANG_VERSION}-amd64-unknown-freebsd10")
      set(CLANG_SHA256 "fe8c7136d254a4a25967c4d8d97f48a985cb594fe5c864dc234526a6bacfebe2")
      set(CLANG_FILENAME "${CLANG_DIRNAME}.tar.xz")
    else()
      set(CLANG_DIRNAME "clang+llvm-${CLANG_VERSION}-i386-unknown-freebsd10")
      set(CLANG_SHA256 "07cf94ddff7c4dff112eeadb95aab1b905cd40a3462c6afd808988164146d880")
      set(CLANG_FILENAME "${CLANG_DIRNAME}.tar.xz")
    endif()
  endif()

  file(DOWNLOAD
    "${CLANG_URL}/${CLANG_FILENAME}" "./${CLANG_FILENAME}"
    SHOW_PROGRESS EXPECTED_SHA256 "${CLANG_SHA256}")

  message(STATUS "Found ${CLANG_FILENAME}")

  if(NOT EXISTS ${CLANG_DIRNAME})
    message(STATUS "Extracting Clang/LLVM ${CLANG_VERSION}")

    execute_process(COMMAND mkdir -p ${CLANG_DIRNAME})
    if(CLANG_FILENAME MATCHES ".+bz2")
      execute_process(COMMAND tar -xjf ${CLANG_FILENAME} -C ${CLANG_DIRNAME} --strip-components 1)
    elseif(CLANG_FILENAME MATCHES ".+xz")
      execute_process(COMMAND tar -xJf ${CLANG_FILENAME} -C ${CLANG_DIRNAME} --strip-components 1)
    else()
      execute_process(COMMAND tar -xzf ${CLANG_FILENAME} -C ${CLANG_DIRNAME} --strip-components 1)
    endif()
  else()
    message(STATUS "Clang/LLVM ${CLANG_VERSION} already extracted")
  endif()

  set(LLVM_ROOT_PATH ${CMAKE_CURRENT_BINARY_DIR}/${CLANG_DIRNAME})

else()
  if(NOT LLVM_ROOT_PATH)
    message(FATAL_ERROR "Using a custom clang requires *at least* setting LLVM_ROOT_PATH. See the README for details.")
  endif()

  message(STATUS "Trusting custom clang at ${LLVM_ROOT_PATH}")
endif()

if(NOT LLVM_INCLUDE_PATH)
  set(LLVM_INCLUDE_PATH ${LLVM_ROOT_PATH}/include)
endif()
if(NOT LLVM_LIB_PATH)
  set(LLVM_LIB_PATH ${LLVM_ROOT_PATH}/lib)
endif()

add_custom_target(clean_clang
  COMMAND rm -rf ${CLANG_FILENAME} ${CLANG_DIRNAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
