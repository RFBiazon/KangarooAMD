# Compilador HIP (AMD)
CC = hipcc

# Flags para RX 6800 (gfx1030) e RX 5500 XT (gfx1012)
ARCH_FLAGS = --amdgpu-target=gfx1012 --amdgpu-target=gfx1030

# Bibliotecas ROCm
LIBS = -lhiprtc -lrocrand -lrocblas

# Nome do executável
TARGET = kangaroo

# Arquivos fonte
SRCS = GPUEngine.cpp Kangaroo.cpp
OBJS = $(SRCS:.cpp=.o)

# Flags
CFLAGS = -O3 -Wall $(ARCH_FLAGS) -DUSE_CUDA=0 -DUSE_HIP=1

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
