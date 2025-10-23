module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
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

    // Sign difference detection
    wire signs_differ = a_sign ^ b_sign;

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Result magnitude calculation
    wire [N-2:0] mag_diff = a_mag - b_mag;
    wire [N-2:0] mag_sum = a_mag + b_mag;
    wire [N-2:0] res_mag = signs_differ ? mag_sum : 
                          (a_gt_b ? mag_diff : -mag_diff);

    // Result sign calculation
    wire res_sign = signs_differ ? 
                   (a_sign ? !a_gt_b : a_gt_b) : 
                   a_sign;

    // Final result with zero handling
    assign c = (mag_equal && signs_differ) ? {1'b0, {(N-1){1'b0}}} :  // a = -b case
               (res_mag == 0) ? {1'b0, {(N-1){1'b0}}} :               // zero magnitude
               {res_sign, res_mag};                                   // normal case

endmodule