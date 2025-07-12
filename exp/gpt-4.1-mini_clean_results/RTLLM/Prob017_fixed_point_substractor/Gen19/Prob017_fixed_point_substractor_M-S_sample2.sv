`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits (unused directly in logic but parameterized)
)(
    input  wire signed [N-1:0] a,   // Fixed-point input operand (two's complement signed)
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c    // Fixed-point output operand
);

    // Perform subtraction using signed arithmetic
    wire signed [N-1:0] sub_res = a - b;

    always @(*) begin
        if (sub_res == 0)
            c = {1'b0, sub_res[N-2:0]}; // force sign bit 0 when result is zero
        else
            c = sub_res;
    end

endmodule