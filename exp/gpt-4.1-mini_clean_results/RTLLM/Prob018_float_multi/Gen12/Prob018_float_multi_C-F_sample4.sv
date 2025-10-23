module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // --- Stage 0: Input extraction, special cases, operand valid gating ---
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;

    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;
    reg         operand_valid_s0;

    reg [23:0]  a_mant_s0, b_mant_s0;
    reg         sign_s0;

    // --- Stage 1: Mantissa multiplication and exponent calculation ---
    reg [47:0]  product_s1;
    reg signed [9:0]  exp_sum_s1; // 10 bits signed to accommodate exponent sums (-127 to 383)
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;
    reg         operand_valid_s1;

    // --- Stage 2: Normalization, rounding, special cases, and output assembly ---
    reg [47:0]  product_s2;
    reg signed [9:0]  exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;
    reg         operand_valid_s2;

    reg [23:0]  mant_norm_s2;
    reg         guard_s2, round_s2, sticky_s2;

    // Rounded mantissa with carry bit
    reg [24:0]  mant_round_s2;
    reg         round_increment_s2;

    reg [22:0]  mant_final_s2;
    reg [7:0]   exp_final_s2;
    reg         sign_final_s2;

    // --- Stage 0: Extraction, special cases, operand valid gating ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0; b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;
            a_is_zero_s0 <= 0; b_is_zero_s0 <= 0;
            a_is_inf_s0 <= 0; b_is_inf_s0 <= 0;
            a_is_nan_s0 <= 0; b_is_nan_s0 <= 0;
            operand_valid_s0 <= 0;
            a_mant_s0 <= 0; b_mant_s0 <= 0;
            sign_s0 <= 0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];
            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];
            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            a_is_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_is_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            a_is_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_is_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Mantissas with implicit leading 1 for normal numbers, 0 for denormals
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            sign_s0 <= a[31] ^ b[31];

            // Operand valid if neither is NaN (NaNs propagate special)
            // Multiplication of Inf/zero handled later; so operand valid means normal or denormal or infinity or zero (non-NaN)
            operand_valid_s0 <= ~( (a[30:23] == 8'hFF && a[22:0] != 0) || (b[30:23] == 8'hFF && b[22:0] != 0) );
        end
    end

    // --- Stage 1: Mantissa multiplication and exponent addition with gating ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 48'd0;
            exp_sum_s1 <= 10'sd0;
            sign_s1 <= 0;
            a_is_zero_s1 <= 0; b_is_zero_s1 <= 0;
            a_is_inf_s1 <= 0; b_is_inf_s1 <= 0;
            a_is_nan_s1 <= 0; b_is_nan_s1 <= 0;
            operand_valid_s1 <= 0;
        end else begin
            a_is_zero_s1 <= a_is_zero_s0; b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1 <= a_is_inf_s0; b_is_inf_s1 <= b_is_inf_s0;
            a_is_nan_s1 <= a_is_nan_s0; b_is_nan_s1 <= b_is_nan_s0;
            sign_s1 <= sign_s0;
            operand_valid_s1 <= operand_valid_s0;

            if (operand_valid_s0) begin
                product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 -> 48 bits
                // exponent sum: add exponents and subtract bias
                // use signed arithmetic since exp can underflow
                exp_sum_s1 <= $signed({1'b0, a_exp_s0}) + $signed({1'b0, b_exp_s0}) - EXP_BIAS;
            end else begin
                product_s1 <= 48'd0;
                exp_sum_s1 <= 10'sd0;
            end
        end
    end

    // --- Stage 2: Normalize product, extract rounding bits, rounding, and output assembly ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_norm_s2 <= 10'sd0;
            sign_s2 <= 0;
            a_is_zero_s2 <= 0; b_is_zero_s2 <= 0;
            a_is_inf_s2 <= 0; b_is_inf_s2 <= 0;
            a_is_nan_s2 <= 0; b_is_nan_s2 <= 0;
            operand_valid_s2 <= 0;
            mant_norm_s2 <= 24'd0;
            guard_s2 <= 0;
            round_s2 <= 0;
            sticky_s2 <= 0;
            mant_round_s2 <= 25'd0;
            round_increment_s2 <= 0;
            mant_final_s2 <= 23'd0;
            exp_final_s2 <= 8'd0;
            sign_final_s2 <= 0;
            z <= 32'd0;
        end else begin
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;
            a_is_zero_s2 <= a_is_zero_s1; b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1; b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1; b_is_nan_s2 <= b_is_nan_s1;
            operand_valid_s2 <= operand_valid_s1;

            // Normalize mantissa:
            // If MSB bit 47 == 1: no shift needed, exponent incremented by 1
            // Else shift left 1 to normalize, exponent unchanged
            if (operand_valid_s1) begin
                if (product_s1[47]) begin
                    mant_norm_s2 <= product_s1[47:24]; // 24 bits: MSB is implied 1
                    exp_norm_s2 <= exp_sum_s1 + 10'sd1;

                    guard_s2 <= product_s1[23];
                    round_s2 <= product_s1[22];
                    sticky_s2 <= |product_s1[21:0];
                end else begin
                    mant_norm_s2 <= product_s1[46:23]; // shift left 1 (effectively)
                    exp_norm_s2 <= exp_sum_s1;

                    guard_s2 <= product_s1[22];
                    round_s2 <= product_s1[21];
                    sticky_s2 <= |product_s1[20:0];
                end
            end else begin
                mant_norm_s2 <= 24'd0;
                guard_s2 <= 0;
                round_s2 <= 0;
                sticky_s2 <= 0;
                exp_norm_s2 <= 10'sd0;
            end

            // Rounding to nearest even
            round_increment_s2 <= guard_s2 & (round_s2 | sticky_s2 | mant_norm_s2[0]);
            mant_round_s2 <= {1'b0, mant_norm_s2} + (round_increment_s2 ? 25'd1 : 25'd0);

            // Handle mantissa overflow after rounding
            if (mant_round_s2[24]) begin
                // Mantissa overflow, shift right and increment exponent
                exp_final_s2 <= (exp_norm_s2 + 10'sd1 > 8'hFE) ? 8'hFF : (exp_norm_s2 + 10'sd1)[7:0]; // cap to 255 for Inf
                mant_final_s2 <= mant_round_s2[24:2]; // drop LSB after shift
            end else begin
                exp_final_s2 <= (exp_norm_s2 < 1) ? 8'd0 : exp_norm_s2[7:0]; // flush subnormals to zero
                mant_final_s2 <= mant_round_s2[22:0];
            end

            sign_final_s2 <= sign_s2;

            // --- Special cases handling ---
            // NaN propagation
            if (a_is_nan_s2 || b_is_nan_s2) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
            end
            // Inf * 0 = NaN
            else if ( (a_is_inf_s2 && b_is_zero_s2) || (b_is_inf_s2 && a_is_zero_s2) ) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
            end
            // Inf times anything non-zero = Inf
            else if (a_is_inf_s2 || b_is_inf_s2) begin
                z <= {sign_final_s2, 8'hFF, 23'd0};
            end
            // Zero times anything = Zero
            else if (a_is_zero_s2 || b_is_zero_s2) begin
                z <= {sign_final_s2, 31'd0};
            end
            else begin
                // Normal numbers or overflow/underflow

                // Overflow exponent -> Inf
                if (exp_final_s2 == 8'hFF) begin
                    z <= {sign_final_s2, 8'hFF, 23'd0};
                end
                // Underflow exponent -> Zero (flush subnormals)
                else if (exp_final_s2 == 8'd0) begin
                    z <= {sign_final_s2, 31'd0};
                end
                else begin
                    // Normal final output
                    z <= {sign_final_s2, exp_final_s2, mant_final_s2};
                end
            end
        end
    end

endmodule