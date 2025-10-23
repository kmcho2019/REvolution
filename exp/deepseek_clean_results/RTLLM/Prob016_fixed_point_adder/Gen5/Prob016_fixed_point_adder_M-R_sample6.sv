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

    // Absolute values (2's complement handling)
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Magnitude comparison
    wire a_gt_b = (abs_a > abs_b);
    wire mag_equal = (abs_a == abs_b);

    // Operation selection and magnitude result
    wire do_add = (sign_a == sign_b);
    wire [N-1:0] mag_result = do_add ? (abs_a + abs_b) :
                             a_gt_b  ? (abs_a - abs_b) :
                                       (abs_b - abs_a);

    // Result sign determination
    wire res_sign = do_add ? sign_a : 
                   (a_gt_b ? sign_a : 
                   (mag_equal ? 1'b0 : sign_b));

    // Signed result and overflow detection
    wire [N-1:0] signed_result = res_sign ? (~mag_result + 1'b1) : mag_result;
    wire overflow = do_add && (mag_result[N-1] != 1'b0);  // Overflow if magnitude MSB set

    // Final output with overflow saturation
    assign c = overflow ? 
               {sign_a, {(N-1){~sign_a}}} :  // Saturate to max positive or min negative
               signed_result;

endmodule