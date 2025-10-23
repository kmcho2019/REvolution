`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (integer + fractional)
    parameter integer Q = 8    // Number of fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    reg signed [N-1:0] res;

    always @* begin
        res = a - b;
        // Handle zero result explicitly by clearing sign bit and all bits
        if (res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end
        c = res;
    end

endmodule