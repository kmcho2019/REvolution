module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] raw_diff = a - b;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = (a_sign == b_sign);
    wire a_gt_b = (a > b);
    wire is_zero = (raw_diff == 0);
    
    // Result calculation
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} :  // Zero case
               signs_equal ? {a_sign, raw_diff[N-2:0]} :  // Same signs
               a_gt_b ? {1'b0, raw_diff[N-2:0]} :  // Different signs, a > b
               {1'b1, raw_diff[N-2:0]};  // Different signs, b > a

endmodule