`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @(*) begin
        c = a - b;
        if (c == 0)
            c = {1'b0, {(N-1){1'b0}}}; // Clear sign bit explicitly for zero
    end

endmodule