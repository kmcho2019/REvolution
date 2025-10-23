module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

// Calculate the result based on the signs of a and b
wire [N-1:0] res_same_sign = a - b;
wire [N-1:0] res_diff_sign_pos_a = a + (~b + 1);
wire [N-1:0] res_diff_sign_neg_a = (~a + 1) + b;

// Select the correct result based on the signs
wire [N-1:0] res = (a[N-1] == b[N-1]) ? res_same_sign :
                   (a[N-1] == 0 && b[N-1] == 1) ? res_diff_sign_pos_a :
                   (a[N-1] == 1 && b[N-1] == 0) ? res_diff_sign_neg_a : 0;

// Handle zero result and assign to output
assign c = (res == 0) ? 0 : res;

endmodule