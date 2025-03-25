#---------------------------------------------------------------------
# Makefile for Kangaroo (AMD ROCm/HIP version)
#---------------------------------------------------------------------

# Configurações básicas
SRC_DIR = .
OBJDIR = obj
TARGET = kangaroo

# Arquivos fonte comuns
COMMON_SRC = SECPK1/IntGroup.cpp main.cpp SECPK1/Random.cpp \
             Timer.cpp SECPK1/Int.cpp SECPK1/IntMod.cpp \
             SECPK1/Point.cpp SECPK1/SECP256K1.cpp \
             Kangaroo.cpp HashTable.cpp Thread.cpp Check.cpp \
             Backup.cpp Network.cpp Merge.cpp PartMerge.cpp

# Configurações específicas para GPU
ifdef gpu
    SRC = $(COMMON_SRC) GPU/GPUEngine.cpp
    OBJET = $(addprefix $(OBJDIR)/, $(SRC:.cpp=.o))
    HIPCC = hipcc
    HIPFLAGS = --amdgpu-target=gfx1030 --amdgpu-target=gfx1012 # RX 6800 e RX 5500 XT
else
    SRC = $(COMMON_SRC)
    OBJET = $(addprefix $(OBJDIR)/, $(SRC:.cpp=.o))
endif

# Compilador e flags
CXX = g++
CXXFLAGS = -m64 -mssse3 -Wno-unused-result -Wno-write-strings -I$(SRC_DIR)
LFLAGS = -lpthread

ifdef gpu
    CXXFLAGS += -DWITHGPU -DUSE_HIP
    LFLAGS += -lhiprtc -lrocblas -lrocrand
endif

ifdef debug
    CXXFLAGS += -g
else
    CXXFLAGS += -O3
endif

#---------------------------------------------------------------------
# Regras de compilação
#---------------------------------------------------------------------

all: $(TARGET)

$(TARGET): $(OBJET)
	@echo "Linking..."
	$(CXX) $(OBJET) $(LFLAGS) -o $@

# Regra para arquivos HIP
ifdef gpu
$(OBJDIR)/GPU/GPUEngine.o: GPU/GPUEngine.cpp
	@mkdir -p $(@D)
	$(HIPCC) $(HIPFLAGS) $(CXXFLAGS) -c $< -o $@
endif

# Regra para arquivos CPP
$(OBJDIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Criação da estrutura de diretórios
$(OBJET): | $(OBJDIR) $(OBJDIR)/SECPK1 $(OBJDIR)/GPU

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/SECPK1:
	mkdir -p $(OBJDIR)/SECPK1

$(OBJDIR)/GPU:
	mkdir -p $(OBJDIR)/GPU

clean:
	@echo "Cleaning..."
	rm -rf $(OBJDIR) $(TARGET)

.PHONY: all clean
