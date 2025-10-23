`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits (including sign)
    parameter integer Q = 8      // Fractional bits
)(
    input  wire signed [N-1:0] a,   // Fixed-point signed input a (two's complement)
    input  wire signed [N-1:0] b,   // Fixed-point signed input b (two's complement)
    output wire signed [N-1:0] c    // Fixed-point signed output c = a - b
);

    wire signed [N-1:0] diff = a - b;

    // Explicitly clear sign bit if result is zero
    assign c = (diff == 0) ? {N{1'b0}} : diff;

endmodule