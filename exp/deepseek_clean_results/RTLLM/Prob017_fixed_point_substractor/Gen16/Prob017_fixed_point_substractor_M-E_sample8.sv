module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Path selection signals
    wire signs_equal = (a_sign == b_sign);
    wire inputs_equal = (a == b);
    wire a_mag_gt_b = (a_mag > b_mag);

    // Same sign path computation
    wire [N-2:0] same_sign_diff;
    wire same_sign_ovf;
    assign {same_sign_ovf, same_sign_diff} = a_mag - b_mag;
    
    wire [N-1:0] same_sign_result = 
        inputs_equal ? {1'b0, {(N-1){1'b0}}} :  // Zero case
        {a_sign, same_sign_diff};                // Same sign result

    // Different sign path computation
    wire [N-2:0] diff_sign_sum;
    wire diff_sign_ovf;
    assign {diff_sign_ovf, diff_sign_sum} = a_mag + b_mag;
    
    wire diff_sign_result_sign = a_mag_gt_b ? a_sign : b_sign;
    wire [N-1:0] diff_sign_result = 
        {diff_sign_result_sign, diff_sign_sum};

    // Final result selection
    assign c = inputs_equal ? same_sign_result :
              signs_equal ? same_sign_result :
              diff_sign_result;

endmodule