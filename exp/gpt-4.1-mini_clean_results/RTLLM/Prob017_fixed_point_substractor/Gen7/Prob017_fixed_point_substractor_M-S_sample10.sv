`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign bit)
    parameter integer Q = 8    // Fractional bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

    wire signed [N-1:0] diff = a - b;
    assign c = (diff == 0) ? 0 : diff;

endmodule