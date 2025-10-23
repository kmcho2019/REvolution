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
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Sum and overflow detection
    wire [N-1:0] sum = a + b;
    wire sum_overflow = (a_sign == b_sign) && (sum[N-1] != a_sign);

    // Difference calculation
    wire a_gt_b = (a_mag > b_mag);
    wire [N-2:0] diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = (a_mag == b_mag) ? 1'b0 : (a_gt_b ? a_sign : b_sign);

    // Saturation values
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}};

    // Result selection
    wire [N-1:0] result;
    assign result = (a_sign == b_sign) ? 
                   (sum_overflow ? (a_sign ? max_neg : max_pos) : sum) :
                   {diff_sign, diff};

    assign c = result;

endmodule