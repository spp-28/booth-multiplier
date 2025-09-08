// File: project.v
// Multi-cycle Booth Multiplier for TinyTapeout

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Multiplicand
    input  wire [7:0] uio_in,   // Multiplier
    input  wire       clk,       // Clock
    input  wire       rst_n,     // Active-low reset
    input  wire       ena,       // Enable (can ignore if always 1)
    output reg  [7:0] uo_out,   // Output (LSB of product)
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
);

    // unused IOs
    assign uio_out = 0;
    assign uio_oe  = 0;

    // Internal registers
    reg [15:0] A;        // Accumulator + product
    reg [7:0] Q;         // Multiplier
    reg Q_1;             // Q-1 for Booth
    reg [3:0] count;     // Iteration counter
    reg [7:0] M;         // Multiplicand
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A     <= 0;
            Q     <= 0;
            Q_1   <= 0;
            M     <= 0;
            count <= 0;
            uo_out<= 0;
            busy  <= 0;
        end else if (ena) begin
            if (!busy) begin
                // Load operands and start multiplication
                A     <= 0;
                Q     <= uio_in;  // Multiplier
                M     <= ui_in;   // Multiplicand
                Q_1   <= 0;
                count <= 8;       // 8 iterations for 8-bit
                busy  <= 1;
            end else if (count > 0) begin
                // Booth algorithm
                case ({Q[0], Q_1})
                    2'b01: A <= A + {8'b0, M};   // A = A + M
                    2'b10: A <= A - {8'b0, M};   // A = A - M
                endcase
                // Arithmetic right shift {A, Q, Q_1}
                {A, Q, Q_1} <= {A[15], A, Q} >>> 1;
                count <= count - 1;
            end else begin
                // Multiplication done
                uo_out <= Q;  // LSB 8-bit of the product
                busy   <= 0;
            end
        end
    end

endmodule
