<!---
This file is used to generate your project datasheet.
-->

## How it works

This project implements an 8-bit **multi-cycle Booth multiplier**:
- Inputs: `ui[7:0]` for multiplicand, `uio[7:0]` for multiplier
- Output: `uo[7:0]` provides the 8-bit **least significant bits** of the product
- The multiplier works over multiple clock cycles (typically 8 cycles for an 8-bit multiplier)
- Control signals:
  - `rst_n` : active-low reset
  - `ena`   : enable signal for starting multiplication
  - `clk`   : system clock

## How to test

1. Connect the input pins to switches or testbench signals.
2. Apply a clock (`clk`) and reset (`rst_n`) to initialize.
3. Set `ena` high to start multiplication.
4. Wait **8–10 clock cycles** for the output to stabilize.
5. Read `uo[7:0]` to get the multiplication result (LSBs).

**Using Cocotb testbench:**
```bash
cd test
make
