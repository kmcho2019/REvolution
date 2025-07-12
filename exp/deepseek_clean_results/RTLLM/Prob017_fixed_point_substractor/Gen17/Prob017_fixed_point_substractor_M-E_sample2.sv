module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude parts
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Conditionally invert magnitudes for subtraction
    wire [N-2:0] a_mag_inv = a_sign ? ~a_mag : a_mag;
    wire [N-2:0] b_mag_inv = b_sign ? ~b_mag : b_mag;
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Same sign case (both positive or both negative)
    wire same_sign = ~(a_sign ^ b_sign);
    wire [N-1:0] same_sign_res = {a_sign, a_mag} - {b_sign, b_mag};
    
    // Different sign case
    wire [N-2:0] diff_sign_mag = a_mag + b_mag;
    wire diff_sign_sign = a_sign ? (a_gt_b ? 1'b1 : 1'b0) : (a_gt_b ? 1'b0 : 1'b1);
    wire [N-1:0] diff_sign_res = {diff_sign_sign, diff_sign_mag};
    
    // Result selection
    wire [N-1:0] raw_res = same_sign ? same_sign_res : diff_sign_res;
    
    // Hierarchical zero detection
    wire [7:0] or_level1 = |raw_res[N-2:N-9];
    wire [7:0] or_level2 = |raw_res[N-10:N-17];
    wire [7:0] or_level3 = |raw_res[N-18:N-25];
    wire [7:0] or_level4 = |raw_res[N-26:N-32];
    wire zero_result = ~(|{or_level1, or_level2, or_level3, or_level4});
    
    // Final result with zero sign correction
    assign c = zero_result ? {1'b0, raw_res[N-2:0]} : raw_res;

endmodule