`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign bit
    parameter integer Q = 8    // Fractional bits (for documentation)
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c   // Signed fixed-point output
);

    // Combinational signed subtraction; two's complement handles all cases
    assign c = a - b;

endmodule