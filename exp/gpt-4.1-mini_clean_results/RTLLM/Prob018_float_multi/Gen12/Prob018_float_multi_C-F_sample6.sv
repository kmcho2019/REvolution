module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Stage 0 registers: decode inputs and detect special cases
    reg         s0_sign;
    reg  [7:0]  s0_exp_a, s0_exp_b;
    reg  [22:0] s0_frac_a, s0_frac_b;
    reg  [23:0] s0_mant_a, s0_mant_b;
    reg         s0_zero_a, s0_zero_b;
    reg         s0_inf_a,  s0_inf_b;
    reg         s0_nan_a,  s0_nan_b;

    // Stage 1 registers: multiply mantissas, add exponents, propagate sign and flags
    reg         s1_sign;
    reg  [8:0]  s1_exp_sum;  // 9 bits to hold max sum and bias-adjusted exponent
    reg  [47:0] s1_product;
    reg         s1_zero_a, s1_zero_b;
    reg         s1_inf_a,  s1_inf_b;
    reg         s1_nan_a,  s1_nan_b;

    // Stage 2 registers: normalize, rounding, and final output assembly
    reg         s2_sign;
    reg  [8:0]  s2_exp;
    reg  [23:0] s2_mant;
    reg         s2_guard, s2_round, s2_sticky;
    reg         s2_zero_a, s2_zero_b;
    reg         s2_inf_a, s2_inf_b;
    reg         s2_nan_a, s2_nan_b;

    // Intermediate signals for rounding and final output assembly
    reg [24:0] mant_rounded;  // 25 bits to handle rounding carry
    reg [8:0]  exp_rounded;
    reg [22:0] final_frac;
    reg        final_sign;
    reg [7:0]  final_exp_8;

    // Stage 0: Decode inputs and detect special cases, extract mantissa with implicit bit
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s0_sign <= 1'b0;
            s0_exp_a <= 8'd0; s0_exp_b <= 8'd0;
            s0_frac_a <= 23'd0; s0_frac_b <= 23'd0;
            s0_mant_a <= 24'd0; s0_mant_b <= 24'd0;
            s0_zero_a <= 1'b0; s0_zero_b <= 1'b0;
            s0_inf_a <= 1'b0;  s0_inf_b <= 1'b0;
            s0_nan_a <= 1'b0;  s0_nan_b <= 1'b0;
        end else begin
            s0_sign <= a[31] ^ b[31];

            s0_exp_a <= a[30:23];
            s0_exp_b <= b[30:23];
            s0_frac_a <= a[22:0];
            s0_frac_b <= b[22:0];

            s0_zero_a <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            s0_zero_b <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            s0_inf_a <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            s0_inf_b <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            s0_nan_a <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            s0_nan_b <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Mantissa with implicit leading 1 for normalized, 0 for denormals
            s0_mant_a <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            s0_mant_b <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Stage 1: Multiply mantissas, add exponents - bias adjust, propagate flags
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_sign <= 1'b0;
            s1_exp_sum <= 9'd0;
            s1_product <= 48'd0;
            s1_zero_a <= 1'b0; s1_zero_b <= 1'b0;
            s1_inf_a <= 1'b0;  s1_inf_b <= 1'b0;
            s1_nan_a <= 1'b0;  s1_nan_b <= 1'b0;
        end else begin
            s1_sign <= s0_sign;
            s1_product <= s0_mant_a * s0_mant_b; // 24x24 = 48 bits
            s1_exp_sum <= s0_exp_a + s0_exp_b - EXP_BIAS; // 9 bits sufficient
            s1_zero_a <= s0_zero_a;
            s1_zero_b <= s0_zero_b;
            s1_inf_a <= s0_inf_a;
            s1_inf_b <= s0_inf_b;
            s1_nan_a <= s0_nan_a;
            s1_nan_b <= s0_nan_b;
        end
    end

    // Stage 2: Normalize product, extract rounding bits, prepare for rounding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s2_sign <= 1'b0;
            s2_exp <= 9'd0;
            s2_mant <= 24'd0;
            s2_guard <= 1'b0;
            s2_round <= 1'b0;
            s2_sticky <= 1'b0;
            s2_zero_a <= 1'b0; s2_zero_b <= 1'b0;
            s2_inf_a <= 1'b0;  s2_inf_b <= 1'b0;
            s2_nan_a <= 1'b0;  s2_nan_b <= 1'b0;
        end else begin
            s2_sign <= s1_sign;
            s2_zero_a <= s1_zero_a;
            s2_zero_b <= s1_zero_b;
            s2_inf_a <= s1_inf_a;
            s2_inf_b <= s1_inf_b;
            s2_nan_a <= s1_nan_a;
            s2_nan_b <= s1_nan_b;

            // Normalization:
            // If MSB of product[47] == 1, normalized mantissa is bits [47:24], exponent incremented by 1
            // Else normalized mantissa is bits [46:23], exponent unchanged
            if (s1_product[47]) begin
                s2_exp <= s1_exp_sum + 9'd1;
                s2_mant <= s1_product[47:24];
                s2_guard <= s1_product[23];
                s2_round <= s1_product[22];
                s2_sticky <= |s1_product[21:0];
            end else begin
                s2_exp <= s1_exp_sum;
                s2_mant <= s1_product[46:23];
                s2_guard <= s1_product[22];
                s2_round <= s1_product[21];
                s2_sticky <= |s1_product[20:0];
            end
        end
    end

    // Stage 3: Rounding, exponent adjustment, special case handling, output assembly
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Handle special cases priority:
            // NaN if any input NaN or invalid operation (Inf * 0)
            // Inf if any input Inf and not invalid operation
            // Zero if any input zero and not invalid operation
            // Else normal rounding and assembly

            if (s2_nan_a || s2_nan_b) begin
                // Quiet NaN: exponent all ones, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((s2_inf_a && s2_zero_b) || (s2_inf_b && s2_zero_a)) begin
                // Invalid operation Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (s2_inf_a || s2_inf_b) begin
                // Infinity * non-zero = Infinity with sign
                z <= {s2_sign, 8'hFF, 23'd0};
            end else if (s2_zero_a || s2_zero_b) begin
                // Zero * anything = zero with sign
                z <= {s2_sign, 31'd0};
            end else begin
                // Round to nearest even
                // round_increment = guard & (round | sticky | LSB)
                wire round_increment;
                round_increment = s2_guard & (s2_round | s2_sticky | s2_mant[0]);

                mant_rounded = {1'b0, s2_mant} + (round_increment ? 25'd1 : 25'd0);

                // Check for mantissa overflow after rounding
                if (mant_rounded[24]) begin
                    exp_rounded = s2_exp + 9'd1;
                    final_frac = mant_rounded[23:1];
                end else begin
                    exp_rounded = s2_exp;
                    final_frac = mant_rounded[22:0];
                end

                final_sign = s2_sign;

                // Exponent overflow and underflow
                if (exp_rounded >= 9'd255) begin
                    // Overflow: output Infinity
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (exp_rounded <= 0) begin
                    // Underflow: flush to zero (no denormals)
                    z <= {final_sign, 31'd0};
                end else begin
                    final_exp_8 = exp_rounded[7:0];
                    z <= {final_sign, final_exp_8, final_frac};
                end
            end
        end
    end

endmodule