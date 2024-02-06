// -------------------------------------------------------------------------------------------------
// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2024 Jayesh Badwaik <j.badwaik@fz-juelich.de>
// -------------------------------------------------------------------------------------------------

#include <algorithm>
#include <array>
#include <cmath>
#include <fstream>
#include <iostream>
#include <mpi.h>
#include <random>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <thread>

#if defined(OPEN_MPI)
inline constexpr double mpi_factor = 1.0;
#elif defined(MPICH)
inline constexpr double mpi_factor = 2.0;
#endif

#if defined(__CUDACC__)
inline constexpr double gpu_factor = 1.2;
#else
inline constexpr double gpu_factor = 1.0;
#endif

#if defined(__clang__)
inline constexpr double compiler_factor = 1.0;
#elif defined(__NVCOMPILER)
inline constexpr double compiler_factor = 1.1;
#else
inline constexpr double compiler_factor = 1.2;
#endif

void print_help()
{
  printf("Incorrect Usage of simple-scaler\n\n");
  printf("Expected Usage: simple-scaler --size <problem_size>\n");
}

int main(int argc, char** argv)
{
  MPI_Init(nullptr, nullptr);
  int size = 0;
  int rank = 0;

  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (rank == 0) {
    std::cout << "simple-scaler : starting execution..." << std::endl;

    auto cmdline = std::vector<std::string>(argv, argv + argc);

    if (argc != 3) {
      print_help();
      return EXIT_FAILURE;
    }

    char const* operation_name_size = "--size";
    double problem_size = 10'000;
    double scaling = 0.9;

    if (strcmp(argv[1], operation_name_size) == 0) {
      problem_size = atof(argv[2]);
    } else {
      print_help();
      return EXIT_FAILURE;
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(10000));

    double runtime = 0;
    std::array<int, 624> seed_data;
    std::random_device r;
    std::generate_n(seed_data.data(), seed_data.size(), std::ref(r));
    std::seed_seq seq(std::begin(seed_data), std::end(seed_data));
    std::mt19937 eng(seq);

    std::uniform_real_distribution<double> dist(0.8, 1.2);

    double scaled_performance = compiler_factor * mpi_factor * gpu_factor * size
        * std::pow(scaling, std::log(size) / std::log(2));
    runtime = problem_size / scaled_performance;
    std::ofstream file("runtime");
    file << runtime << std::endl;
    std::cout << "Runtime: " << runtime << std::endl;
  }

  std::this_thread::sleep_for(std::chrono::milliseconds(10000));

  if (rank == 0) {
    std::cout << "simple-scaler : finished execution..." << std::endl;
  }

  MPI_Finalize();

  return EXIT_SUCCESS;
}
