module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (unsigned)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Signed magnitude comparison
    wire signed [N-1:0] signed_a = a;
    wire signed [N-1:0] signed_b = b;
    wire a_gt_b = (signed_a > signed_b);

    // Intermediate results
    wire [N-2:0] mag_diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = (a_mag > b_mag) ? a_sign : b_sign;

    // Result calculation
    wire [N-1:0] same_sign_res = a - b;
    wire [N-1:0] diff_sign_res = {diff_sign, mag_diff};
    wire [N-1:0] raw_res = (a_sign == b_sign) ? same_sign_res : diff_sign_res;

    // Zero detection and correction
    wire is_zero = (raw_res[N-2:0] == 0);
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : raw_res;

endmodule