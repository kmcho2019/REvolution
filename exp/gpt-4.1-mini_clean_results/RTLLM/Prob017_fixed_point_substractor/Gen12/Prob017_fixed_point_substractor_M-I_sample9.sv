`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,    // Input operand b (two's complement fixed-point)
    output reg  [N-1:0] c     // Output result (two's complement fixed-point)
);

    // Internal signals for sign extraction
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in) + 1;
            else
                abs_val = in;
        end
    endfunction

    // Absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Intermediate result and sign
    reg [N-1:0] res_abs;
    reg        res_sign;

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign subtraction of absolute values
            if (abs_a >= abs_b) begin
                res_abs = abs_a - abs_b;
                res_sign = sign_a; // same sign as inputs
            end else begin
                res_abs = abs_b - abs_a;
                res_sign = sign_a; // same sign as inputs (per problem statement)
                // Note: Problem states "The sign of the result will be the same as the inputs" in same sign subtraction
                // Even if abs_b > abs_a, sign remains as inputs' sign (likely negative zero or small negative)
                // So no sign inversion here
            end
        end else begin
            // Different signs: add absolute values
            res_abs = abs_a + abs_b;
            // Sign determination depends on magnitude comparison
            if (abs_a >= abs_b)
                res_sign = sign_a; // sign of operand with larger magnitude
            else
                res_sign = sign_b;
        end

        // Combine sign and magnitude into two's complement result
        if (res_abs == 0) begin
            // Handle zero: sign bit cleared
            c = {1'b0, {(N-1){1'b0}}};
        end else if (res_sign == 1'b0) begin
            // Positive result
            c = res_abs;
        end else begin
            // Negative result: two's complement of magnitude
            c = (~res_abs) + 1;
        end
    end

endmodule