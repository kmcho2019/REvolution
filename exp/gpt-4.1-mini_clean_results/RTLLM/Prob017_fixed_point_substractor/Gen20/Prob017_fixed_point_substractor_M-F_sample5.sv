`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (integer + fractional)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Intermediate subtraction result
    wire signed [N-1:0] res;
    assign res = a - b;

    // If result is zero, force sign bit (MSB) to zero explicitly
    // Otherwise, pass result unchanged
    assign c = (res == 0) ? {1'b0, {(N-1){1'b0}}} : res;

endmodule

/*
Example instantiation showing parameter override syntax:

fixed_point_subtractor #(
    .N(20),
    .Q(10)
) u_fixed_point_subtractor (
    .a(a_signal),
    .b(b_signal),
    .c(c_signal)
);

Make sure your testbench or top-level module passes the parameters N and Q
using the above parameter override syntax to avoid elaboration errors.
*/