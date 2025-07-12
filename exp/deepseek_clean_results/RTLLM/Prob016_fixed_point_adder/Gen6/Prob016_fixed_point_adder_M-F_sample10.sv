module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude calculations (absolute values)
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;

    // Sum and overflow detection
    wire [N:0] sum_ext = {a_sign, a} + {b_sign, b};
    wire sum_overflow = (a_sign == b_sign) && (sum_ext[N] != sum_ext[N-1]);

    // Difference calculation
    wire a_gt_b = (a_mag > b_mag);
    wire [N-1:0] diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = a_gt_b ? a_sign : b_sign;

    // Result selection and saturation
    wire same_sign = (a_sign == b_sign);
    wire [N-1:0] saturated = a_sign ? {1'b1, {(N-1){1'b0}} : {1'b0, {(N-1){1'b1}};
    
    wire [N-1:0] same_sign_result = sum_overflow ? saturated : sum_ext[N-1:0];
    wire [N-1:0] diff_sign_result = (diff == 0) ? 0 : {diff_sign, diff[N-2:0]};

    // Final output
    assign c = same_sign ? same_sign_result : diff_sign_result;

endmodule