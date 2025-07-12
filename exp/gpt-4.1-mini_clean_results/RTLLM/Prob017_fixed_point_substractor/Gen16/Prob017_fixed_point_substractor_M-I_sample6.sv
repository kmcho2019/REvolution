`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign
    parameter integer Q = 8    // fractional bits
)(
    input  wire signed [N-1:0] a,  // fixed-point two's complement input
    input  wire signed [N-1:0] b,  // fixed-point two's complement input
    output reg  signed [N-1:0] c   // fixed-point two's complement output
);

    wire signed [N-1:0] res = a - b;

    always @(*) begin
        if (res == 0)
            c = {1'b0, {(N-1){1'b0}}}; // explicitly clear sign bit on zero result
        else
            c = res;
    end

endmodule