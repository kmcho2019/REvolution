module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Input fields
    wire        a_sign = a[31];
    wire [7:0]  a_exp  = a[30:23];
    wire [22:0] a_frac = a[22:0];
    wire        b_sign = b[31];
    wire [7:0]  b_exp  = b[30:23];
    wire [22:0] b_frac = b[22:0];

    // Special cases detection for a
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);

    // Special cases detection for b
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Result sign
    wire z_sign = a_sign ^ b_sign;

    // Effective mantissas with implicit leading 1 for normals, 0 for denormals
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Multiply mantissas (24x24 => 48 bits)
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Sum of exponents minus bias
    // Use 10 bits to hold signed range: max exponent sum = 254+254-127 = 381
    wire [9:0] exp_sum_raw = a_exp + b_exp;
    wire signed [10:0] exp_sum = $signed({1'b0, exp_sum_raw}) - $signed(EXP_BIAS);

    // Normalize mantissa product
    // If MSB (bit 47) == 1, the product is already normalized with leading 1 at bit 47
    // Else shift left by 1 (effectively exponent decrement by 1)
    wire product_msb = mantissa_product[47];
    wire [47:0] norm_mantissa_pre = product_msb ? mantissa_product : (mantissa_product << 1);
    wire signed [10:0] norm_exp_pre = product_msb ? exp_sum + 1 : exp_sum;

    // Extract mantissa for output (23 bits) and rounding bits (guard, round, sticky)
    // Mantissa is bits [46:24] (23 bits)
    wire [22:0] mantissa_out = norm_mantissa_pre[46:24];
    wire guard_bit  = norm_mantissa_pre[23];
    wire round_bit  = norm_mantissa_pre[22];
    wire sticky_bit = |norm_mantissa_pre[21:0];

    // Round to nearest even
    wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_out[0]);
    wire [23:0] mantissa_rounded_pre = {1'b0, mantissa_out} + (round_increment ? 24'd1 : 24'd0);

    // After rounding, mantissa may overflow (24 bits)
    wire mantissa_overflow = mantissa_rounded_pre[23];

    // Adjust exponent and mantissa after rounding overflow
    wire signed [10:0] norm_exp = mantissa_overflow ? (norm_exp_pre + 1) : norm_exp_pre;
    wire [22:0] mantissa_final = mantissa_overflow ? mantissa_rounded_pre[23:1] : mantissa_rounded_pre[22:0];

    // Detect final exponent out of range for overflow/underflow
    wire exp_overflow = (norm_exp > 254);
    wire exp_underflow = (norm_exp < 1);

    // Special cases output determination
    wire any_nan = a_is_nan || b_is_nan;
    wire any_inf = a_is_inf || b_is_inf;
    wire any_zero = a_is_zero || b_is_zero;

    // Conflict case: inf * 0 = NaN
    wire inf_times_zero = ( (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero) );

    // Assemble final output
    reg [31:0] z_comb;

    always @* begin
        if (any_nan) begin
            // Return canonical quiet NaN
            z_comb = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (inf_times_zero) begin
            // Invalid operation: Inf * 0 = NaN
            z_comb = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (any_inf) begin
            // Inf * non-zero = Inf with sign
            z_comb = {z_sign, 8'hFF, 23'd0};
        end else if (any_zero) begin
            // Zero * anything = zero with sign
            z_comb = {z_sign, 31'd0};
        end else if (exp_overflow) begin
            // Overflow: set to Inf
            z_comb = {z_sign, 8'hFF, 23'd0};
        end else if (exp_underflow) begin
            // Underflow: flush to zero (denormals not handled)
            z_comb = {z_sign, 31'd0};
        end else begin
            // Normal number
            z_comb = {z_sign, norm_exp[7:0], mantissa_final};
        end
    end

    // Output register synchronized by clk and rst
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= z_comb;
        end
    end

endmodule