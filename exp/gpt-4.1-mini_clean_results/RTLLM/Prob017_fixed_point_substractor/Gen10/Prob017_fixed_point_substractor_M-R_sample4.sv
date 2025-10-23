`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,   // Total bits (including sign)
    parameter integer Q = 8     // Fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform subtraction
    wire signed [N:0] res_ext; // one bit wider to detect overflow if needed
    assign res_ext = a_signed - b_signed;

    // Truncate result back to N bits
    wire signed [N-1:0] res_trunc = res_ext[N-1:0];

    // Handle zero result: if zero, force sign bit to zero
    wire zero_result = (res_trunc == 0);

    // Compose output with sign bit forced to zero if result is zero
    assign c = zero_result ? {1'b0, res_trunc[N-2:0]} : res_trunc;

endmodule