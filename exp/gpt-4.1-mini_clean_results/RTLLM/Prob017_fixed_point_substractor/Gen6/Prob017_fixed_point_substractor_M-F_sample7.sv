`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total number of bits (integer + fractional)
    parameter integer Q = 8    // Number of fractional bits
)(
    input  wire signed [N-1:0] a,  // Fixed-point signed input a
    input  wire signed [N-1:0] b,  // Fixed-point signed input b
    output reg  signed [N-1:0] c   // Fixed-point signed output c = a - b
);

    always @* begin
        c = a - b;
        // Explicitly clear sign bit when result is zero (redundant but explicit)
        if (c == 0)
            c = {N{1'b0}};
    end

endmodule