module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits and magnitude comparison
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);

    // Addition and subtraction results
    wire [N-1:0] sum = a + b;
    wire [N-1:0] diff = a_gt_b ? (a - b) : (b - a);

    // Overflow occurs when adding same signs and result sign differs
    wire overflow = signs_equal & (sum[N-1] != a_sign);

    // Result selection
    wire [N-1:0] result;
    assign result = overflow ? {a_sign, {(N-1){~a_sign}}} :  // Saturate
                   signs_equal ? sum :                       // Same sign addition
                   {a_gt_b ? a_sign : b_sign, diff[N-2:0]};  // Different sign subtraction

    assign c = result;

endmodule