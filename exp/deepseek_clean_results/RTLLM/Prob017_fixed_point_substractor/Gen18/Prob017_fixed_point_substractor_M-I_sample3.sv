module fixed_point_subtractor #(
    parameter N = 32,        // Total bits (integer + fractional)
    parameter Q = 16         // Fractional bits (unused but kept for interface compatibility)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Combined comparison and arithmetic control
    wire signs_equal = (a_sign == b_sign);
    wire mag_equal = (a_mag == b_mag);
    wire a_mag_gt_b = (a_mag > b_mag);

    // Arithmetic operation
    wire [N-2:0] mag_result = signs_equal ? (a_mag - b_mag) : (a_mag + b_mag);

    // Sign determination (optimized to use single comparison)
    wire result_sign = mag_equal ? 1'b0 :            // Zero case
                      (signs_equal ? a_sign :       // Same signs: keep input sign
                      (a_mag_gt_b ? a_sign : b_sign)); // Different signs: larger magnitude's sign

    // Final result assembly
    assign c = mag_equal ? {1'b0, {(N-1){1'b0}}} : {result_sign, mag_result};

endmodule