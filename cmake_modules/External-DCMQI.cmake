
set(proj DCMQI)

# Set dependency list
set(${proj}_DEPENDENCIES SlicerExecutionModel)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED SlicerExecutionModel_DIR AND NOT EXISTS ${SlicerExecutionModel_DIR})
  message(FATAL_ERROR "SlicerExecutionModel_DIR variable is defined but corresponds to nonexistent directory")
endif()

if(NOT DEFINED SlicerExecutionModel_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  set(EXTERNAL_PROJECT_OPTIONAL_ARGS)

  if(APPLE)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_ARGS
      -DSlicerExecutionModel_DEFAULT_CLI_EXECUTABLE_LINK_FLAGS:STRING=-Wl,-rpath,@loader_path/../../../
      )
  endif()

  # ExternalProject_SetIfNotDefined(
  #   ${proj}_GIT_REPOSITORY
  #   "${EP_GIT_PROTOCOL}://github.com/Slicer/SlicerExecutionModel.git"
  #   QUIET
  #   )

  # ExternalProject_SetIfNotDefined(
  #   ${proj}_REVISION_TAG
  #   "62d0121dbb0fb057ebbd7c9ab84520accacec8bc"
  #   QUIET
  #   )

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    GIT_REPOSITORY "https://github.com/QIICR/dcmqi.git"
    GIT_TAG "v1.2.1"
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      -DBUILD_EXAMPLES:BOOL=OFF # examples are not needed
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS} 
      -DBUILD_TESTING:BOOL=OFF # testing the ITK build is not required
      -DDCMQI_SUPERBUILD:BOOL=OFF
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
      -DCMAKE_CXX_EXTENSIONS:BOOL=${CMAKE_CXX_EXTENSIONS}
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_TESTING:BOOL=OFF
      -DITK_DIR:PATH=${ITK_DIR}
      -DSlicerExecutionModel_LIBRARY_PROPERTIES:STRING=${DCMQI_LIBRARY_PROPERTIES}
      -DSlicerExecutionModel_INSTALL_BIN_DIR:PATH=./install/bin/
      -DSlicerExecutionModel_INSTALL_LIB_DIR:PATH=./install/lib/
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION:STRING=./install/bin/
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION:STRING=./install/bin/
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION:STRING=./install/lib/
      ${EXTERNAL_PROJECT_OPTIONAL_ARGS}
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )
  set(SlicerExecutionModel_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

# mark_as_superbuild(
#   VARS SlicerExecutionModel_DIR:PATH
#   LABELS "FIND_PACKAGE"
#   )