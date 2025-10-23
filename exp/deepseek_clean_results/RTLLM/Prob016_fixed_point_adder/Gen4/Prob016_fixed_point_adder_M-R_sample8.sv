module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Corrected saturation constants
    localparam MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude calculations
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Sum and overflow detection
    wire [N-1:0] sum = a + b;
    wire sum_overflow = (a_sign == b_sign) && (sum[N-1] != a_sign);

    // Difference calculation
    wire a_gt_b = (a_mag > b_mag);
    wire [N-1:0] diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = a_gt_b ? a_sign : b_sign;

    // Result selection
    wire [N-1:0] same_sign_result = sum_overflow ? 
                                   (a_sign ? MAX_NEG : MAX_POS) : sum;
    wire [N-1:0] diff_sign_result = {diff_sign, diff[N-2:0]};

    // Final output
    assign c = (a_sign == b_sign) ? same_sign_result : diff_sign_result;

endmodule