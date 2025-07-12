module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Special case flags packed [5:0] = {a_nan,b_nan,a_inf,b_inf,a_zero,b_zero}
    reg [5:0] special_s0, special_s1, special_s2, special_s3;

    // Stage 0 registers - input extraction and special cases
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;

    reg [23:0]  a_mant_s0, b_mant_s0;
    reg         sign_s0;

    // Stage 1 registers - multiply mantissas, exponent addition
    reg [47:0]  product_s1;
    reg [8:0]   exp_sum_s1;       // 9 bits: 8-bit exponent + 1 bit overflow
    reg         sign_s1;
    reg [5:0]   special_s1_flags;

    // Stage 2 registers - normalization and rounding bits extraction
    reg [47:0]  product_s2;
    reg [8:0]   exp_norm_s2;
    reg         sign_s2;
    reg [5:0]   special_s2_flags;

    reg [23:0]  mant_norm_s2; // 24-bit mantissa including leading one
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3 registers - rounding and output generation
    reg [24:0]  mant_round_s3; // 25-bit for carry during rounding
    reg [8:0]   exp_round_s3;
    reg         sign_s3;
    reg [5:0]   special_s3_flags;
    reg         round_increment_s3;

    reg [22:0]  mant_final_s3;
    reg [7:0]   exp_final_s3;
    reg         sign_final_s3;

    // Stage 0: Input decode and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0; b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;
            special_s0 <= 6'd0;
            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;
            sign_s0 <= 1'b0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];
            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];
            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            // Special cases packed: {a_nan,b_nan,a_inf,b_inf,a_zero,b_zero}
            special_s0[5] <= (a_exp_s0 == 8'd0) && (a_frac_s0 == 23'd0);               // a_zero
            special_s0[4] <= (b_exp_s0 == 8'd0) && (b_frac_s0 == 23'd0);               // b_zero
            special_s0[3] <= (a_exp_s0 == 8'hFF) && (a_frac_s0 == 23'd0);              // a_inf
            special_s0[2] <= (b_exp_s0 == 8'hFF) && (b_frac_s0 == 23'd0);              // b_inf
            special_s0[1] <= (a_exp_s0 == 8'hFF) && (a_frac_s0 != 23'd0);              // a_nan
            special_s0[0] <= (b_exp_s0 == 8'hFF) && (b_frac_s0 != 23'd0);              // b_nan

            // Add implicit leading 1 for normalized numbers, else 0 for denormals
            a_mant_s0 <= (a_exp_s0 == 8'd0) ? {1'b0, a_frac_s0} : {1'b1, a_frac_s0};
            b_mant_s0 <= (b_exp_s0 == 8'd0) ? {1'b0, b_frac_s0} : {1'b1, b_frac_s0};

            // Sign is XOR of inputs
            sign_s0 <= a_sign_s0 ^ b_sign_s0;
        end
    end

    // Stage 1: Mantissa multiplication and exponent addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 48'd0;
            exp_sum_s1 <= 9'd0;
            sign_s1 <= 1'b0;
            special_s1_flags <= 6'd0;
        end else begin
            // Early zero detect: if either input zero, product zero - can skip multiplication if desired, but here we always multiply for simplicity
            product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 multiplication = 48 bits

            // Exponent sum = a_exp + b_exp - bias
            // Add 1 bit for overflow detection
            exp_sum_s1 <= {1'b0, a_exp_s0} + {1'b0, b_exp_s0} - EXP_BIAS;

            sign_s1 <= sign_s0;

            // Propagate special cases
            special_s1_flags <= special_s0;
        end
    end

    // Stage 2: Normalization and rounding bits extraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_norm_s2 <= 9'd0;
            sign_s2 <= 1'b0;
            special_s2_flags <= 6'd0;
            mant_norm_s2 <= 24'd0;
            guard_s2 <= 1'b0; round_s2 <= 1'b0; sticky_s2 <= 1'b0;
        end else begin
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;
            special_s2_flags <= special_s1_flags;

            // Normalize product:
            // If MSB of product (bit 47) = 1, shift right by 1 and increment exponent
            if (product_s1[47]) begin
                mant_norm_s2 <= product_s1[47:24]; // top 24 bits
                exp_norm_s2 <= exp_sum_s1 + 9'd1;
                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
                // Sticky bit is OR of all bits below round bit
                sticky_s2 <= |product_s1[21:0];
            end else begin
                mant_norm_s2 <= product_s1[46:23];
                exp_norm_s2 <= exp_sum_s1;
                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];
                sticky_s2 <= |product_s1[20:0];
            end
        end
    end

    // Stage 3: Rounding and final output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mant_round_s3 <= 25'd0;
            exp_round_s3 <= 9'd0;
            sign_s3 <= 1'b0;
            special_s3_flags <= 6'd0;
            round_increment_s3 <= 1'b0;
            mant_final_s3 <= 23'd0;
            exp_final_s3 <= 8'd0;
            sign_final_s3 <= 1'b0;
            z <= 32'd0;
        end else begin
            exp_round_s3 <= exp_norm_s2;
            sign_s3 <= sign_s2;
            special_s3_flags <= special_s2_flags;

            // Round to nearest even:
            // round_increment if guard bit is 1 and (round bit or sticky bit or LSB of mantissa is 1)
            round_increment_s3 <= (guard_s2 && (round_s2 || sticky_s2 || mant_norm_s2[0]));

            if (round_increment_s3)
                mant_round_s3 <= {1'b0, mant_norm_s2} + 25'd1;
            else
                mant_round_s3 <= {1'b0, mant_norm_s2};

            // Handle mantissa overflow after rounding (carry out)
            if (mant_round_s3[24]) begin
                exp_final_s3 <= exp_round_s3[7:0] + 8'd1;
                mant_final_s3 <= mant_round_s3[24:2]; // shift right by 1, drop LSB
            end else begin
                exp_final_s3 <= exp_round_s3[7:0];
                mant_final_s3 <= mant_round_s3[22:0];
            end

            sign_final_s3 <= sign_s3;

            // Decode special case flags
            // special_s3_flags: {a_zero,b_zero,a_inf,b_inf,a_nan,b_nan}
            wire a_zero = special_s3_flags[5];
            wire b_zero = special_s3_flags[4];
            wire a_inf  = special_s3_flags[3];
            wire b_inf  = special_s3_flags[2];
            wire a_nan  = special_s3_flags[1];
            wire b_nan  = special_s3_flags[0];

            // Priority order:
            // 1) NaN: if any input NaN, output quiet NaN
            // 2) Inf * 0 = NaN
            // 3) Inf * non-zero = Inf
            // 4) zero * anything = zero
            // 5) Normal cases: handle overflow, underflow

            if (a_nan || b_nan) begin
                // Quiet NaN: exponent all ones and MSB of mantissa 1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Inf times non-zero = Inf
                z <= {sign_final_s3, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // Zero times anything = zero
                z <= {sign_final_s3, 31'd0};
            end else begin
                // Normal number
                if (exp_final_s3 >= 8'hFF) begin
                    // Overflow -> Infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 <= 0) begin
                    // Underflow -> zero flush
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    z <= {sign_final_s3, exp_final_s3, mant_final_s3};
                end
            end
        end
    end

endmodule