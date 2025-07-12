module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Comparison signals
    wire a_gt_b = (a_mag > b_mag);
    wire b_gt_a = (b_mag > a_mag);
    wire mag_equal = (a_mag == b_mag);

    // Arithmetic operations
    wire [N-1:0] sum = {a_sign, a_mag} + {b_sign, b_mag};
    wire [N-2:0] diff_ab = a_mag - b_mag;
    wire [N-2:0] diff_ba = b_mag - a_mag;

    // Result selection
    wire [N-1:0] same_sign_res = sum;
    wire [N-1:0] diff_sign_res = 
        mag_equal ? {1'b0, {(N-1){1'b0}}} :  // Zero case
        (a_gt_b ? {a_sign, diff_ab} : {b_sign, diff_ba});

    // Final output assignment
    assign c = (a_sign == b_sign) ? same_sign_res : diff_sign_res;

endmodule