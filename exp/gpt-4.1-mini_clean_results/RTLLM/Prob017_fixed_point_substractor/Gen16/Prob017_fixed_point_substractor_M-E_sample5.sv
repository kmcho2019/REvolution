`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total number of bits
    parameter integer Q = 8         // Number of fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input b (two's complement)
    output reg  [N-1:0] c           // Fixed-point subtraction result c = a - b
);

    // Internal signals for sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value of fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;  // two's complement to get magnitude
            else
                abs_val = val;
        end
    endfunction

    // Absolute magnitudes of inputs
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Intermediate magnitude result (absolute)
    reg [N-1:0] mag_res;
    // Sign bit of the result
    reg        res_sign;

    // Intermediate zero detection
    wire zero_mag;

    assign zero_mag = (mag_res == {N{1'b0}});

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (abs_a >= abs_b) begin
                mag_res = abs_a - abs_b;
                res_sign = a_sign; // sign same as inputs
            end else begin
                mag_res = abs_b - abs_a;
                res_sign = ~a_sign; // sign flips if abs_b > abs_a
            end
        end else begin
            // Different sign: add magnitudes
            mag_res = abs_a + abs_b;
            // Determine sign based on greater magnitude operand
            if (abs_a >= abs_b)
                res_sign = a_sign;
            else
                res_sign = b_sign;
        end

        // Handle zero result sign explicitly
        if (zero_mag)
            res_sign = 1'b0;

        // Combine sign and magnitude for output (two's complement)
        if (res_sign == 1'b0) begin
            // Positive result: just assign magnitude
            c = mag_res;
        end else begin
            // Negative result: take two's complement of magnitude
            c = (~mag_res) + 1'b1;
        end
    end

endmodule