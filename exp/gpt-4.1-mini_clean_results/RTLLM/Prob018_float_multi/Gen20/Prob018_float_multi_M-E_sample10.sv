module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 8'd127;
    localparam EXP_INF_NAN = 8'hFF;

    // Input fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special flags
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_is_inf = (a_exp == EXP_INF_NAN) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == EXP_INF_NAN) && (b_frac == 23'd0);
    wire a_is_nan = (a_exp == EXP_INF_NAN) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == EXP_INF_NAN) && (b_frac != 23'd0);

    // Effective mantissas: add implicit leading 1 for normals, 0 for denormals
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Result sign is XOR of input signs
    wire result_sign = a_sign ^ b_sign;

    // Multiply mantissas (24x24 -> 48 bits)
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Add exponents, subtract bias; use 10-bit signed to handle negatives/overflow
    wire signed [9:0] exp_sum_raw = {2'b00, a_exp} + {2'b00, b_exp} - EXP_BIAS;

    // Normalize mantissa product and adjust exponent accordingly
    // Two possible cases for normalization:
    // If MSB (bit 47) is 1, product >= 2^1, shift right 1, exp +1
    // Else product < 2^1, shift right 0, exp unchanged

    wire msb_set = mantissa_product[47];

    // Shifted mantissa (for rounding: take 24 bits fraction + guard + round + sticky)
    // After normalization, we keep 24 bits: bits 46:23 or 47:24 depending on msb_set
    wire [23:0] norm_mantissa = msb_set ? mantissa_product[47:24] : mantissa_product[46:23];

    // Extract rounding bits (guard, round, sticky)
    wire guard_bit = msb_set ? mantissa_product[23] : mantissa_product[22];
    wire round_bit = msb_set ? mantissa_product[22] : mantissa_product[21];

    // Sticky bit is OR of all bits below round bit
    wire sticky_bit = msb_set ? |mantissa_product[21:0] : |mantissa_product[20:0];

    // Adjusted exponent after normalization
    wire signed [9:0] exp_sum_norm = msb_set ? (exp_sum_raw + 10'sd1) : exp_sum_raw;

    // Prepare rounding: create 25-bit value with one extra bit for rounding add
    wire [24:0] mantissa_25 = {1'b0, norm_mantissa};

    // Rounding increment conditions: round to nearest even
    wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_25[0]);

    wire [24:0] mantissa_rounded_pre = mantissa_25 + (round_increment ? 25'd1 : 25'd0);

    // Check if rounding caused mantissa overflow (bit 24 set)
    wire mantissa_overflow = mantissa_rounded_pre[24];

    // Adjust exponent if mantissa overflow due to rounding
    wire signed [9:0] exp_rounded = mantissa_overflow ? (exp_sum_norm + 10'sd1) : exp_sum_norm;

    // Final mantissa to be stored (23 bits fraction field)
    // If overflow, shift mantissa right by 1 (drop LSB)
    wire [22:0] final_mantissa = mantissa_overflow ? mantissa_rounded_pre[24:2] : mantissa_rounded_pre[23:1];

    // Handle exponent overflow/underflow for final output
    // Exponent saturations:
    // - If exp >= 255: infinity
    // - If exp <= 0: denormal or zero; here flush to zero (no gradual underflow)
    wire exponent_overflow = (exp_rounded >= 10'sd255);
    wire exponent_underflow = (exp_rounded <= 10'sd0);

    // Compose final result based on special cases
    reg [31:0] result;

    always @(*) begin
        if (a_is_nan) begin
            // Propagate NaN a
            result = {1'b0, EXP_INF_NAN, {1'b1, a_frac[21:0]}};
        end else if (b_is_nan) begin
            // Propagate NaN b
            result = {1'b0, EXP_INF_NAN, {1'b1, b_frac[21:0]}};
        end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
            // Inf * 0 = NaN
            result = {1'b0, EXP_INF_NAN, 23'h400000}; // Quiet NaN with MSB of mantissa set
        end else if (a_is_inf || b_is_inf) begin
            // Inf result with proper sign
            result = {result_sign, EXP_INF_NAN, 23'd0};
        end else if (a_is_zero || b_is_zero) begin
            // Zero result with proper sign
            result = {result_sign, 31'd0};
        end else if (exponent_overflow) begin
            // Overflow -> Infinity
            result = {result_sign, EXP_INF_NAN, 23'd0};
        end else if (exponent_underflow) begin
            // Underflow -> zero (flush)
            result = {result_sign, 31'd0};
        end else begin
            // Normal case
            result = {result_sign, exp_rounded[7:0], final_mantissa};
        end
    end

    // Register output on clock with reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= result;
        end
    end

endmodule