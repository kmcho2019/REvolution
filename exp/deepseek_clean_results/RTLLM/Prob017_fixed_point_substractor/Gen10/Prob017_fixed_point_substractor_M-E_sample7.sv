module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (N <= Q) $error("N must be greater than Q");
        if (Q <= 0) $error("Q must be positive");
    end

    // Sign bits and equality
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);

    // Magnitude comparator (for different signs case)
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);

    // Parallel arithmetic paths
    wire [N-1:0] same_sign_result = a - b;
    wire [N-1:0] diff_sign_result = a + b;

    // Result selection
    wire [N-1:0] raw_result = signs_equal ? same_sign_result : diff_sign_result;

    // Sign determination
    wire same_sign_out = a_sign;
    wire diff_sign_out = a_sign ? (a_gt_b ? 1'b1 : 1'b0) : (a_gt_b ? 1'b0 : 1'b1);
    wire result_sign = signs_equal ? same_sign_out : diff_sign_out;

    // Zero detection and final result
    wire is_zero = ~(|raw_result[N-1:0]);
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : {result_sign, raw_result[N-2:0]};

endmodule