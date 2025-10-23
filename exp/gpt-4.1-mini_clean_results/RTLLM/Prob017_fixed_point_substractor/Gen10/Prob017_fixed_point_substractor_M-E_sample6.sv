`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,   // Total bits including sign bit
    parameter integer Q = 8     // Number of fractional bits (not used explicitly here, but relevant for users)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed representations of inputs and result
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    reg signed [N-1:0] res;

    always @(*) begin
        // Perform two's complement subtraction directly
        res = a_signed - b_signed;

        // If result is zero, explicitly clear the sign bit
        if (res == 0) begin
            c = {1'b0, {(N-1){1'b0}}};  // zero with positive sign bit
        end else begin
            c = res;
        end
    end

endmodule