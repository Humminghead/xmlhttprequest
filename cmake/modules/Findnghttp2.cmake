find_path(NGHTTP2_INCLUDE_DIR NAMES "nghttp2.h" PATHS /usr/local PATH_SUFFIXES include/nghttp2)
find_file(NGHTTP2_VERSION_FILE NAMES nghttp2ver.h PATHS ${NGHTTP2_INCLUDE_DIR})
find_library(NGHTTP2_LIBRARY libnghttp2.so ${CMAKE_SYSTEM_LIBRARY_PATH})
find_library(NGHTTP2_STATIC_LIBRARY libnghttp2.a ${CMAKE_SYSTEM_LIBRARY_PATH})
find_library(NGHTTP2_ASIO_LIBRARY libnghttp2_asio.so ${CMAKE_SYSTEM_LIBRARY_PATH})

option(NGHTTP2_VERBOSE "Prints debug info generated by NGHTTP2 cmake module" OFF)
option(NGHTTP2_USE_STATIC_LIB "Use static version of NGHTTP2 library" OFF)

mark_as_advanced(NGHTTP2_INCLUDE_DIR NGHTTP2_STATIC_LIBRARY NGHTTP2_ASIO_LIBRARY NGHTTP2_VERBOSE NGHTTP2_USE_STATIC_LIB)

if(NGHTTP2_VERSION_FILE)
	file(STRINGS ${NGHTTP2_VERSION_FILE} NGHTTP2_VERSION_STR REGEX "\"([0-9]+)\\.([0-9]+)\\.([0-9]+)\"$")

	if(NGHTTP2_VERSION_STR)
		string(REPLACE "#define NGHTTP2_VERSION" "NGHTTP2_VERSION" NGHTTP2_VERSION_STR ${NGHTTP2_VERSION_STR})
		string(REPLACE "\"" "" NGHTTP2_VERSION_STR ${NGHTTP2_VERSION_STR})
		string(REPLACE "." ";" NGHTTP2_VERSION_LST ${NGHTTP2_VERSION_STR})

		list(GET NGHTTP2_VERSION_LST 0 NGHTTP2_VERSION_MAJOR)
		list(GET NGHTTP2_VERSION_LST 1 NGHTTP2_VERSION_MINOR)
		list(GET NGHTTP2_VERSION_LST 2 NGHTTP2_VERSION_RELEASE)
		
		message(STATUS ${NGHTTP2_VERSION_MAJOR}.${NGHTTP2_VERSION_MINOR}.${NGHTTP2_VERSION_RELEASE})	
	endif()
endif()

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(nghttp2 NGHTTP2_INCLUDE_DIR NGHTTP2_LIBRARY NGHTTP2_STATIC_LIBRARY NGHTTP2_ASIO_LIBRARY )

if(nghttp2_FOUND)
  set(NGHTTP2_INCLUDE_DIRS "${NGHTTP2_INCLUDE_DIR}")
  	if(NOT NGHTTP2_USE_STATIC_LIB)
  		set(NGHTTP2_LIBRARIES ${NGHTTP2_LIBRARY} ${NGHTTP2_ASIO_LIBRARY})
	else()
		set(NGHTTP2_LIBRARIES ${NGHTTP2_STATIC_LIBRARY} ${NGHTTP2_ASIO_LIBRARY})
	endif()

	if(NOT TARGET nghttp2::nghttp2)
		add_library(nghttp2::nghttp2 UNKNOWN IMPORTED)
		set_target_properties(nghttp2::nghttp2 PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${NGHTTP2_INCLUDE_DIRS}")
		# if(EXISTS "${NGHTTP2_LIBRARY}")
  #     		set_target_properties(nghttp2::nghttp2 PROPERTIES
  #       	IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  #       	IMPORTED_LOCATION "${NGHTTP2_LIBRARY}")
  #   	endif()
	endif()
else()
	if(NGHTTP2_VERBOSE)
		message(STATUS "NGHTTP2 NOT FOUND!")
	endif()
	return()
endif()

if(NGHTTP2_VERBOSE)
	message(STATUS "Nghttp2 include dir:" ${NGHTTP2_INCLUDE_DIR})
	message(STATUS "Nghttp2 version file:" ${NGHTTP2_VERSION_FILE})
	message(STATUS "Nghttp2 library dir:" ${NGHTTP2_LIBRARY})
	message(STATUS "Nghttp2 asio library dir:" ${NGHTTP2_ASIO_LIBRARY})
endif()





