module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE-754 constants
    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;
    localparam ZERO_32 = 32'd0;

    // Input fields
    wire        a_sign = a[31];
    wire [7:0]  a_exp  = a[30:23];
    wire [22:0] a_frac = a[22:0];

    wire        b_sign = b[31];
    wire [7:0]  b_exp  = b[30:23];
    wire [22:0] b_frac = b[22:0];

    // Output sign
    wire        sign_z = a_sign ^ b_sign;

    // Detect special cases on inputs
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_denorm = (a_exp == 8'd0) && (a_frac != 23'd0);
    wire b_is_denorm = (b_exp == 8'd0) && (b_frac != 23'd0);

    wire a_is_inf = (a_exp == EXP_INF_NAN) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == EXP_INF_NAN) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == EXP_INF_NAN) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == EXP_INF_NAN) && (b_frac != 23'd0);

    // Prepare mantissas (24-bit with implicit leading 1 if normalized, else just fraction for denorm)
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Mantissa multiplication (24 x 24 = 48 bits)
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Exponent addition (adjusting bias)
    // Use signed arithmetic to handle underflow naturally
    wire signed [9:0] exp_a = (a_exp == 8'd0) ? 10'd1 - EXP_BIAS : $signed({2'b0, a_exp}) - EXP_BIAS;
    wire signed [9:0] exp_b = (b_exp == 8'd0) ? 10'd1 - EXP_BIAS : $signed({2'b0, b_exp}) - EXP_BIAS;
    wire signed [10:0] exp_sum_unbiased = exp_a + exp_b;

    // Normalization:
    // The product is 48 bits, the leading bits determine normalization.
    // If product[47] = 1, mantissa is normalized and exponent is incremented.
    // Else, normalize by shifting left once, exponent unchanged.
    wire norm_shift = ~mantissa_product[47]; // 1 means shift left by 1

    // Normalized mantissa before rounding (24 bits)
    wire [23:0] norm_mantissa_pre = norm_shift ? mantissa_product[46:23] << 1 | mantissa_product[22] : mantissa_product[47:24];

    // Bits for rounding: guard, round, sticky
    wire guard_bit = norm_shift ? mantissa_product[22] : mantissa_product[23];
    wire round_bit = norm_shift ? mantissa_product[21] : mantissa_product[22];

    // Sticky bit is OR of all bits below round bit
    wire sticky_bit = norm_shift ? |mantissa_product[20:0] : |mantissa_product[21:0];

    // Exponent adjusted with normalization shift and bias restored:
    wire signed [10:0] exp_sum_norm = exp_sum_unbiased + (norm_shift ? 0 : 1);

    // Round to nearest even:
    // Increment mantissa if (guard_bit == 1) and (round_bit == 1 or sticky_bit == 1 or LSB of mantissa_pre == 1)
    wire round_increment = guard_bit && (round_bit | sticky_bit | norm_mantissa_pre[0]);

    wire [24:0] mantissa_rounded = {1'b0, norm_mantissa_pre} + (round_increment ? 25'd1 : 25'd0);

    // Handle mantissa overflow due to rounding
    wire mantissa_overflow = mantissa_rounded[24];

    // Final exponent after rounding adjustment
    wire signed [10:0] exp_final = exp_sum_norm + (mantissa_overflow ? 1 : 0);

    // Final mantissa (23 bits)
    wire [22:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:2] : mantissa_rounded[23:1];

    // Final exponent clamped and biased
    wire [7:0] exponent_final;

    // Overflow and underflow detection
    wire overflow = (exp_final + EXP_BIAS) >= 11'd255;
    wire underflow = (exp_final + EXP_BIAS) <= 0;

    // Compute biased exponent for normal range
    wire [8:0] biased_exp_tmp = exp_final + EXP_BIAS;

    // Assemble normal result (tentative)
    wire [31:0] normal_result = {sign_z, biased_exp_tmp[7:0], mantissa_final};

    // Special cases handling combinationally (priority order):
    // If NaN in any input => output NaN (quiet NaN with MSB of mantissa set)
    // If one input is Inf and other is zero => NaN
    // If one input is Inf => Inf with sign
    // If one input is zero => zero with sign
    // Else if overflow => Inf with sign
    // Else if underflow => zero with sign (flush denormals to zero)
    // Else normal_result

    // Create quiet NaN pattern: exponent=255, mantissa MSB=1, rest zero
    wire [31:0] quiet_nan = {1'b0, 8'hFF, 1'b1, 22'd0};

    wire inputs_nan = a_is_nan || b_is_nan;
    wire inputs_inf_and_zero = ( (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero) );
    wire inputs_inf = a_is_inf || b_is_inf;
    wire inputs_zero = a_is_zero || b_is_zero;

    wire [31:0] inf_result = {sign_z, 8'hFF, 23'd0};
    wire [31:0] zero_result = {sign_z, 31'd0};

    // Output register logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            if (inputs_nan)
                z <= quiet_nan;
            else if (inputs_inf_and_zero)
                z <= quiet_nan; // Inf * 0 = NaN
            else if (inputs_inf)
                z <= inf_result;
            else if (inputs_zero)
                z <= zero_result;
            else if (overflow)
                z <= inf_result;
            else if (underflow)
                z <= zero_result; // flush denormals to zero
            else
                z <= normal_result;
        end
    end

endmodule