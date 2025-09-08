# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start cocotb testbench for Booth multiplier")

    # Clock generation: 100 kHz -> 10 us period
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut._log.info("Reset released")

    # ----------- Test cases -------------
    test_vectors = [
        (10,  3,  30),   # 10 * 3 = 30
        (20,  2,  40),   # 20 * 2 = 40
        (15, -2, -30),   # signed multiply
        (-8, -5,  40),   # signed multiply
        (7,   0,   0),   # anything * 0 = 0
    ]

    for multiplicand, multiplier, expected in test_vectors:
        dut.ui_in.value = multiplicand & 0xFF  # 8-bit signed input
        dut.uio_in.value = multiplier & 0xFF   # 8-bit signed input
        await ClockCycles(dut.clk, 2)

        # Read output (8-bit, lower product only)
        result = dut.uo_out.value.signed_integer

        dut._log.info(f"Inputs: {multiplicand} * {multiplier}, "
                      f"DUT Output (8-bit) = {result}, "
                      f"Expected LSBs = {expected & 0xFF}")

        # Compare only the lower 8 bits (since uo_out is 8 bits wide)
        assert result == (expected & 0xFF), \
            f"Mismatch: {multiplicand} * {multiplier}, got {result}, expected {(expected & 0xFF)}"

    dut._log.info("All test cases passed ✅")
