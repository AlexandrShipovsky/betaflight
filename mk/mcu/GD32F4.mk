#
# F4 Make file include
#

#CMSIS
ifeq ($(PERIPH_DRIVER), HAL)
CMSIS_DIR      := $(ROOT)/lib/main/STM32F4/Drivers/CMSIS
STDPERIPH_DIR   = $(ROOT)/lib/main/STM32F4/Drivers/STM32F4xx_HAL_Driver
STDPERIPH_SRC   = $(notdir $(wildcard $(STDPERIPH_DIR)/Src/*.c))
EXCLUDES        =

VPATH       := $(VPATH):$(STDPERIPH_DIR)/Src

else
CMSIS_DIR      := $(ROOT)/lib/main/CMSIS
STDPERIPH_DIR   = $(ROOT)/lib/main/STM32F4/Drivers/STM32F4xx_StdPeriph_Driver
STDPERIPH_SRC   = $(notdir $(wildcard $(STDPERIPH_DIR)/src/*.c))
EXCLUDES        = stm32f4xx_crc.c \
                  stm32f4xx_can.c \
                  stm32f4xx_fmc.c \
                  stm32f4xx_sai.c \
                  stm32f4xx_cec.c \
                  stm32f4xx_dsi.c \
                  stm32f4xx_flash_ramfunc.c \
                  stm32f4xx_fmpi2c.c \
                  stm32f4xx_lptim.c \
                  stm32f4xx_qspi.c \
                  stm32f4xx_spdifrx.c \
                  stm32f4xx_cryp.c \
                  stm32f4xx_cryp_aes.c \
                  stm32f4xx_hash_md5.c \
                  stm32f4xx_cryp_des.c \
                  stm32f4xx_hash.c \
                  stm32f4xx_dbgmcu.c \
                  stm32f4xx_cryp_tdes.c \
                  stm32f4xx_hash_sha1.c

VPATH       := $(VPATH):$(STDPERIPH_DIR)/src
endif

ifeq ($(TARGET_MCU),$(filter $(TARGET_MCU),GD32F427xx))
EXCLUDES        += stm32f4xx_fsmc.c
endif

STDPERIPH_SRC   := $(filter-out ${EXCLUDES}, $(STDPERIPH_SRC))

ifeq ($(PERIPH_DRIVER), HAL)
#USB
USBCORE_DIR = $(ROOT)/lib/main/STM32F4/Middlewares/ST/STM32_USB_Device_Library/Core
USBCORE_SRC = $(notdir $(wildcard $(USBCORE_DIR)/Src/*.c))
EXCLUDES    = usbd_conf_template.c
USBCORE_SRC := $(filter-out ${EXCLUDES}, $(USBCORE_SRC))

USBCDC_DIR = $(ROOT)/lib/main/STM32F4/Middlewares/ST/STM32_USB_Device_Library/Class/CDC
USBCDC_SRC = $(notdir $(wildcard $(USBCDC_DIR)/Src/*.c))
EXCLUDES   = usbd_cdc_if_template.c
USBCDC_SRC := $(filter-out ${EXCLUDES}, $(USBCDC_SRC))

VPATH := $(VPATH):$(USBCDC_DIR)/Src:$(USBCORE_DIR)/Src

DEVICE_STDPERIPH_SRC := $(STDPERIPH_SRC) \
                        $(USBCORE_SRC) \
                        $(USBCDC_SRC)
else
USBDRV_DIR = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/driver
USBDRV_SRC = $(notdir $(wildcard $(USBDRV_DIR)/Source/*.c))

USBCORE_DIR = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/device/core
USBCORE_SRC = $(notdir $(wildcard $(USBCORE_DIR)/Source/*.c))

USBCORESTM32_DIR = $(ROOT)/lib/main/STM32_USB_Device_Library/Core
USBCORESTM32_SRC = $(notdir $(wildcard $(USBCORE_DIR)/src/*.c))

USTD_DIR = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/ustd

USBCDC_DIR  = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/device/class/cdc
USBCDC_SRC  = $(notdir $(wildcard $(USBCDC_DIR)/Source/*.c))
EXCLUDES    = usbd_cdc_if_template.c
USBCDC_SRC  := $(filter-out ${EXCLUDES}, $(USBCDC_SRC))
USBMSC_DIR  = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/device/class/msc
USBMSC_SRC  = $(notdir $(wildcard $(USBMSC_DIR)/Source/*.c))
EXCLUDES    = usbd_storage_template.c
USBMSC_SRC  := $(filter-out ${EXCLUDES}, $(USBMSC_SRC))
USBHID_DIR  = $(ROOT)/lib/main/GD32F4/GD32F4xx_usb_library/device/class/hid
USBHID_SRC  = $(notdir $(wildcard $(USBHID_DIR)/Source/*.c))
VPATH       := $(VPATH):$(USBCORE_DIR)/src:$(USBDRV_DIR)/src:$(USBCDC_DIR)/src:$(USBMSC_DIR)/src:$(USBHID_DIR)/src:$(USBCORESTM32_DIR)/src

DEVICE_STDPERIPH_SRC := $(STDPERIPH_SRC) \
						$(USBDRV_SRC) \
                        $(USBCORE_SRC) \
                        $(USBCORESTM32_DIR) \
                        $(USBCDC_SRC) \
                        $(USBHID_SRC) \
                        $(USBMSC_SRC)

endif

#CMSIS
VPATH           := $(VPATH):$(CMSIS_DIR)/Core/Include:$(ROOT)/lib/main/STM32F4/Drivers/CMSIS/Device/ST/STM32F4xx

INCLUDE_DIRS    := $(INCLUDE_DIRS) \
                   $(ROOT)/src/main/drivers/gd32

ifeq ($(PERIPH_DRIVER), HAL)
CMSIS_SRC       :=
INCLUDE_DIRS    := $(INCLUDE_DIRS) \
                   $(STDPERIPH_DIR)/Inc \
                   $(USBCORE_DIR)/Inc \
                   $(USBCDC_DIR)/Inc \
                   $(CMSIS_DIR)/Include \
                   $(CMSIS_DIR)/Device/ST/STM32F4xx/Include \
                   $(ROOT)/src/main/drivers/gd32/vcp_hal
else
CMSIS_SRC       := $(notdir $(wildcard $(CMSIS_DIR)/CoreSupport/*.c \
                   $(ROOT)/lib/main/STM32F4/Drivers/CMSIS/Device/ST/STM32F4xx/*.c))
INCLUDE_DIRS    := $(INCLUDE_DIRS) \
                   $(STDPERIPH_DIR)/inc \
                   $(USBDRV_DIR)/Include \
                   $(USBCORE_DIR)/Include \
                   $(USBCORESTM32_DIR)/inc \
                   $(USTD_DIR)/class/cdc \
                   $(USTD_DIR)/class/msc \
                   $(USTD_DIR)/common \
                   $(USBCDC_DIR)/Include \
                   $(USBHID_DIR)/Include \
                   $(USBMSC_DIR)/Include \
                   $(CMSIS_DIR)/Core/Include \
                   $(ROOT)/lib/main/STM32F4/Drivers/CMSIS/Device/ST/STM32F4xx \
                   $(ROOT)/src/main/drivers/gd32/vcpf4
endif

#Flags
ARCH_FLAGS      = -mthumb -mcpu=cortex-m4 -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant

ifeq ($(TARGET_MCU),GD32F405xx)
DEVICE_FLAGS    = -DSTM32F40_41xxx -DSTM32F405xx
LD_SCRIPT       = $(LINKER_DIR)/stm32_flash_f405.ld
STARTUP_SRC     = startup_stm32f40xx.s
MCU_FLASH_SIZE  := 1024

else ifeq ($(TARGET_MCU),GD32F427xx)
DEVICE_FLAGS    = -DSTM32F427_437xx
LD_SCRIPT       = $(LINKER_DIR)/stm32_flash_f427xg.ld
STARTUP_SRC     = startup_stm32f427xx.s
MCU_FLASH_SIZE  := 1024

else
$(error Unknown MCU for F4 target)
endif
DEVICE_FLAGS    += -DHSE_VALUE=$(HSE_VALUE) -DSTM32

MCU_COMMON_SRC = \
            drivers/accgyro/accgyro_mpu.c \
            drivers/dshot_bitbang_decode.c \
            drivers/inverter.c \
            drivers/pwm_output_dshot_shared.c \
            drivers/gd32/pwm_output_dshot.c \
            drivers/gd32/adc_stm32f4xx.c \
            drivers/gd32/bus_i2c_stm32f4xx.c \
            drivers/gd32/bus_spi_stdperiph.c \
            drivers/gd32/debug.c \
            drivers/gd32/dma_reqmap_mcu.c \
            drivers/gd32/dma_stm32f4xx.c \
            drivers/gd32/dshot_bitbang.c \
            drivers/gd32/dshot_bitbang_stdperiph.c \
            drivers/gd32/exti.c \
            drivers/gd32/io_stm32.c \
            drivers/gd32/light_ws2811strip_stdperiph.c \
            drivers/gd32/persistent.c \
            drivers/gd32/pwm_output.c \
            drivers/gd32/rcc_stm32.c \
            drivers/gd32/sdio_f4xx.c \
            drivers/gd32/serial_uart_stdperiph.c \
            drivers/gd32/serial_uart_stm32f4xx.c \
            drivers/gd32/system_stm32f4xx.c \
            drivers/gd32/timer_stdperiph.c \
            drivers/gd32/timer_stm32f4xx.c \
            drivers/gd32/transponder_ir_io_stdperiph.c \
            drivers/gd32/usbd_msc_desc.c \
            drivers/gd32/camera_control.c \
            startup/system_stm32f4xx.c

ifeq ($(PERIPH_DRIVER), HAL)
VCP_SRC = \
            drivers/gd32/vcp_hal/usbd_desc.c \
            drivers/gd32/vcp_hal/usbd_conf.c \
            drivers/gd32/vcp_hal/usbd_cdc_interface.c \
            drivers/gd32/serial_usb_vcp.c \
            drivers/usb_io.c
else
VCP_SRC = \
            drivers/gd32/vcpf4/stm32f4xx_it.c \
            drivers/gd32/vcpf4/usb_bsp.c \
            drivers/gd32/vcpf4/usbd_desc.c \
            drivers/gd32/vcpf4/usbd_usr.c \
            drivers/gd32/vcpf4/usbd_cdc_vcp.c \
            drivers/gd32/vcpf4/usb_cdc_hid.c \
            drivers/gd32/serial_usb_vcp.c \
            drivers/usb_io.c
endif

MSC_SRC = \
            drivers/usb_msc_common.c \
            drivers/gd32/usb_msc_f4xx.c \
            msc/usbd_storage.c \
            msc/usbd_storage_emfat.c \
            msc/emfat.c \
            msc/emfat_file.c \
            msc/usbd_storage_sd_spi.c \
            msc/usbd_storage_sdio.c

DSP_LIB := $(ROOT)/lib/main/CMSIS/DSP
DEVICE_FLAGS += -DARM_MATH_MATRIX_CHECK -DARM_MATH_ROUNDING -D__FPU_PRESENT=1 -DUNALIGNED_SUPPORT_DISABLE -DARM_MATH_CM4
