`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Number of fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    reg signed [N-1:0] res;

    always @(*) begin
        res = a - b;
    end

    assign c = res;

endmodule