`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point subtraction result (two's complement)
);

    // Internal signed representation of inputs
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Signed subtraction result
    wire signed [N-1:0] res_signed = a_signed - b_signed;

    // Output with explicit zero sign bit clearing:
    // If result is zero, set sign bit to 0; otherwise output as is.
    assign c = (res_signed == 0) ? {1'b0, {(N-1){1'b0}}} : res_signed;

endmodule