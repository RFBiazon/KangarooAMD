/*
* This file is part of the BTCCollider distribution (https://github.com/JeanLucPons/Kangaroo).
* Copyright (c) 2020 Jean Luc PONS.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, version 3.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef WIN64
#include <unistd.h>
#include <stdio.h>
#endif

#include "GPUEngine.h"
#include <hip/hip_runtime.h>

#include <stdint.h>
#include "../Timer.h"

#include "GPUMath.h"
#include "GPUCompute.h"

// Macros para tradução CUDA -> HIP
#define cudaError_t hipError_t
#define cudaSuccess hipSuccess
#define cudaGetLastError hipGetLastError
#define cudaDeviceSynchronize hipDeviceSynchronize
#define cudaMemcpy hipMemcpy
#define cudaMemcpyHostToDevice hipMemcpyHostToDevice
#define cudaMemcpyDeviceToHost hipMemcpyDeviceToHost
#define cudaMalloc hipMalloc
#define cudaFree hipFree
#define cudaHostAlloc hipHostMalloc
#define cudaFreeHost hipHostFree
#define cudaMemcpyToSymbol hipMemcpyToSymbol
#define cudaHostAllocPortable hipHostMallocPortable
#define cudaHostAllocWriteCombined hipHostMallocWriteCombined
#define cudaHostAllocMapped hipHostMallocMapped
#define cudaEvent_t hipEvent_t
#define cudaEventCreate hipEventCreate
#define cudaEventRecord hipEventRecord
#define cudaEventQuery hipEventQuery
#define cudaEventDestroy hipEventDestroy
#define cudaErrorNotReady hipErrorNotReady

// ---------------------------------------------------------------------------------------

__global__ void comp_kangaroos(uint64_t *kangaroos, uint32_t maxFound, uint32_t *found, uint64_t dpMask) {
  int xPtr = (blockIdx.x*blockDim.x*GPU_GRP_SIZE) * KSIZE; // x[4] , y[4] , d[2], lastJump
  ComputeKangaroos(kangaroos + xPtr, maxFound, found, dpMask);
}

// ... [restante dos kernels permanecem inalterados, pois HIP usa a mesma sintaxe] ...

// ---------------------------------------------------------------------------------------

using namespace std;

int _ConvertSMVer2Cores(int major, int minor) {
  // [Implementação permanece idêntica, pois é lógica CPU]
  // ...
}

void GPUEngine::SetWildOffset(Int* offset) {
  wildOffset.Set(offset);
}

GPUEngine::GPUEngine(int nbThreadGroup, int nbThreadPerGroup, int gpuId, uint32_t maxFound) {
  // Substituições CUDA -> HIP:
  initialised = false;
  hipError_t err;

  int deviceCount = 0;
  hipError_t error_id = hipGetDeviceCount(&deviceCount);

  if(error_id != hipSuccess) {
    printf("GPUEngine: hipGetDeviceCount %s\n", hipGetErrorString(error_id));
    return;
  }

  if(deviceCount == 0) {
    printf("GPUEngine: No available HIP devices\n");
    return;
  }

  err = hipSetDevice(gpuId);
  if(err != hipSuccess) {
    printf("GPUEngine: %s\n", hipGetErrorString(err));
    return;
  }

  hipDeviceProp_t deviceProp;
  hipGetDeviceProperties(&deviceProp, gpuId);

  // [Restante da implementação permanece similar, com substituições:]
  // cudaDeviceSetCacheConfig -> hipDeviceSetCacheConfig (se disponível)
  // cudaMalloc -> hipMalloc
  // cudaHostAlloc -> hipHostMalloc
  // etc...
}

// [Todas as outras funções seguem o mesmo padrão de substituição]
// ...

bool GPUEngine::Launch(std::vector<ITEM> &hashFound, bool spinWait) {
  // Adaptações similares para HIP
  // ...
}

// ---------------------------------------------------------------------------------------
