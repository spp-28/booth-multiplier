<!---
This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an **8-bit Booth Multiplier** in Verilog.  
It takes two signed 8-bit inputs (multiplicand and multiplier) and produces the product.  

- **Inputs**:  
  - `ui_in[7:0]` → Multiplicand (signed, 2’s complement)  
  - `uio_in[7:0]` → Multiplier (signed, 2’s complement)  

- **Output**:  
  - `uo_out[7:0]` → Lower 8 bits of the signed 16-bit product  

The multiplier is based on the **Booth algorithm**, which reduces the number of partial products by encoding sequences of 1s in the multiplier.  
This improves efficiency compared to a simple shift-and-add multiplier.  

Internally:  
1. The design detects bit-pairs in the multiplier (`Y[i], Y[i-1]`) and decides whether to add, subtract, or skip the multiplicand.  
2. It shifts and accumulates partial results.  
3. The final product is 16 bits wide, but only the **lower 8 bits** are mapped to outputs (`uo_out`).  

---

## How to test

1. Provide two signed 8-bit numbers as input:  
   - Set `ui_in[7:0]` to the multiplicand  
   - Set `uio_in[7:0]` to the multiplier  

2. Observe the lower 8 bits of the product on `uo_out[7:0]`.  

Example tests:  

- **Case 1:**  
  - Multiplicand = `5` (`00000101`)  
  - Multiplier = `3` (`00000011`)  
  - Expected product = `15` (`00001111`) → `uo_out = 00001111`  

- **Case 2:**  
  - Multiplicand = `-4` (`11111100`)  
  - Multiplier = `6` (`00000110`)  
  - Expected product = `-24` (`11101000` in 16 bits) → `uo_out = 11101000`  

- **Case 3:**  
  - Multiplicand = `-7` (`11111001`)  
  - Multiplier = `-2` (`11111110`)  
  - Expected product = `14` (`00001110`) → `uo_out = 00001110`  

The testbench (`test.py`) automatically applies inputs, runs the clock, and checks expected outputs.

---

## External hardware

No external hardware is required.  
Inputs can be provided directly through the **Tiny Tapeout web interface** or FPGA dev board.  
Outputs can be viewed as LEDs or logic analyzer signals mapped to `uo_out[7:0]`.

---
