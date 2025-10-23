module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    // Registered inputs to break timing paths and synchronize
    reg [31:0] a_reg, b_reg;

    // Fields from inputs
    wire a_sign, b_sign;
    wire [7:0] a_exp, b_exp;
    wire [22:0] a_frac, b_frac;

    // Decode inputs
    assign a_sign = a_reg[31];
    assign a_exp  = a_reg[30:23];
    assign a_frac = a_reg[22:0];

    assign b_sign = b_reg[31];
    assign b_exp  = b_reg[30:23];
    assign b_frac = b_reg[22:0];

    // Special input cases (combinational)
    wire a_is_zero    = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero    = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_is_denorm  = (a_exp == 8'd0) && (a_frac != 23'd0);
    wire b_is_denorm  = (b_exp == 8'd0) && (b_frac != 23'd0);
    wire a_is_inf     = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf     = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_is_nan     = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan     = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Determine sign of result
    wire z_sign = a_sign ^ b_sign;

    // Prepare mantissas with implicit leading one for normal numbers, zero for zero inputs, fractional bits otherwise
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Mantissa multiplication (24x24 bits)
    wire [47:0] mant_prod = a_mantissa * b_mantissa;

    // Exponent addition (signed): (a_exp - bias) + (b_exp - bias) + bias
    // Using signed arithmetic on intermediate exponent
    wire signed [9:0] a_exp_s = (a_exp == 8'd0) ? 10'sd1 - 10'sd127 : {2'b00, a_exp} - 10'sd127;
    wire signed [9:0] b_exp_s = (b_exp == 8'd0) ? 10'sd1 - 10'sd127 : {2'b00, b_exp} - 10'sd127;

    wire signed [10:0] exp_sum_raw = a_exp_s + b_exp_s; // Add exponents after bias removal

    // Normalization:
    // If mant_prod[47] == 1, product is normalized and exponent should be incremented by 1
    wire mantissa_normalized_msb = mant_prod[47];

    wire [23:0] normalized_mantissa = mantissa_normalized_msb ? mant_prod[47:24] : mant_prod[46:23];
    wire guard_bit  = mantissa_normalized_msb ? mant_prod[23] : mant_prod[22];
    wire round_bit  = mantissa_normalized_msb ? mant_prod[22] : mant_prod[21];
    wire sticky_bit = mantissa_normalized_msb ? (|mant_prod[21:0]) : (|mant_prod[20:0]);

    wire signed [10:0] exp_sum = mantissa_normalized_msb ? (exp_sum_raw + 11'sd1) : exp_sum_raw;

    // Round to nearest even
    wire round_incr = guard_bit && (round_bit || sticky_bit || normalized_mantissa[0]);
    wire [24:0] mantissa_rounded = {1'b0, normalized_mantissa} + round_incr;

    // If rounding causes overflow (bit 24 set), shift right and increase exponent
    wire mantissa_overflow = mantissa_rounded[24];
    wire [23:0] final_mantissa = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire signed [10:0] final_exponent = mantissa_overflow ? (exp_sum + 11'sd1) : exp_sum;

    // Final exponent saturate check for overflow and underflow
    wire exp_overflow = (final_exponent > 10'sd254);
    wire exp_underflow = (final_exponent < 10'sd1);

    // Final exponent truncated to 8 bits if normal number
    wire [7:0] final_exp_field = exp_overflow ? 8'hFF :
                                (exp_underflow ? 8'd0 : final_exponent[7:0]);

    // Compose the final fraction field: if underflow, zero; else normalized mantissa without leading bit
    wire [22:0] final_fraction = (exp_underflow) ? 23'd0 : final_mantissa[22:0];

    // Special case final output signals
    reg [31:0] special_case_out;
    reg        special_case;

    always @(*) begin
        // Priority of special cases
        if (a_is_nan || b_is_nan) begin
            // Propagate NaN (quiet NaN: MSB fraction bit set)
            special_case_out = {1'b0, 8'hFF, 1'b1, 22'd0};
            special_case = 1'b1;
        end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
            // Invalid operation NaN
            special_case_out = {1'b0, 8'hFF, 1'b1, 22'd0};
            special_case = 1'b1;
        end else if (a_is_inf || b_is_inf) begin
            // Infinity with sign
            special_case_out = {z_sign, 8'hFF, 23'd0};
            special_case = 1'b1;
        end else if (a_is_zero || b_is_zero) begin
            // Zero with sign
            special_case_out = {z_sign, 31'd0};
            special_case = 1'b1;
        end else begin
            special_case_out = 32'd0;
            special_case = 1'b0;
        end
    end

    // Output register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            z <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;

            if (special_case)
                z <= special_case_out;
            else if (exp_overflow)
                z <= {z_sign, 8'hFF, 23'd0}; // Infinity on overflow
            else if (exp_underflow)
                z <= {z_sign, 31'd0};       // Zero on underflow (no denormals)
            else
                z <= {z_sign, final_exp_field, final_fraction};
        end
    end

endmodule