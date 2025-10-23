`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total bits (including sign)
    parameter integer Q = 8         // Fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c           // Result: a - b (two's complement)
);

    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    reg  signed [N-1:0] res_signed;

    always @* begin
        res_signed = a_signed - b_signed;
        if (res_signed == 0)
            c = {1'b0, {(N-1){1'b0}}}; // zero with sign bit cleared
        else
            c = res_signed;
    end

endmodule