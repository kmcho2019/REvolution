`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,   // fixed-point two's complement input
    input  wire [N-1:0] b,   // fixed-point two's complement input
    output reg  [N-1:0] c    // fixed-point two's complement output
);

    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] res_signed = a_signed - b_signed;

    // Check for zero result
    wire is_zero = (res_signed == 0);

    always @(*) begin
        if (is_zero) begin
            c = {1'b0, {(N-1){1'b0}}}; // Explicitly clear sign bit when result is zero
        end else begin
            c = res_signed;
        end
    end

endmodule