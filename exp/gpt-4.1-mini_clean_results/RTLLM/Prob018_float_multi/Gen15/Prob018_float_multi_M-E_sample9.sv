module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_ZERO = 8'd0;

    // Registered inputs to stabilize signals
    reg [31:0] a_reg, b_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            z <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            z <= z_next;
        end
    end

    // Combinational signals extracted from registered inputs
    wire a_sign = a_reg[31];
    wire b_sign = b_reg[31];
    wire [7:0] a_exp = a_reg[30:23];
    wire [7:0] b_exp = b_reg[30:23];
    wire [22:0] a_frac = a_reg[22:0];
    wire [22:0] b_frac = b_reg[22:0];

    // Detect special cases
    wire a_is_zero = (a_exp == EXP_ZERO) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == EXP_ZERO) && (b_frac == 23'd0);

    wire a_is_inf  = (a_exp == EXP_MAX) && (a_frac == 23'd0);
    wire b_is_inf  = (b_exp == EXP_MAX) && (b_frac == 23'd0);

    wire a_is_nan  = (a_exp == EXP_MAX) && (a_frac != 23'd0);
    wire b_is_nan  = (b_exp == EXP_MAX) && (b_frac != 23'd0);

    // Prepare mantissas with implicit leading bit (1 for normalized, 0 for denormal)
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Compute sign of result
    wire result_sign = a_sign ^ b_sign;

    // Exponent calculation: sum of exponents minus bias
    // For denormals exponent is zero, treat as 1 for calculation to prevent bias errors
    wire [9:0] a_exp_ext = (a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp};
    wire [9:0] b_exp_ext = (b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp};
    wire [9:0] exp_sum = a_exp_ext + b_exp_ext - EXP_BIAS; // 10 bits to prevent overflow

    // Multiply mantissas combinationally (24x24 -> 48 bits)
    wire [47:0] product = a_mantissa * b_mantissa;

    // Normalization: if MSB (bit 47) is 1, shift mantissa right 1 and increase exponent by 1
    wire msb_one = product[47];

    wire [23:0] mantissa_norm = msb_one ? product[47:24] : product[46:23];
    // Rounding bits after normalization
    wire guard_bit = msb_one ? product[23] : product[22];
    wire round_bit = msb_one ? product[22] : product[21];
    wire sticky_bit = msb_one ? |product[21:0] : |product[20:0];

    wire [9:0] exponent_norm = msb_one ? (exp_sum + 10'd1) : exp_sum;

    // Rounding to nearest even
    wire round_increment = guard_bit & (round_bit | sticky_bit | mantissa_norm[0]);
    wire [24:0] mantissa_rounded_pre = {1'b0, mantissa_norm} + round_increment;

    wire mantissa_overflow = mantissa_rounded_pre[24];
    wire [9:0] exponent_rounded = mantissa_overflow ? (exponent_norm + 10'd1) : exponent_norm;
    wire [22:0] fraction_rounded = mantissa_overflow ? mantissa_rounded_pre[24:2] : mantissa_rounded_pre[23:1];

    // Determine final exponent and handle overflow, underflow
    // Clamp exponent to 8 bits range
    wire exponent_overflow = (exponent_rounded > 10'd254);
    wire exponent_underflow = (exponent_rounded < 10'd1);

    // Construct final output combinationally with special cases handling
    reg [31:0] z_next;

    always @(*) begin
        if (a_is_nan)
            // propagate quiet NaN from a
            z_next = {1'b0, 8'hFF, 1'b1, a_frac[21:0]};
        else if (b_is_nan)
            // propagate quiet NaN from b
            z_next = {1'b0, 8'hFF, 1'b1, b_frac[21:0]};
        else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero))
            // Inf * 0 = NaN
            z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
        else if (a_is_inf || b_is_inf)
            // Inf * non-zero = Inf
            z_next = {result_sign, 8'hFF, 23'd0};
        else if (a_is_zero || b_is_zero)
            // Zero * anything = zero
            z_next = {result_sign, 31'd0};
        else begin
            // Normal or subnormal result
            if (exponent_overflow) begin
                // Overflow -> infinity
                z_next = {result_sign, 8'hFF, 23'd0};
            end else if (exponent_underflow) begin
                // Underflow -> zero (flush)
                z_next = {result_sign, 31'd0};
            end else begin
                // Normal number
                z_next = {result_sign, exponent_rounded[7:0], fraction_rounded};
            end
        end
    end

endmodule