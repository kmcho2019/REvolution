module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Unified magnitude comparison
    wire mag_a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Combined magnitude operation
    wire [N-2:0] mag_result = (a_sign == b_sign) ? 
                             (mag_a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag)) :
                             (a_mag + b_mag);

    // Unified sign calculation (includes zero detection)
    wire result_sign = mag_equal ? 1'b0 :  // Force positive zero
                      (a_sign == b_sign) ? 
                      (a_sign ^ !mag_a_gt_b) : // Same sign case
                      (a_sign ? !mag_a_gt_b : mag_a_gt_b); // Different signs

    // Final output assignment
    assign c = {result_sign, mag_result};

endmodule