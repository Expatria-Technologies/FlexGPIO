![Expatria Technologies Logo](readme_images/logo_sm.jpg)

# FlexGPIO I2C Expander

Firmware for the **FlexGPIO** — a custom I2C GPIO expander built on a dedicated **RP2040** microcontroller. FlexGPIO is designed to dramatically expand the I/O capabilities of CNC motion control boards (such as the [FlexiHAL 2350](https://github.com/Expatria-Technologies/FlexiHAL_2350)) far beyond what traditional fixed-function GPIO expander ICs can offer.

> **Status:** Pre-release / active development. See [Releases](https://github.com/Expatria-Technologies/FlexGPIO/releases) for the latest pre-built firmware.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Hardware](#hardware)
- [Building the Firmware](#building-the-firmware)
- [Flashing the Firmware](#flashing-the-firmware)
- [Related Repositories](#related-repositories)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Traditional GPIO expander ICs (e.g. MCP23017) provide a fixed set of general-purpose digital I/O pins over I2C. FlexGPIO takes a different approach: by running firmware on a full RP2040 MCU, each "expanded" I/O point can be reconfigured in software to serve almost any function — standard digital I/O, PWM, analog output, NeoPixel data, or even additional step/direction stepper outputs.

FlexGPIO communicates with the host board (e.g. the FlexiHAL 2350's RP2350 main processor) over I2C and serves as a satellite co-processor for all auxiliary I/O needs.

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

The firmware is compiled for the RP2040 running at **120 MHz** using the Arduino framework via PlatformIO.

Key `platformio.ini` settings:

```ini
[env:pico]
platform   = https://github.com/maxgerhardt/platform-raspberrypi.git
board      = generic
framework  = arduino
board_build.core         = earlephilhower
board_build.filesystem_size = 1m
board_build.f_cpu        = 120000000L
upload_protocol          = cmsis-dap
debug_tool               = cmsis-dap
```

---

## Building the Firmware

### Prerequisites

- [PlatformIO](https://platformio.org/) (CLI or the VS Code extension)
- A CMSIS-DAP compatible debug probe (for SWD flashing during development)

### Steps

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

---

## Flashing the Firmware

FlexGPIO supports the RP2040's built-in **UF2 bootloader**, making firmware updates easy without any special tools:

1. Enter bootloader mode by holding the **BOOT** button on the FlexGPIO RP2040 while powering up the board, or while pulsing the **RUN** button.
2. The board will enumerate as a USB mass-storage device named **`RPI-RP2`**.
3. Copy the `.uf2` firmware file to the `RPI-RP2` drive.
4. The board will automatically install the firmware and reboot.

> **Note:** Some operating systems may show an error when the copy completes because the "disk" disappears without being ejected. This is expected behaviour and can be safely ignored.

Pre-built `.uf2` binaries are available on the [Releases page](https://github.com/Expatria-Technologies/FlexGPIO/releases).

---

## Related Repositories

| Repository | Description |
|---|---|
| [FlexiHAL 2350](https://github.com/Expatria-Technologies/FlexiHAL_2350) | The CNC controller board that hosts the FlexGPIO expander |
| [plugin_FlexGPIO](https://github.com/Expatria-Technologies/plugin_FlexGPIO) | grblHAL plugin that communicates with FlexGPIO over I2C |
| [Flexi-HAL](https://github.com/Expatria-Technologies/Flexi-HAL) | Previous-generation Expatria CNC controller |
| [remora-flexi-hal](https://github.com/Expatria-Technologies/remora-flexi-hal) | LinuxCNC Remora port for the Flexi-HAL family |

---

## Contributing

Contributions are welcome! If you'd like to add a new I/O mode, fix a bug, or improve documentation, please open an issue or pull request.

The best way to support Expatria's open-source hardware designs is through the [Expatria web shop](https://expatria.myshopify.com/).

---

## License

FlexGPIO is released under the [MIT License](LICENSE).

---

*Canadian-designed open source hardware — for everyone.*
