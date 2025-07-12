module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Stage 0 registers: input extraction and special cases detection
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;

    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;

    reg [23:0]  a_mant_s0, b_mant_s0; // mantissas with implicit leading bit
    reg         sign_s0;

    // Stage 1 registers: multiply mantissas, exponent add, sign calc
    reg [47:0]  product_s1;
    reg [9:0]   exp_sum_s1;       // wider for intermediate exponent sum
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;

    // Stage 2 registers: normalization and rounding bit extraction
    reg [47:0]  product_s2;
    reg [9:0]   exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;

    reg [23:0]  mant_norm_s2; // 24-bit mantissa including leading one
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3 registers: output generation
    reg [23:0]  mant_round_s3;
    reg [9:0]   exp_round_s3;
    reg         sign_s3;
    reg         a_is_zero_s3, b_is_zero_s3;
    reg         a_is_inf_s3,  b_is_inf_s3;
    reg         a_is_nan_s3,  b_is_nan_s3;

    // Intermediate registers for rounding calculation at module level
    reg [24:0] mant_rounded;   // 25 bits for overflow detection
    reg [7:0]  final_exp;
    reg        final_sign;
    reg [22:0] final_mant;

    // Stage 0: Input decode, extract sign, exponent, fraction; detect special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0; b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;
            a_is_zero_s0 <= 0; b_is_zero_s0 <= 0;
            a_is_inf_s0 <= 0; b_is_inf_s0 <= 0;
            a_is_nan_s0 <= 0; b_is_nan_s0 <= 0;
            a_mant_s0 <= 0; b_mant_s0 <= 0;
            sign_s0 <= 0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];
            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];
            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            // Zero detection: exponent=0 & fraction=0
            a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            // Infinity detection: exponent=all 1's & fraction=0
            a_is_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_is_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            // NaN detection: exponent=all 1's & fraction!=0
            a_is_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_is_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Mantissa with implicit leading bit for normalized numbers, else zero for denormals
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Output sign: XOR of input signs
            sign_s0 <= a[31] ^ b[31];
        end
    end

    // Stage 1: Multiply mantissas, add exponents minus bias, propagate sign and flags
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 0;
            exp_sum_s1 <= 0;
            sign_s1 <= 0;
            a_is_zero_s1 <= 0; b_is_zero_s1 <= 0;
            a_is_inf_s1 <= 0; b_is_inf_s1 <= 0;
            a_is_nan_s1 <= 0; b_is_nan_s1 <= 0;
        end else begin
            product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 multiplication = 48 bits

            exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS;

            sign_s1 <= sign_s0;

            // Propagate special case flags
            a_is_zero_s1 <= a_is_zero_s0;
            b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1 <= a_is_inf_s0;
            b_is_inf_s1 <= b_is_inf_s0;
            a_is_nan_s1 <= a_is_nan_s0;
            b_is_nan_s1 <= b_is_nan_s0;
        end
    end

    // Stage 2: Normalize product mantissa and extract rounding bits (guard, round, sticky)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 0;
            exp_norm_s2 <= 0;
            sign_s2 <= 0;
            a_is_zero_s2 <= 0; b_is_zero_s2 <= 0;
            a_is_inf_s2 <= 0; b_is_inf_s2 <= 0;
            a_is_nan_s2 <= 0; b_is_nan_s2 <= 0;
            mant_norm_s2 <= 0;
            guard_s2 <= 0;
            round_s2 <= 0;
            sticky_s2 <= 0;
        end else begin
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;

            a_is_zero_s2 <= a_is_zero_s1;
            b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1;
            b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1;
            b_is_nan_s2 <= b_is_nan_s1;

            // Normalization: if MSB of product is 1 (bit 47), shift right by 1 and increment exponent
            if (product_s1[47]) begin
                mant_norm_s2 <= product_s1[47:24]; // top 24 bits including leading 1
                exp_norm_s2 <= exp_sum_s1 + 10'd1;
                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
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

    // Combinational rounding logic (round to nearest even)
    always @(*) begin
        // Round increment if guard bit set and (round or sticky set or LSB of mantissa is 1)
        if (guard_s2 && (round_s2 || sticky_s2 || mant_norm_s2[0]))
            mant_rounded = {1'b0, mant_norm_s2} + 25'd1;
        else
            mant_rounded = {1'b0, mant_norm_s2};

        // If overflow in mantissa after rounding, shift right once and increment exponent
        if (mant_rounded[24]) begin
            final_exp = exp_norm_s2[7:0] + 8'd1;
            final_mant = mant_rounded[24:2];  // shift right 1 dropping LSB after increment
        end else begin
            final_exp = exp_norm_s2[7:0];
            final_mant = mant_rounded[22:0];
        end

        final_sign = sign_s2;
    end

    // Stage 3: Final output formatting with special cases handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mant_round_s3 <= 0;
            exp_round_s3 <= 0;
            sign_s3 <= 0;
            a_is_zero_s3 <= 0; b_is_zero_s3 <= 0;
            a_is_inf_s3 <= 0; b_is_inf_s3 <= 0;
            a_is_nan_s3 <= 0; b_is_nan_s3 <= 0;
            z <= 32'd0;
        end else begin
            mant_round_s3 <= mant_norm_s2; // for debug or future use
            exp_round_s3 <= exp_norm_s2;
            sign_s3 <= sign_s2;

            a_is_zero_s3 <= a_is_zero_s2;
            b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3 <= a_is_inf_s2;
            b_is_inf_s3 <= b_is_inf_s2;
            a_is_nan_s3 <= a_is_nan_s2;
            b_is_nan_s3 <= b_is_nan_s2;

            // Special cases output priority:
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN: sign=0, exponent all ones, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s3 || b_is_inf_s3) begin
                // Inf times non-zero = Inf
                z <= {final_sign, 8'hFF, 23'd0};
            end else if (a_is_zero_s3 || b_is_zero_s3) begin
                // Zero times anything = Zero
                z <= {final_sign, 31'd0};
            end else begin
                // Normal case: check for exponent overflow and underflow
                if (final_exp >= 8'hFF) begin
                    // Overflow to Infinity
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (final_exp <= 0) begin
                    // Underflow flush to zero
                    z <= {final_sign, 31'd0};
                end else begin
                    // Normalized output
                    z <= {final_sign, final_exp, final_mant};
                end
            end
        end
    end

endmodule