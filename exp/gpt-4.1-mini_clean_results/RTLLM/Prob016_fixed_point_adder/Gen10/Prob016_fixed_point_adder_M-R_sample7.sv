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

    // Function to compute absolute value
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    // Absolute values of inputs
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Extended width for addition/subtraction
    wire [N:0] abs_add = {1'b0, a_abs} + {1'b0, b_abs};
    wire [N:0] abs_sub_a_b = {1'b0, a_abs} - {1'b0, b_abs};
    wire [N:0] abs_sub_b_a = {1'b0, b_abs} - {1'b0, a_abs};

    // Result components for different cases
    // Case 1: a_sign == b_sign -> add absolute values, sign same as inputs
    wire [N-1:0] sum_result = abs_add[N-1:0];
    wire sum_sign = a_sign;

    // Case 2a: signs differ and a_abs >= b_abs -> subtract and sign positive (MSB=0) if non-zero
    wire [N-1:0] diff_ab = abs_sub_a_b[N-1:0];
    wire diff_ab_zero = (diff_ab == 0);

    // Case 2b: signs differ and b_abs > a_abs -> subtract and sign = b_sign (if non-zero)
    wire [N-1:0] diff_ba = abs_sub_b_a[N-1:0];
    wire diff_ba_zero = (diff_ba == 0);

    // Compose output according to conditions
    wire [N-1:0] c_temp = (a_sign == b_sign) ? 
                            {sum_sign, sum_result[N-2:0]} :
                            (a_abs_ge_b_abs ?
                                (diff_ab_zero ? {N{1'b0}} : {1'b0, diff_ab[N-2:0]}) :
                                (diff_ba_zero ? {N{1'b0}} : {b_sign, diff_ba[N-2:0]})
                            );

    assign c = c_temp;

endmodule