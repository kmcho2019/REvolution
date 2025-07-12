module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Internal signals
    reg         a_sign, b_sign, z_sign;
    reg  [7:0]  a_exp, b_exp;
    reg  [22:0] a_frac, b_frac;
    reg  [23:0] a_mant, b_mant;      // with implicit leading 1 or 0 for denormals
    reg  [47:0] product;

    reg  [9:0]  exp_sum;              // wider for intermediate exponent sum

    reg         inf_a, inf_b, nan_a, nan_b, zero_a, zero_b;

    reg  [23:0] norm_mant;
    reg  [7:0]  norm_exp;
    reg         guard, round_bit, sticky;

    reg  [24:0] rounded_mant;         // 24 bits + carry
    reg  [8:0]  final_exp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Extract sign, exponent, fraction
            a_sign = a[31];
            b_sign = b[31];
            a_exp  = a[30:23];
            b_exp  = b[30:23];
            a_frac = a[22:0];
            b_frac = b[22:0];

            // Detect special cases
            zero_a = (a_exp == 8'd0) && (a_frac == 23'd0);
            zero_b = (b_exp == 8'd0) && (b_frac == 23'd0);

            inf_a  = (a_exp == 8'hFF) && (a_frac == 23'd0);
            inf_b  = (b_exp == 8'hFF) && (b_frac == 23'd0);

            nan_a  = (a_exp == 8'hFF) && (a_frac != 23'd0);
            nan_b  = (b_exp == 8'hFF) && (b_frac != 23'd0);

            // Sign of output
            z_sign = a_sign ^ b_sign;

            // Prepare mantissas with implicit leading 1 for normalized numbers
            a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Handle special cases
            if (nan_a || nan_b) begin
                // Return quiet NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((inf_a && zero_b) || (inf_b && zero_a)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (inf_a || inf_b) begin
                // Inf * non-zero = Inf
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (zero_a || zero_b) begin
                // Zero * anything = zero
                z <= {z_sign, 31'd0};
            end else begin
                // Normal multiplication

                // Exponent sum with bias correction
                exp_sum = a_exp + b_exp - EXP_BIAS;

                // Multiply mantissas (24x24 bits)
                product = a_mant * b_mant; // 48 bits

                // Normalize: if bit 47 is 1, shift right and add 1 to exponent
                if (product[47]) begin
                    norm_mant = product[47:24];      // 24 bits including leading 1
                    guard     = product[23];
                    round_bit = product[22];
                    sticky    = |product[21:0];
                    norm_exp  = exp_sum + 1;
                end else begin
                    norm_mant = product[46:23];
                    guard     = product[22];
                    round_bit = product[21];
                    sticky    = |product[20:0];
                    norm_exp  = exp_sum;
                end

                // Round to nearest even
                if (guard && (round_bit || sticky || norm_mant[0])) begin
                    rounded_mant = {1'b0, norm_mant} + 25'd1;
                end else begin
                    rounded_mant = {1'b0, norm_mant};
                end

                // Adjust exponent if mantissa overflowed
                if (rounded_mant[24]) begin
                    final_exp = norm_exp + 1;
                end else begin
                    final_exp = norm_exp;
                end

                // Assemble fraction bits
                // If overflow in mantissa after rounding, shift right by 1
                // Take bits [23:1] as fraction (drop LSB)
                // Else take bits [22:0]
                if (rounded_mant[24]) begin
                    // Shifted right by 1
                    z <= {z_sign, final_exp[7:0], rounded_mant[23:1]};
                end else begin
                    z <= {z_sign, final_exp[7:0], rounded_mant[22:0]};
                end

                // Handle exponent overflow (Inf) and underflow (Zero)
                if (final_exp >= 8'hFF) begin
                    // Overflow to Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (final_exp <= 0) begin
                    // Underflow to zero
                    z <= {z_sign, 31'd0};
                end
            end
        end
    end

endmodule