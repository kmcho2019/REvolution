`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // Fixed-point input operand (two's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c     // Fixed-point output operand
);

    // Internal signals for sign and magnitude extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value (magnitude) of two's complement N-bit number
    function [N-2:0] abs_mag(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1)
                abs_mag = (~val[N-2:0] + 1'b1);
            else
                abs_mag = val[N-2:0];
        end
    endfunction

    wire [N-2:0] a_mag = abs_mag(a);
    wire [N-2:0] b_mag = abs_mag(b);

    // Result sign and magnitude registers
    reg res_sign;
    reg [N-2:0] res_mag;

    // Compare magnitudes for sign determination when different signs or subtraction
    wire a_greater_equal_b = (a_mag >= b_mag);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes, sign remains same
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = a_sign;  // same sign as inputs per spec, but magnitude swapped
            end
        end else begin
            // Different sign: add magnitudes
            reg [N-2:0] sum_mag;
            sum_mag = a_mag + b_mag;

            // Result sign depends on which magnitude is larger (apply relative magnitude to signs)
            if (a_greater_equal_b) 
                res_sign = a_sign;
            else
                res_sign = b_sign;

            res_mag = sum_mag;
        end

        // Handle zero result: if magnitude zero, force sign to zero
        if (res_mag == 0)
            res_sign = 1'b0;

        // Reconstruct result two's complement number from sign and magnitude
        if (res_sign == 1'b0) begin
            // Positive number: sign bit zero, magnitude as is
            c = {1'b0, res_mag};
        end else begin
            // Negative number: two's complement of magnitude
            c = {1'b1, (~res_mag + 1'b1)};
        end
    end

endmodule