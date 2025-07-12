module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Parameters
    localparam EXP_BITS = 8;
    localparam MANT_BITS = 23;
    localparam BIAS = 127;

    // Input fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [EXP_BITS-1:0] a_exp = a[30:23];
    wire [EXP_BITS-1:0] b_exp = b[30:23];
    wire [MANT_BITS-1:0] a_frac = a[22:0];
    wire [MANT_BITS-1:0] b_frac = b[22:0];

    // Special cases inputs
    wire a_exp_all_ones = (a_exp == 8'hFF);
    wire b_exp_all_ones = (b_exp == 8'hFF);
    wire a_exp_zero = (a_exp == 8'h00);
    wire b_exp_zero = (b_exp == 8'h00);
    wire a_frac_zero = (a_frac == 0);
    wire b_frac_zero = (b_frac == 0);

    // Flags
    wire a_is_nan = a_exp_all_ones && (a_frac != 0);
    wire b_is_nan = b_exp_all_ones && (b_frac != 0);
    wire a_is_inf = a_exp_all_ones && (a_frac == 0);
    wire b_is_inf = b_exp_all_ones && (b_frac == 0);
    wire a_is_zero = a_exp_zero && (a_frac_zero);
    wire b_is_zero = b_exp_zero && (b_frac_zero);

    // Mantissas with implicit leading 1 for normals, else zero for subnormals
    wire [23:0] a_mantissa = a_exp_zero ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = b_exp_zero ? {1'b0, b_frac} : {1'b1, b_frac};

    // Sign of result
    wire z_sign = a_sign ^ b_sign;

    // Special case handling
    // NaN if any operand is NaN or inf*0 case
    wire inf_zero_case = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire is_nan = a_is_nan || b_is_nan || inf_zero_case;
    // Infinite if either operand is inf and not inf_zero_case
    wire is_inf = (!inf_zero_case) && (a_is_inf || b_is_inf);
    // Zero if either operand is zero and neither is inf or nan
    wire is_zero = (!is_nan && !is_inf) && (a_is_zero || b_is_zero);

    // Exponent sum (extended width)
    wire [9:0] exponent_sum = {2'b00, a_exp} + {2'b00, b_exp} - BIAS;

    // Mantissa multiplication (24x24=48 bits)
    wire [47:0] product = a_mantissa * b_mantissa;

    // Normalization:
    // If MSB product[47] is 1, product is normalized with leading one at bit 47
    // else shift left by 1 and decrement exponent by 1
    wire product_msb = product[47];

    // Normalized mantissa (24 bits + extra bits for rounding)
    wire [24:0] normalized_mantissa = product_msb ? product[47:23] : product[46:22];
    wire [47:0] mantissa_for_rounding = product_msb ? product[47:0] : (product << 1);

    // Adjust exponent accordingly
    wire [9:0] normalized_exp = product_msb ? exponent_sum + 1 : exponent_sum;

    // Rounding bits:
    // guard bit: bit 22 (product bit 22 if MSB=1 else bit 21)
    // round bit: bit 21 (product bit 21 if MSB=1 else bit 20)
    // sticky bit: OR of bits below round bit
    wire guard_bit = mantissa_for_rounding[22];
    wire round_bit = mantissa_for_rounding[21];
    wire sticky_bit = |mantissa_for_rounding[20:0];

    // Round to nearest even
    wire round_increment = (guard_bit && (round_bit | sticky_bit | normalized_mantissa[0]));

    wire [24:0] rounded_mantissa_pre = normalized_mantissa + round_increment;

    // If rounded mantissa overflows (bit 24 set), shift right and increment exponent
    wire mantissa_overflow = rounded_mantissa_pre[24];
    wire [24:0] rounded_mantissa = mantissa_overflow ? (rounded_mantissa_pre >> 1) : rounded_mantissa_pre;
    wire [9:0] rounded_exp = mantissa_overflow ? normalized_exp + 1 : normalized_exp;

    // Final exponent and mantissa with handling overflow and underflow
    reg [7:0] final_exp;
    reg [22:0] final_mantissa;

    always @(*) begin
        if (is_nan) begin
            // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
            final_exp = 8'hFF;
            final_mantissa = 23'h400000; // QNaN pattern (MSB mantissa = 1)
        end else if (is_inf) begin
            // Infinity
            final_exp = 8'hFF;
            final_mantissa = 23'b0;
        end else if (is_zero) begin
            // Zero
            final_exp = 8'h00;
            final_mantissa = 23'b0;
        end else begin
            // Normal or subnormal number
            if (rounded_exp[9:8] != 2'b00 || rounded_exp[7:0] >= 8'hFF) begin
                // Overflow: output infinity
                final_exp = 8'hFF;
                final_mantissa = 23'b0;
            end else if (rounded_exp[7:0] <= 0) begin
                // Underflow: output zero (no gradual underflow)
                final_exp = 8'h00;
                final_mantissa = 23'b0;
            end else begin
                final_exp = rounded_exp[7:0];
                final_mantissa = rounded_mantissa[22:0];
            end
        end
    end

    // Registered output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'b0;
        end else begin
            z <= {z_sign, final_exp, final_mantissa};
        end
    end

endmodule