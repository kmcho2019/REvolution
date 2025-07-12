`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total number of bits (including sign) (default 16)
    parameter integer Q = 8         // Number of fractional bits (default 8)
)(
    input  wire [N-1:0] a,          // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point subtraction result (two's complement)
);

    // Internal signed representations for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    reg signed [N-1:0]  res_signed;

    always @* begin
        // Perform subtraction directly as signed numbers
        res_signed = a_signed - b_signed;

        // Explicit zero check: if result is zero, clear sign bit
        if (res_signed == 0) begin
            c = {1'b0, {(N-1){1'b0}}}; // force sign bit zero for zero result
        end else begin
            c = res_signed;
        end
    end

endmodule

/*
Example instantiation with explicit parameters in a testbench:

fixed_point_subtractor #(
    .N(16),
    .Q(8)
) uut (
    .a(a_signal),
    .b(b_signal),
    .c(result_signal)
);

Ensure testbench passes parameters N and Q consistently with the module definition.
*/