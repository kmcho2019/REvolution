module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed numbers for easier sign manipulation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values inline (two's complement if negative)
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // For same sign inputs, subtract normally as signed values
    wire signed [N-1:0] same_sign_diff = a_signed - b_signed;

    // For different sign inputs, sum absolute values
    wire [N-1:0] sum_abs = a_abs + b_abs;

    // Determine result magnitude and sign for different sign cases
    // Case 1: a positive, b negative
    //   Result sign positive if |a| >= |b|, else negative
    // Case 2: a negative, b positive
    //   Result sign negative if |a| >= |b|, else positive

    wire [N-1:0] diff_sign_res_mag = sum_abs;
    wire diff_sign_res_sign = (a_sign == 1'b0 && b_sign == 1'b1) ? (~a_ge_b) :
                              (a_sign == 1'b1 && b_sign == 1'b0) ? a_ge_b :
                              1'b0; // default 0 when signs equal (unused)

    // Compose two's complement result for different sign case
    wire [N-1:0] diff_sign_res = diff_sign_res_sign ? ((~diff_sign_res_mag) + 1'b1) : diff_sign_res_mag;

    // Select result based on sign comparison
    wire [N-1:0] raw_res = (a_sign == b_sign) ? same_sign_diff : diff_sign_res;

    // Clear sign bit if result is zero (handle +0 explicitly)
    wire is_zero = (raw_res == {N{1'b0}});
    assign c = is_zero ? {1'b0, raw_res[N-2:0]} : raw_res;

endmodule