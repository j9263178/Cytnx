CytnxPATH=.
CUDA_PATH=/usr/local/cuda
INCFLAGS :=-I$(CytnxPATH)/include

CC:= g++
CCFLAGS := -std=c++11 -g -Wformat=0 -fPIC
LDFLAGS :=  -llapack -lblas


GPU_Enable=0
OMP_Enable=1
DEBUG_Enable=0


NVCC:= $(CUDA_PATH)/bin/nvcc -ccbin $(CC)
NVFLAGS:= -m64 -g
SMS ?= 30
GENCODE_FLAGS:= -arch=sm_$(SMS)

ifeq ($(OMP_Enable),1)
  CCFLAGS += -fopenmp -DUNI_OMP
endif

ifeq ($(DEBUG_Enable),1)
  CCFLAGS += -DUNI_DEBUG
endif

ALL_CCFLAGS := 
ifeq ($(GPU_Enable),1)
  CCFLAGS += -I$(CUDA_PATH)/include -DUNI_GPU
  ALL_CCFLAGS += $(NVFLAGS)
  ALL_CCFLAGS += $(addprefix -Xcompiler , $(CCFLAGS))
  ALL_CCFLAGS += $(addprefix -Xcompiler , $(INCFLAGS))
  ALL_CCFLAGS += $(GENCODE_FLAGS)
else
  ALL_CCFLAGS += $(CCFLAGS)
endif

ALL_LDFLAGS :=
ifeq ($(GPU_Enable),1)
  LDFLAGS += -lcublas -lcusolver -lcurand
  ALL_LDFLAGS += $(addprefix -Xlinker , $(LDFLAGS))
  ALL_LDFLAGS += -L$(CUDA_PATH)/lib64
  LDFLAGS += -L$(CUDA_PATH)/lib64 -lcudart
else
  ALL_LDFLAGS += $(LDFLAGS)
endif

OBJS = Storage_base.o Uint32Storage.o Int32Storage.o Uint64Storage.o Int64Storage.o FloatStorage.o DoubleStorage.o ComplexFloatStorage.o ComplexDoubleStorage.o Type.o Device.o


OBJS += Storage.o Bond.o Tensor.o Symmetry.o

## Utils
OBJS += Cast_cpu.o Alloc_cpu.o Movemem_cpu.o Range_cpu.o complex_arithmic.o is.o
ifeq ($(GPU_Enable),1)
  OBJS += cuAlloc_gpu.o cuCast_gpu.o cuMovemem_gpu.o
endif

## Linalg_internal
OBJS += linalg_internal_interface.o
OBJS += Add_internal.o Sub_internal.o Mul_internal.o Div_internal.o Arithmic_internal.o Svd_internal.o Inv_inplace_internal.o Conj_inplace_internal.o Exp_internal.o
ifeq ($(GPU_Enable),1)
  OBJS += cuAdd_internal.o cuSub_internal.o cuMul_internal.o cuDiv_internal.o cuArithmic_internal.o cuSvd_internal.o cuInv_inplace_internal.o cuConj_inplace_internal.o cuExp_internal.o 
endif

## Linalg
OBJS += Add.o Div.o Sub.o Mul.o Svd.o Inv.o Inv_.o Conj.o Conj_.o Exp.o Exp_.o


ALLOBJS = $(OBJS)
##
ifeq ($(GPU_Enable),1)
  ALLOBJS += gpusrc.o
endif




all: test 



test: test.o $(ALLOBJS)
	$(CC) $^ $(CCFLAGS) $(LDFLAGS) -o $@

pyobj: $(ALLOBJS)
	$(CC) $(INCFLAGS) $(CCFLAGS) $(shell python3 -m pybind11 --includes)  pybind/cytnx.cpp $^ $(LDFLAGS) -shared -o cytnx$(shell python3-config --extension-suffix)




ifeq ($(GPU_Enable),1)
gpusrc.o: $(OBJS)
	$(NVCC) $(ALL_CCFLAGS) $(ALL_LDFLAGS) -dlink $^ -o $@ 
endif

## Tensor
Tensor.o: $(CytnxPATH)/src/Tensor.cpp $(CytnxPATH)/include/Tensor.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<

Bond.o : $(CytnxPATH)/src/Bond.cpp $(CytnxPATH)/include/Bond.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<

Symmetry.o: $(CytnxPATH)/src/Symmetry.cpp $(CytnxPATH)/include/Symmetry.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<

Storage.o: $(CytnxPATH)/src/Storage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<


## Storage 
###########################
Storage_base.o: $(CytnxPATH)/src/Storage_base.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<

Uint32Storage.o: $(CytnxPATH)/src/Uint32Storage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  
Int32Storage.o: $(CytnxPATH)/src/Int32Storage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  
Uint64Storage.o: $(CytnxPATH)/src/Uint64Storage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  
Int64Storage.o: $(CytnxPATH)/src/Int64Storage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  
FloatStorage.o: $(CytnxPATH)/src/FloatStorage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

DoubleStorage.o: $(CytnxPATH)/src/DoubleStorage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

ComplexFloatStorage.o: $(CytnxPATH)/src/ComplexFloatStorage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

ComplexDoubleStorage.o: $(CytnxPATH)/src/ComplexDoubleStorage.cpp $(CytnxPATH)/include/Storage.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  


## linalg_internal
###########################
linalg_internal_interface.o : $(CytnxPATH)/src/linalg/linalg_internal_interface.cpp $(CytnxPATH)/include/linalg/linalg_internal_interface.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Arithmic_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Arithmic_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Arithmic_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Add_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Add_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Add_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Mul_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Mul_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Mul_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Sub_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Sub_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Sub_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  


Div_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Div_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Div_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Svd_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Svd_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Svd_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Exp_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Exp_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Exp_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Inv_inplace_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Inv_inplace_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Inv_inplace_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  

Conj_inplace_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_cpu/Conj_inplace_internal.cpp $(CytnxPATH)/include/linalg/linalg_internal_cpu/Conj_inplace_internal.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<  


ifeq ($(GPU_Enable),1)

cuArithmic_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuArithmic_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuArithmic_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuAdd_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuAdd_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuAdd_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuMul_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuMul_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuMul_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuSub_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuSub_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuSub_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuDiv_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuDiv_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuDiv_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuSvd_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuSvd_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuSvd_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuExp_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuExp_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuExp_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuInv_inplace_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuInv_inplace_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuInv_inplace_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

cuConj_inplace_internal.o :  $(CytnxPATH)/src/linalg/linalg_internal_gpu/cuConj_inplace_internal.cu $(CytnxPATH)/include/linalg/linalg_internal_gpu/cuConj_inplace_internal.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@

endif



## Misc
##########################
Type.o : $(CytnxPATH)/src/Type.cpp $(CytnxPATH)/include/Type.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<

Device.o: $(CytnxPATH)/src/Device.cpp $(CytnxPATH)/include/Device.hpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<


## Utils
##########################
Cast_cpu.o: $(CytnxPATH)/src/utils/utils_internal_cpu/Cast_cpu.cpp $(CytnxPATH)/include/utils/utils_internal_cpu/Cast_cpu.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

Movemem_cpu.o: $(CytnxPATH)/src/utils/utils_internal_cpu/Movemem_cpu.cpp $(CytnxPATH)/include/utils/utils_internal_cpu/Movemem_cpu.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

Alloc_cpu.o: $(CytnxPATH)/src/utils/utils_internal_cpu/Alloc_cpu.cpp $(CytnxPATH)/include/utils/utils_internal_cpu/Alloc_cpu.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

Range_cpu.o: $(CytnxPATH)/src/utils/utils_internal_cpu/Range_cpu.cpp $(CytnxPATH)/include/utils/utils_internal_cpu/Range_cpu.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

complex_arithmic.o: $(CytnxPATH)/src/utils/complex_arithmic.cpp $(CytnxPATH)/include/utils/complex_arithmic.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

is.o: $(CytnxPATH)/src/utils/is.cpp $(CytnxPATH)/include/utils/is.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<


ifeq ($(GPU_Enable),1)
cuAlloc_gpu.o: $(CytnxPATH)/src/utils/utils_internal_gpu/cuAlloc_gpu.cu $(CytnxPATH)/include/utils/utils_internal_gpu/cuAlloc_gpu.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@
cuCast_gpu.o: $(CytnxPATH)/src/utils/utils_internal_gpu/cuCast_gpu.cu $(CytnxPATH)/include/utils/utils_internal_gpu/cuCast_gpu.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@
cuMovemem_gpu.o: $(CytnxPATH)/src/utils/utils_internal_gpu/cuMovemem_gpu.cu $(CytnxPATH)/include/utils/utils_internal_gpu/cuMovemem_gpu.hpp
	$(NVCC) $(ALL_CCFLAGS) -dc $< -o $@
endif


## Linalg:
########################
Add.o: $(CytnxPATH)/src/linalg/Add.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Mul.o: $(CytnxPATH)/src/linalg/Mul.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Sub.o: $(CytnxPATH)/src/linalg/Sub.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Div.o: $(CytnxPATH)/src/linalg/Div.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Svd.o: $(CytnxPATH)/src/linalg/Svd.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Inv.o: $(CytnxPATH)/src/linalg/Inv.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Inv_.o: $(CytnxPATH)/src/linalg/Inv_.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Conj.o: $(CytnxPATH)/src/linalg/Conj.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Conj_.o: $(CytnxPATH)/src/linalg/Conj_.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Exp.o: $(CytnxPATH)/src/linalg/Exp.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<
Exp_.o: $(CytnxPATH)/src/linalg/Exp_.cpp $(CytnxPATH)/include/linalg/linalg.hpp
	$(CC)  $(CCFLAGS) $(INCFLAGS) -c $<

test.o: test.cpp
	$(CC) $(CCFLAGS) $(INCFLAGS) -c $<



.phony : clean cleanpy

clean:
	rm *.o test

cleanpy:
	rm *.so
