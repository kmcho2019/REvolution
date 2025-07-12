module float_multi (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] z
);

    // Extract fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp_raw = a[30:23];
    wire [7:0] b_exp_raw = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Identify special cases
    wire a_exp_all_ones = (a_exp_raw == 8'hFF);
    wire b_exp_all_ones = (b_exp_raw == 8'hFF);

    wire a_frac_zero = (a_frac == 23'b0);
    wire b_frac_zero = (b_frac == 23'b0);

    wire a_is_nan = a_exp_all_ones && (a_frac != 0);
    wire b_is_nan = b_exp_all_ones && (b_frac != 0);

    wire a_is_inf = a_exp_all_ones && a_frac_zero;
    wire b_is_inf = b_exp_all_ones && b_frac_zero;

    wire a_is_zero = (a_exp_raw == 0) && (a_frac == 0);
    wire b_is_zero = (b_exp_raw == 0) && (b_frac == 0);

    // Compute sign of result
    wire z_sign = a_sign ^ b_sign;

    // Prepare mantissas with implicit leading 1 for normal numbers, 0 for denormals/zero
    wire [23:0] a_mantissa = (a_exp_raw == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp_raw == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Convert exponent to unbiased
    // For zero and denormals exponent is treated as 1 - 127 = -126 (per IEEE-754)
    wire signed [9:0] a_exp_unbiased = (a_exp_raw == 0) ? -126 : (a_exp_raw - 8'd127);
    wire signed [9:0] b_exp_unbiased = (b_exp_raw == 0) ? -126 : (b_exp_raw - 8'd127);

    // Multiply mantissas: 24 bits x 24 bits = 48 bits product
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Add exponents
    wire signed [10:0] exp_sum = a_exp_unbiased + b_exp_unbiased;

    // Normalize product:
    // The product range is [0, ~4), so highest possible 2 bits are "11" or less.
    // If bit 47 is 1, product in [2,4), shift right by 1 and increase exponent by 1
    // Else bit 47 is 0, bit 46 is 1 (or zero if zero input)
    wire product_msb = mantissa_product[47];

    wire [47:0] normalized_product = product_msb ? (mantissa_product >> 1) : mantissa_product;
    wire signed [10:0] normalized_exp = product_msb ? (exp_sum + 1) : exp_sum;

    // Extract mantissa (23 bits), guard, round, sticky bits for rounding
    // Mantissa bits: normalized_product[46:24] (23 bits)
    // Guard bit: normalized_product[23]
    // Round bit: normalized_product[22]
    // Sticky bit: OR of normalized_product[21:0]
    wire [22:0] mantissa_field = normalized_product[46:24];
    wire guard_bit = normalized_product[23];
    wire round_bit = normalized_product[22];
    wire sticky_bit = |normalized_product[21:0];

    // Compose the mantissa with rounding bit: add 1 if round to nearest even conditions met
    wire round_increment = guard_bit & (round_bit | sticky_bit | mantissa_field[0]);
    wire [23:0] mantissa_plus_round = {1'b0, mantissa_field} + round_increment;

    // Check if mantissa overflowed after rounding (carry out)
    wire mantissa_overflow = mantissa_plus_round[23];

    // Adjust exponent and mantissa if overflow from rounding
    wire signed [10:0] final_exp = mantissa_overflow ? (normalized_exp + 1) : normalized_exp;
    wire [22:0] final_mantissa = mantissa_overflow ? mantissa_plus_round[23:1] : mantissa_plus_round[22:0];

    // Check for exponent overflow and underflow
    wire exp_overflow = (final_exp > 127);
    wire exp_underflow = (final_exp < -126);

    // Handle special cases and assemble output
    reg [31:0] result;

    always @(*) begin
        // Default output
        result = 32'b0;

        // NaN if any input NaN
        if (a_is_nan || b_is_nan) begin
            // Quiet NaN: sign 0, exp all ones, MSB mantissa 1
            result = {1'b0, 8'hFF, 1'b1, 22'b0};
        end
        // Inf * 0 = NaN
        else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
            result = {1'b0, 8'hFF, 1'b1, 22'b0};
        end
        // Inf * nonzero = Inf
        else if (a_is_inf || b_is_inf) begin
            result = {z_sign, 8'hFF, 23'b0};
        end
        // 0 * anything = 0
        else if (a_is_zero || b_is_zero) begin
            // Zero with correct sign
            result = {z_sign, 31'b0};
        end
        else begin
            // Normal or denormal output

            if (exp_overflow) begin
                // Overflow to infinity
                result = {z_sign, 8'hFF, 23'b0};
            end else if (exp_underflow) begin
                // Underflow to zero (flush denormals)
                result = {z_sign, 31'b0};
            end else begin
                // Normal number
                // bias exponent back
                wire [7:0] biased_exp = final_exp + 127;

                result = {z_sign, biased_exp, final_mantissa};
            end
        end
    end

    assign z = result;

endmodule