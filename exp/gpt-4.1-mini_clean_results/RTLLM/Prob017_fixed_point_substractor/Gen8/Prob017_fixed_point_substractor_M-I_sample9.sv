`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (integer + fractional)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Perform signed subtraction
    wire signed [N-1:0] res = a - b;

    // Clear sign bit explicitly when result is zero
    // If res == 0, output zero (sign bit forced to 0)
    assign c = (res == 0) ? {N{1'b0}} : res;

endmodule