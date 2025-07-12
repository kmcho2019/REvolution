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

    // Arithmetic result placeholder (N bits, no overflow bit)
    wire [N-1:0] sum_abs;      // sum of absolute values
    wire [N-1:0] diff_abs;     // difference of absolute values

    // Compute sum only if signs are equal (single addition)
    wire [N:0] sum_ext = {1'b0, a_abs} + {1'b0, b_abs}; // N+1 bits to detect overflow

    // Compute difference only if signs differ
    // subtract smaller abs from larger abs
    wire [N:0] diff_ext = a_abs_ge_b_abs ?
                         ({1'b0, a_abs} - {1'b0, b_abs}) :
                         ({1'b0, b_abs} - {1'b0, a_abs});

    // Truncate sum and diff to N bits (dropping overflow)
    assign sum_abs = sum_ext[N-1:0];
    assign diff_abs = diff_ext[N-1:0];

    // Compose output according to conditions:

    // When signs are equal: result = sign bit + sum_abs magnitude bits
    wire [N-1:0] result_same_sign = {a_sign, sum_abs[N-2:0]};

    // When signs differ:
    // if a_abs >= b_abs: result = positive (sign=0), magnitude = diff_abs
    // if b_abs > a_abs:  result sign = b_sign (could be 0 or 1), magnitude = diff_abs
    // if difference zero, force result zero with sign=0 (positive zero)
    wire diff_zero = (diff_abs == 0);

    wire [N-1:0] result_diff_a_ge_b = diff_zero ? {N{1'b0}} : {1'b0, diff_abs[N-2:0]};
    wire [N-1:0] result_diff_b_gt_a  = diff_zero ? {N{1'b0}} : {b_sign, diff_abs[N-2:0]};

    // Final output
    assign c = (a_sign == b_sign) ?
                result_same_sign :
                (a_abs_ge_b_abs ?
                    result_diff_a_ge_b :
                    result_diff_b_gt_a
                );

endmodule