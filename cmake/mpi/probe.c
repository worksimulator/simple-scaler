// -------------------------------------------------------------------------------------------------
// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2024 Jayesh Badwaik <j.badwaik@fz-juelich.de>
// -------------------------------------------------------------------------------------------------
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_vendor_information()
{
#if defined(OPEN_MPI)
  printf("openmpi\n");
#elif defined(MPICH)
  printf("mpich\n");
#else
  printf("unknown\n");
#endif
}

void print_version_information() { printf("%d\n", MPI_VERSION); }

void print_subversion_information() { printf("%d\n", MPI_SUBVERSION); }

void print_help()
{
  printf("Incorrect Usage of probe.\n\n");
  printf("Expected Usage: probe [--vendor|--version]\n");
}

int main(int argc, char** argv)
{
  if (argc != 2) {
    print_help();
    return EXIT_FAILURE;
  }

  char const* operation_name_vendor = "--vendor";
  char const* operation_name_version = "--version";
  char const* operation_name_subversion = "--subversion";

  if (strcmp(argv[1], operation_name_vendor) == 0) {
    print_vendor_information();
  } else if (strcmp(argv[1], operation_name_version) == 0) {
    print_version_information();
  } else if (strcmp(argv[1], operation_name_subversion) == 0) {
    print_subversion_information();
  } else {
    print_help();
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
