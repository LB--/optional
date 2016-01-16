
include(FindPackageMessage)

# Figure out which package we are finding
get_filename_component(_filename ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
string(SUBSTRING "${_filename}" 4 -1 _package) # get rid of "Find"
string(REPLACE "_" "/" _package_name "${_package}")

# Find where all versions are installed
if(NOT ${_package}_ROOT)
	find_path(${_package}_ROOT
		NAMES
			${_package_name}
	)
endif()

if(${${_package}_ROOT} STREQUAL "${_package}_ROOT-NOTFOUND")
	set(_error "Could not find where ${_package_name} versions are stored - please set ${_package}_ROOT")
	if(${_package}_FIND_REQUIRED)
		message(FATAL_ERROR ${_error})
	else()
		FIND_PACKAGE_MESSAGE(${_package}
			${_error}
			"${${_package}_ROOT}"
		)
	endif()
	return()
endif()

message(STATUS "${_package}_ROOT=${${_package}_ROOT}")

set(${_package}_VERSIONS_DIRECTORY ${${_package}_ROOT}/${_package_name})

# Get a list of the versions (do not treat as sorted - alphabetcial sorting is incorrect)
file(GLOB ${_package}_VERSIONS
	LIST_DIRECTORIES true
	RELATIVE ${${_package}_VERSIONS_DIRECTORY}
	${${_package}_VERSIONS_DIRECTORY}/*
)

message(STATUS "${_package}_VERSIONS=${${_package}_VERSIONS}")

message(STATUS "########")
message(STATUS "${${_package}_FIND_VERSION}")
message(STATUS "${${_package}_FIND_VERSION_EXACT}")
message(STATUS "${${_package}_FIND_VERSION_MAJOR}")
message(STATUS "${${_package}_FIND_VERSION_MINOR}")
message(STATUS "${${_package}_FIND_VERSION_PATCH}")
message(STATUS "${${_package}_FIND_VERSION_TWEAK}")
message(STATUS "${${_package}_FIND_QUIETLY}")
message(STATUS "${${_package}_FIND_REQUIRED}")
message(STATUS "########")

if(NOT ${_package}_VERSIONS)
	set(_error "Could not find ${_package_name} - no versions were detected in ${${_package}_VERSIONS_DIRECTORY}")
	if(${_package}_FIND_REQUIRED)
		message(FATAL_ERROR ${_error})
	else()
		FIND_PACKAGE_MESSAGE(${_package}
			${_error}
			"${${_package}_VERSIONS_DIRECTORY}"
		)
	endif()
	return()
endif()

# Normalize the version
set(_find_version ${${_package}_FIND_VERSION})
string(REPLACE "." ";" _find_version_list "${_find_version}")
list(LENGTH _find_version_list _find_version_depth)
while(_find_version_depth LESS 4)
	list(APPEND _find_version_list "0")
	list(LENGTH _find_version_list _find_version_depth)
endwhile()
string(REPLACE ";" "." _find_version "${_find_version_list}")
message(STATUS ">>>>>>>>>>>>>>>> ${${_package}_FIND_VERSION} => ${_find_version}")

# Find candidate versions
set(_candidate_versions "")
foreach(_version ${${_package}_VERSIONS})
	# Normalize the version
	string(REPLACE "." ";" _version_list "${_version}")
	list(LENGTH _version_list _version_depth)
	while(_version_depth LESS 4)
		list(APPEND _version_list "0")
		list(LENGTH _version_list _version_depth)
	endwhile()
	string(REPLACE ";" "." _version_norm "${_version_list}")
	message(STATUS ">>>>>>>>>>>>>>>> ${_version} => ${_version_norm}")

	# Is this version a candidate?
	if(${_package}_FIND_VERSION_EXACT)
		if(_version_norm VERSION_EQUAL _find_version)
			list(APPEND _candidate_versions ${_version})
		endif()
	else()
		if(_version_norm VERSION_EQUAL _find_version OR _version VERSION_GREATER _find_version)
			list(APPEND _candidate_versions ${_version})
		endif()
	endif()
endforeach()
message(STATUS "_candidate_versions=${_candidate_versions}")
return()
#WIP
	if(_version STREQUAL ${_package}_FIND_VERSION)
		include("${${_package}_VERSIONS_DIRECTORY}/${_version}/cmake/optional.cmake")
		FIND_PACKAGE_MESSAGE(${_package}
			"Found ${_package_name} version ${_version}"
			"${${_package}_VERSIONS_DIRECTORY}/${_version}"
		)
		set(${_package}_FOUND 1)
		return()
	endif()
if(${_package}_FIND_VERSION_EXACT)
	if(${_package}_FIND_REQUIRED)
		message(FATAL_ERROR "Could not find ${_package_name} version ${${_package}_FIND_VERSION} - available versions: ${${_package}_VERSIONS}")
	endif()
	return()
endif()
