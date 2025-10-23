module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign and magnitude components
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine result sign early
    wire signs_equal = (a_sign == b_sign);
    wire result_sign = signs_equal ? a_sign : 
                      (a_mag > b_mag) ? a_sign : b_sign;

    // Compute both possible magnitude operations in parallel
    wire [N-1:0] mag_sum = a_mag + b_mag;  // For same signs
    wire [N-1:0] mag_diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);

    // Special zero detection
    wire is_zero = (a_mag == 0) && (b_mag == 0);

    // Select correct magnitude based on sign comparison
    wire [N-2:0] result_mag = is_zero ? 0 :
                             signs_equal ? mag_sum[N-2:0] : 
                             mag_diff[N-2:0];

    // Combine sign and magnitude
    assign c = {result_sign, result_mag};

endmodule