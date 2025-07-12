module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Intermediate signals
    reg         a_sign, b_sign, z_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    reg [23:0]  a_mant, b_mant; // mantissas with implicit leading 1 or 0 for denorm
    reg [47:0]  product;

    reg [9:0]   exp_sum; // wider for overflow/underflow detection

    reg         a_is_zero, b_is_zero;
    reg         a_is_inf,  b_is_inf;
    reg         a_is_nan,  b_is_nan;

    reg [23:0]  mant_norm;
    reg [7:0]   exp_norm;
    reg         guard, round_bit, sticky;
    reg [24:0]  mant_rounded;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Extract fields
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp  <= a[30:23];
            b_exp  <= b[30:23];
            a_frac <= a[22:0];
            b_frac <= b[22:0];

            // Special case detection
            a_is_zero <= (a_exp == 8'd0) && (a_frac == 23'd0);
            b_is_zero <= (b_exp == 8'd0) && (b_frac == 23'd0);
            a_is_inf  <= (a_exp == 8'hFF) && (a_frac == 23'd0);
            b_is_inf  <= (b_exp == 8'hFF) && (b_frac == 23'd0);
            a_is_nan  <= (a_exp == 8'hFF) && (a_frac != 23'd0);
            b_is_nan  <= (b_exp == 8'hFF) && (b_frac != 23'd0);

            // Prepare mantissas (with implicit leading 1 if normalized, else 0)
            a_mant <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mant <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Sign of result
            z_sign <= a_sign ^ b_sign;

            // If either NaN -> output quiet NaN
            if (a_is_nan || b_is_nan) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
            end 
            // Inf * 0 or 0 * Inf -> NaN
            else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
            end
            // Inf * non-zero -> Inf
            else if (a_is_inf || b_is_inf) begin
                z <= {z_sign, 8'hFF, 23'd0}; // Infinity
            end
            // Zero * anything -> zero
            else if (a_is_zero || b_is_zero) begin
                z <= {z_sign, 31'd0}; // Zero
            end
            else begin
                // Exponent sum: a_exp + b_exp - bias
                exp_sum <= a_exp + b_exp - EXP_BIAS;

                // Mantissa multiplication 24x24 bits -> 48 bits
                product <= a_mant * b_mant;

                // Normalization
                if (product[47]) begin
                    // MSB is 1, shift right by 1, increment exponent
                    mant_norm <= product[47:24];
                    exp_norm  <= exp_sum + 1;
                    guard     <= product[23];
                    round_bit <= product[22];
                    sticky    <= |product[21:0];
                end else begin
                    // MSB is 0, take bits [46:23], exponent unchanged
                    mant_norm <= product[46:23];
                    exp_norm  <= exp_sum;
                    guard     <= product[22];
                    round_bit <= product[21];
                    sticky    <= |product[20:0];
                end

                // Round to nearest even
                mant_rounded <= mant_norm + 
                    ((guard && (round_bit || sticky || mant_norm[0])) ? 25'd1 : 25'd0);

                // Handle mantissa overflow after rounding
                if (mant_rounded[24]) begin
                    exp_norm <= exp_norm + 1;
                    mant_norm <= mant_rounded[24:2];
                end else begin
                    mant_norm <= mant_rounded[23:1];
                end

                // Handle overflow/underflow and assemble output
                if (exp_norm >= 8'hFF) begin
                    // Overflow to Infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (exp_norm <= 0) begin
                    // Underflow to zero
                    z <= {z_sign, 31'd0};
                end else begin
                    z <= {z_sign, exp_norm[7:0], mant_norm[22:0]};
                end
            end
        end
    end

endmodule