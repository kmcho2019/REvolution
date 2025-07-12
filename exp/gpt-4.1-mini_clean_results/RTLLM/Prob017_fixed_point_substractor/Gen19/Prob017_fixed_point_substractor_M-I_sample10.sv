`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign bit, default value provided
    parameter integer Q = 8    // Fractional bits, default value provided
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point inputs
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c   // Signed fixed-point output registered as requested
);

    reg signed [N-1:0] res;

    always @* begin
        // Perform subtraction as signed values
        res = a - b;

        // Handle zero: if result is zero, clear sign bit (MSB) explicitly
        if (res == {N{1'b0}}) begin
            c = {1'b0, res[N-2:0]};
        end else begin
            c = res;
        end
    end

endmodule