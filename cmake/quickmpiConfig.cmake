# --------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024 Jayesh Badwaik <j.badwaik@fz-juelich.de>
# --------------------------------------------------------------------------------------------------
include(CMakePushCheckState)
cmake_push_check_state()

add_library(quickmpi::mpi INTERFACE IMPORTED)
find_program(QMPICC mpicc REQUIRED DOC "mpicc")
find_program(QMPICXX mpicxx REQUIRED DOC "mpicxx")

execute_process(
  COMMAND
  ${QMPICC} ${CMAKE_CURRENT_LIST_DIR}/mpi/probe.c -o ${CMAKE_CURRENT_BINARY_DIR}/mpi_prober
  COMMAND_ERROR_IS_FATAL ANY
  )

set(QMPI_PROBE ${CMAKE_CURRENT_BINARY_DIR}/mpi_prober)

execute_process(
  COMMAND ${QMPI_PROBE} --vendor
  OUTPUT_VARIABLE MPI_VENDOR
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

execute_process(
  COMMAND ${QMPI_PROBE} --version
  OUTPUT_VARIABLE MPI_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

execute_process(
  COMMAND ${QMPI_PROBE} --subversion
  OUTPUT_VARIABLE MPI_SUBVERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

if(MPI_VENDOR STREQUAL "openmpi")
  set(COMPILE_FLAG_PROBE "--showme:compile")
  set(LINK_FLAG_PROBE "--showme:link")
elseif(MPI_VENDOR STREQUAL "mpich")
  if(${MPI_VERSION} LESS 4)
    set(COMPILE_FLAG_PROBE "-compile-info")
    set(LINK_FLAG_PROBE "-link-info")
  else()
    set(COMPILE_FLAG_PROBE "-show-compile-info")
    set(LINK_FLAG_PROBE "-show-link-info")
  endif()
endif()

execute_process(
  COMMAND ${QMPICC} ${COMPILE_FLAG_PROBE}
  OUTPUT_VARIABLE MPI_COMPILE_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)
separate_arguments(MPI_COMPILE_FLAGS UNIX_COMMAND "${MPI_COMPILE_FLAGS}")


execute_process(
  COMMAND ${QMPICC} ${LINK_FLAG_PROBE}
  OUTPUT_VARIABLE MPI_LINK_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

message(DEBUG "MPI Compile Flags: ${MPI_COMPILE_FLAGS}")
message(DEBUG "MPI Link Flags: ${MPI_LINK_FLAGS}")

string(REPLACE "-Wl,-rpath -Wl" "-Wl,-rpath" MPI_LINK_FLAGS ${MPI_LINK_FLAGS})
separate_arguments(MPI_LINK_FLAGS UNIX_COMMAND "${MPI_LINK_FLAGS}")

target_compile_options(quickmpi::mpi INTERFACE $<$<COMPILE_LANGUAGE:C>:${MPI_COMPILE_FLAGS}>)
target_link_options(quickmpi::mpi INTERFACE ${MPI_LINK_FLAGS})

execute_process(
  COMMAND ${QMPICXX} ${COMPILE_FLAG_PROBE}
  OUTPUT_VARIABLE MPI_COMPILE_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)
separate_arguments(MPI_COMPILE_FLAGS UNIX_COMMAND "${MPI_COMPILE_FLAGS}")

execute_process(
  COMMAND ${QMPICXX} ${LINK_FLAG_PROBE}
  OUTPUT_VARIABLE MPI_LINK_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

string(REPLACE "-Wl,-rpath -Wl" "-Wl,-rpath" MPI_LINK_FLAGS ${MPI_LINK_FLAGS})
separate_arguments(MPI_LINK_FLAGS UNIX_COMMAND "${MPI_LINK_FLAGS}")

message(DEBUG "MPI Compile Flags: ${MPI_COMPILE_FLAGS}")
message(DEBUG "MPI Link Flags: ${MPI_LINK_FLAGS}")

target_compile_options(quickmpi::mpi INTERFACE $<$<COMPILE_LANGUAGE:CXX>:${MPI_COMPILE_FLAGS}>)
target_link_options(quickmpi::mpi INTERFACE ${MPI_LINK_FLAGS})

cmake_pop_check_state()
