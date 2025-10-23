module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values
    wire [N-1:0] abs_a = sign_a ? -a : a;
    wire [N-1:0] abs_b = sign_b ? -b : b;

    // Magnitude comparison
    wire a_gt_b = (abs_a > abs_b);
    wire mag_equal = (abs_a == abs_b);

    // Operation selection
    wire do_add = (sign_a == sign_b);
    wire [N-1:0] mag_result = do_add ? (abs_a + abs_b) :
                             a_gt_b  ? (abs_a - abs_b) :
                                       (abs_b - abs_a);

    // Result sign determination
    wire res_sign = do_add ? sign_a :
                   a_gt_b  ? sign_a :
                   mag_equal ? 1'b0 : sign_b;

    // Apply sign and handle overflow
    wire [N-1:0] signed_result = res_sign ? -mag_result : mag_result;
    wire overflow = (sign_a == sign_b) && (sign_a != signed_result[N-1]);

    // Final output with overflow saturation
    assign c = overflow ? 
               (sign_a ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}}) :
               signed_result;

endmodule