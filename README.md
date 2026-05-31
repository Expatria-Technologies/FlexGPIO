![Expatria Technologies Logo](readme_images/logo_sm.jpg)

# FlexGPIO I2C Expander

Firmware for the **FlexGPIO** — a custom I2C GPIO expander built on a dedicated **RP2040** microcontroller. FlexGPIO is designed to dramatically expand the I/O capabilities of CNC motion control boards (such as the [FlexiHAL 2350](https://github.com/Expatria-Technologies/FlexiHAL_2350)) far beyond what traditional fixed-function GPIO expander ICs can offer.

> **Status:** Pre-release / active development. See [Releases](https://github.com/Expatria-Technologies/FlexGPIO/releases) for the latest pre-built firmware.


---

## Overview

Traditional GPIO expander ICs (e.g. MCP23017) provide a fixed set of general-purpose digital I/O pins over I2C. FlexGPIO takes a different approach: by running firmware on a full RP2040 MCU, each "expanded" I/O point can be reconfigured in software to serve almost any function — standard digital I/O, PWM, analog output, NeoPixel data, or even additional step/direction stepper outputs.

FlexGPIO communicates with the host board (e.g. the FlexiHAL 2350's RP2350 main processor) over I2C and serves as a satellite co-processor for auxiliary I/O.

---

## Features

- **I2C peripheral interface** — communicates with the host motion controller over a standard I2C bus
- **Software-defined I/O** — each pin's function is determined by firmware, not fixed silicon
- **Extensible architecture** — the codebase is designed to be extended with new I/O modes:
  - Additional digital inputs and outputs
  - Analog / PWM outputs
  - NeoPixel / addressable LED outputs
  - Additional step/direction stepper motor outputs
- **UF2 bootloader support** — firmware updates are as simple as copying a `.uf2` file to a USB drive; no programmer required
- **PlatformIO-based build** — straightforward to compile and customise using the Arduino framework and the Earle Philhower RP2040 core
- **grblHAL integration** — works alongside the [plugin_FlexGPIO](https://github.com/Expatria-Technologies/plugin_FlexGPIO) grblHAL plugin for seamless CNC I/O expansion

---

## Hardware

FlexGPIO targets a generic RP2040 board and is primarily intended for use as the secondary MCU on the **FlexiHAL 2350** CNC controller. On that board, an RP2040 sits alongside the main RP2350 processor solely to provide the expanded I/O subsystem.

The firmware is compiled for the RP2040 using the Arduino framework via PlatformIO if running from flash.

If using the FlexGPIO Bootloader to load the firmware to RAM from the RP2350, it is built with cmake. This was needed to handle the complexities of initialization of bootloader and firmware in RAM.

---

## Building the Firmware

There are currently two build mechanisms, depending on how the firmware is being run. This may eventually converge on one, but both are kept to maintain compatbility with the GRBLHAL plugin under development. 

### Firmware Running from Flash

#### Prerequisites

- [PlatformIO](https://platformio.org/) (CLI or the VS Code extension)

#### Steps

```bash
# Clone the repository
git clone https://github.com/Expatria-Technologies/FlexGPIO.git
cd FlexGPIO

# Build
pio run

# Build and upload via SWD/CMSIS-DAP
pio run --target upload
```

The compiled `.uf2` artifact will be found in `.pio/build/pico/`.


### Firmare Running from RAM with the FlexGPIO Bootloader

#### Prerequisites

- [pico-sdk](https://github.com/raspberrypi/pico-sdk) and `PICO_SDK_PATH` environment varianble set to install path
- CMake ≥ 3.13
- RP2040 flashed with [FlexGPIO Bootloader](https://github.com/Expatria-Technologies/FlexGPIO_Bootloader)


#### Steps

```bash
# Clone the repository
git clone https://github.com/Expatria-Technologies/FlexGPIO.git
cd FlexGPIO

# Build
mkdir -p build && cd build
cmake -DPICO_SDK_PATH=$PICO_SDK_PATH ..
make FlexGPIO_ram
```
The compiled `.bin` artifact will be found in: `build/`

---

## Flashing the Firmware

> **Note:** If using the FlexGPIO Bootloader, there is nothing to flash; the firmware is embedded in the RP2350 firmware on the main MCU. This section does not apply in this case.

FlexGPIO supports the RP2040's built-in **UF2 bootloader**, making firmware updates easy without any special tools:

1. Enter bootloader mode by holding the **BOOT** button on the FlexGPIO RP2040 while powering up the board, or while pulsing the **RUN** button.
2. The board will enumerate as a USB mass-storage device named **`RPI-RP2`**.
3. Copy the `.uf2` firmware file to the `RPI-RP2` drive.
4. The board will automatically install the firmware and reboot.

> **Note:** Some operating systems may show an error when the copy completes because the "disk" disappears without being ejected. This is expected behaviour and can be safely ignored.


---

## Related Repositories

| Repository | Description |
|---|---|
| [FlexiHAL 2350](https://github.com/Expatria-Technologies/FlexiHAL_2350) | The CNC controller board that hosts the FlexGPIO expander |
| [plugin_FlexGPIO](https://github.com/Expatria-Technologies/plugin_FlexGPIO) | grblHAL plugin that communicates with FlexGPIO over I2C |
| [FlexGPIO_Bootloader](https://github.com/Expatria-Technologies/FlexGPIO_Bootloader) | Bootloader that allows loading FlexGPIO to RAM at startup |

---

## Contributing

Contributions are welcome! If you'd like to add a new I/O mode, fix a bug, or improve documentation, please open an issue or pull request.

The best way to support Expatria's open-source hardware designs is through the [Expatria web shop](https://expatria.myshopify.com/).

---

## License

FlexGPIO is released under the [MIT License](LICENSE).

---

*Canadian-designed open source hardware — for everyone.*
