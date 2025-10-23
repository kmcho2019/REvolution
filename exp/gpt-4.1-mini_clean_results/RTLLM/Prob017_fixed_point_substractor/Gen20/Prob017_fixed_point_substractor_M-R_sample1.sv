`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input operand
    input  wire signed [N-1:0] b,  // Signed fixed-point input operand
    output wire signed [N-1:0] c   // Signed fixed-point subtraction result
);

    // Perform subtraction with sign bit cleared if result is zero
    wire signed [N-1:0] sub_result = a - b;

    assign c = (sub_result == 0) ? {1'b0, {(N-1){1'b0}}} : sub_result;

endmodule