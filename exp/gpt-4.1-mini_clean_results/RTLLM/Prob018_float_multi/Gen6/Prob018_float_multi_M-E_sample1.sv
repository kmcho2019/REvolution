module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'h00;

    // Extract fields
    wire a_sign = a[31];
    wire [7:0] a_exp = a[30:23];
    wire [22:0] a_frac = a[22:0];

    wire b_sign = b[31];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases for a
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire a_denormal = (a_exp == 8'd0) && (a_frac != 23'd0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);

    // Detect special cases for b
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire b_denormal = (b_exp == 8'd0) && (b_frac != 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Result sign
    wire res_sign = a_sign ^ b_sign;

    // Prepare mantissas with implicit leading 1 for normal, 0 for denormal and zero
    wire [23:0] a_mantissa = (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Mantissa product: 24x24 = 48 bits
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Exponent addition and bias subtraction
    // For denormals (exp=0), IEEE treats exponent as 1 - bias (effectively e=1-bias) for calculation
    // Here exponent for denormals is considered 1, so use conditional:
    wire [9:0] a_exp_adj = (a_exp == 0) ? 10'd1 : {2'd0, a_exp}; // extend to 10 bits to avoid overflow
    wire [9:0] b_exp_adj = (b_exp == 0) ? 10'd1 : {2'd0, b_exp};
    wire [9:0] exp_sum = a_exp_adj + b_exp_adj - EXP_BIAS;

    // Normalization:
    // If MSB of product (bit 47) is 1 => product >= 2.0, shift right 1, increment exponent
    wire product_msb = mantissa_product[47];
    wire [23:0] norm_mantissa;
    wire [9:0] norm_exponent;
    wire guard_bit, round_bit, sticky_bit;

    // Shift mantissa product accordingly
    wire [47:0] shifted_product = product_msb ? mantissa_product : (mantissa_product << 1);

    assign norm_mantissa = shifted_product[47:24]; // 24 bits: leading 1 + 23 frac bits

    assign norm_exponent = product_msb ? (exp_sum + 10'd1) : exp_sum;

    // Extract rounding bits: guard, round, sticky
    assign guard_bit = shifted_product[23];
    assign round_bit = shifted_product[22];
    assign sticky_bit = |shifted_product[21:0];

    // Rounding to nearest even:
    // Round increment if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)
    wire round_increment = guard_bit && (round_bit | sticky_bit | norm_mantissa[0]);

    wire [24:0] rounded_mantissa_pre = {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

    // If carry out (bit 24) after rounding, shift mantissa right 1 and increment exponent
    wire mantissa_carry = rounded_mantissa_pre[24];

    wire [22:0] final_mantissa = mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];
    wire [9:0] final_exponent_pre = mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;

    // Final exponent check for overflow/underflow
    // Clamp exponent to 8 bits for output
    wire exponent_overflow = (final_exponent_pre >= 10'd255);
    wire exponent_underflow = (final_exponent_pre <= 10'd0);

    wire [7:0] final_exponent = exponent_overflow ? 8'hFF :
                               (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

    // Special cases resolution (priority):
    // 1. If either input is NaN => result is a quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
    // 2. Inf * 0 or 0 * Inf => NaN
    // 3. Inf * non-zero => Inf with correct sign
    // 4. 0 * non-inf => zero with correct sign
    // 5. Normal computed result with exponent and mantissa
    // Note: If overflow exponent, produce Inf; if underflow exponent, produce zero.

    reg [31:0] res;

    always @* begin
        // Default to zero
        res = 32'd0;

        if (a_nan || b_nan) begin
            // quiet NaN: sign=0, exp=0xFF, mantissa with MSB=1
            res = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
            // Inf*0 = NaN
            res = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (a_inf || b_inf) begin
            // Inf * non-zero = Inf with sign
            res = {res_sign, 8'hFF, 23'd0};
        end else if (a_zero || b_zero) begin
            // zero * anything = zero with sign
            res = {res_sign, 31'd0};
        end else begin
            // Normal or denormal result
            if (exponent_overflow) begin
                // overflow => Inf
                res = {res_sign, 8'hFF, 23'd0};
            end else if (exponent_underflow) begin
                // underflow => zero (flush to zero)
                res = {res_sign, 31'd0};
            end else begin
                // Normal result
                res = {res_sign, final_exponent, final_mantissa};
            end
        end
    end

    // Register the output, synchronous reset to zero
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= res;
        end
    end

endmodule