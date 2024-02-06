# --------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024 Jayesh Badwaik <j.badwaik@fz-juelich.de>
# --------------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.25)
project(simple-scaler LANGUAGES CXX C)
list(APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}/cmake")
find_package(quickmpi REQUIRED)
add_executable(simple-scaler simple-scaler.cpp)
target_link_libraries(simple-scaler PRIVATE quickmpi::mpi)

