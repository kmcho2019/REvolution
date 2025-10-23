`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,
    parameter integer Q = 8
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    wire signed [N-1:0] res = a - b;

    assign c = (res == 0) ? {1'b0, {(N-1){1'b0}}} : res;

endmodule