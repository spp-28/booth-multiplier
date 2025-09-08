# File: test.py
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test multi-cycle Booth multiplier"""

    # Create a 10ns period clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset
    dut.rst_n.value = 0
    dut.ena.value   = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value   = 1

    # Test cases: (multiplicand, multiplier)
    test_vectors = [
        (10, 3),
        (7, 5),
        (15, 15),
        (0, 9),
        (12, 0),
        (255, 2),
    ]

    for multiplicand, multiplier in test_vectors:
        dut.ui_in.value = multiplicand
        dut.uio_in.value = multiplier

        # Wait until multiplication is done (8 cycles)
        for _ in range(10):
            await RisingEdge(dut.clk)

        # Check output (8 LSBs)
        result = dut.uo_out.value.integer
        expected = (multiplicand * multiplier) & 0xFF

        assert result == expected, \
            f"Mismatch: {multiplicand} * {multiplier}, got {result}, expected {expected}"
        dut._log.info(f"Inputs: {multiplicand} * {multiplier}, DUT Output (8-bit) = {result}, Expected LSBs = {expected}")
