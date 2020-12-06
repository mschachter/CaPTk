#MESSAGE( "External project - Eigen" )

SET( Eigen_DEPENDENCIES )

MESSAGE( STATUS "Adding Eigen-3.3.8 ...")

ExternalProject_Add( 
  Eigen
  GIT_REPOSITORY https://gitlab.com/libeigen/eigen.git #  url from where to download
  GIT_TAG 3.3.8
  SOURCE_DIR Eigen
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND cmake -E echo "Skipping install step."
)

SET( EIGEN_INCLUDE_DIR ${CMAKE_BINARY_DIR}/Eigen CACHE STRING "Eigen Include Dir" )