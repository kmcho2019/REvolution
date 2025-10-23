module fixed_point_subtractor #(
    parameter N = 32,        // Total bits (integer + fractional)
    parameter Q = 16         // Fractional bits
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

    // Comparison signals
    wire signs_equal = (a_sign == b_sign);
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Arithmetic operation selection
    wire do_subtract = signs_equal;
    wire [N-1:0] arithmetic_result;

    // Magnitude arithmetic
    wire [N-2:0] mag_result;
    assign mag_result = do_subtract ? (a_mag - b_mag) : (a_mag + b_mag);

    // Result sign determination
    wire result_sign;
    assign result_sign = a_eq_b ? 1'b0 :            // Zero case
                        signs_equal ? a_sign :      // Same signs
                        a_gt_b ? a_sign : b_sign;  // Different signs

    // Final result assembly
    assign arithmetic_result = {result_sign, mag_result};
    assign c = a_eq_b ? {1'b0, {(N-1){1'b0}}} : arithmetic_result;

endmodule