`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input a
    input  wire signed [N-1:0] b,  // Signed fixed-point input b
    output reg  signed [N-1:0] c   // Signed fixed-point output c = a - b
);

    reg signed [N-1:0] res;

    always @* begin
        // Perform fixed-point subtraction
        res = a - b;

        // Handle zero result by explicitly assigning zero (sign bit cleared naturally)
        if (res == 0) begin
            res = {N{1'b0}};
        end
    end

    always @* begin
        c = res;
    end

endmodule