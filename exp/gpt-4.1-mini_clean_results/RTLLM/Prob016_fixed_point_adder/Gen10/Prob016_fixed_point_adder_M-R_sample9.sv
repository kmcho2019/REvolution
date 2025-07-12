module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,        // First fixed-point operand
    input  wire [N-1:0] b,        // Second fixed-point operand
    output wire [N-1:0] c         // Result of fixed-point addition
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function: absolute value (two's complement)
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    // Compute absolute values
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Compute addition and subtraction with one extra bit
    wire [N:0] sum_abs    = {1'b0, a_abs} + {1'b0, b_abs};
    wire [N:0] diff_abs_a_b = {1'b0, a_abs} - {1'b0, b_abs};
    wire [N:0] diff_abs_b_a = {1'b0, b_abs} - {1'b0, a_abs};

    // Output combinational logic assignment:
    // Case 1: same sign -> result sign = input sign, sum absolute values (truncate overflow)
    // Case 2: different sign -> subtract smaller abs from larger abs,
    //         sign depends on operand with larger absolute value.
    //         If result zero, sign bit is 0 (positive).
    //
    // Note: For subtraction results, set MSB (sign bit) explicitly according to problem:
    //   - If a_abs >= b_abs and signs differ: sign bit = 0 (positive)
    //   - If b_abs > a_abs and signs differ: sign bit = b_sign (which may be 1 or 0)
    //
    // Truncate sum or difference from N+1 bits back to N bits, then set MSB (sign bit) explicitly.

    wire [N-1:0] sum_trunc    = sum_abs[N-1:0];
    wire [N-1:0] diff_a_b_trunc = diff_abs_a_b[N-1:0];
    wire [N-1:0] diff_b_a_trunc = diff_abs_b_a[N-1:0];

    wire [N-1:0] result_same_sign = {a_sign, sum_trunc[N-2:0]}; // sign bit + magnitude bits
    wire [N-1:0] result_diff_sign_a_ge_b = (diff_a_b_trunc == 0) ? {N{1'b0}} : {1'b0, diff_a_b_trunc[N-2:0]};
    wire [N-1:0] result_diff_sign_b_gt_a = (diff_b_a_trunc == 0) ? {N{1'b0}} : {b_sign, diff_b_a_trunc[N-2:0]};

    assign c = (a_sign == b_sign) ? 
                result_same_sign :
                (a_abs_ge_b_abs ? 
                    result_diff_sign_a_ge_b :
                    result_diff_sign_b_gt_a
                );

endmodule