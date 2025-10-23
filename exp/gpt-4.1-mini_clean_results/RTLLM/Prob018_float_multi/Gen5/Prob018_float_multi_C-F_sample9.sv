module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // --- Stage 0: Input decode and special cases detection ---
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;

    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;

    reg [23:0]  a_mant_s0, b_mant_s0;  // Mantissa with implicit leading bit
    reg         sign_s0;

    // --- Stage 1: Mantissa multiply and exponent addition ---
    reg [47:0]  product_s1;     // 24x24 multiplication result (48 bits)
    reg [9:0]   exp_sum_s1;     // exponent sum with extra bits to handle overflow
    reg         sign_s1;

    // Propagated flags
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;

    // --- Stage 2: Normalization and rounding bits extraction ---
    reg [47:0]  product_s2;
    reg [9:0]   exp_norm_s2;
    reg         sign_s2;

    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;

    reg [23:0]  mant_norm_s2;  // Normalized mantissa including leading 1
    reg         guard_s2, round_s2, sticky_s2; // Rounding bits

    // --- Combinational rounding logic before Stage 3 ---
    reg         round_increment;
    reg [24:0]  mant_rounded;  // 25-bit mantissa (to detect overflow)
    reg [7:0]   final_exp;
    reg         final_sign;
    reg [22:0]  final_mant;

    // --- Stage 3: Output assemble and special case handling ---
    reg         sign_s3;
    reg [9:0]   exp_s3;
    reg [23:0]  mant_s3;

    reg         a_is_zero_s3, b_is_zero_s3;
    reg         a_is_inf_s3,  b_is_inf_s3;
    reg         a_is_nan_s3,  b_is_nan_s3;

    // Stage 0: decode inputs and special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0; b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;

            a_is_zero_s0 <= 1'b0; b_is_zero_s0 <= 1'b0;
            a_is_inf_s0 <= 1'b0;  b_is_inf_s0 <= 1'b0;
            a_is_nan_s0 <= 1'b0;  b_is_nan_s0 <= 1'b0;

            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;
            sign_s0 <= 1'b0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];

            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];

            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            // Detect special cases for input a
            a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            a_is_inf_s0  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            a_is_nan_s0  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

            // Detect special cases for input b
            b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            b_is_inf_s0  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            b_is_nan_s0  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Construct mantissas with implicit leading 1 for normalized numbers, else zero
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            sign_s0 <= a[31] ^ b[31];
        end
    end

    // Stage 1: multiply mantissas and add exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 48'd0;
            exp_sum_s1 <= 10'd0;
            sign_s1 <= 1'b0;

            a_is_zero_s1 <= 1'b0; b_is_zero_s1 <= 1'b0;
            a_is_inf_s1 <= 1'b0;  b_is_inf_s1 <= 1'b0;
            a_is_nan_s1 <= 1'b0;  b_is_nan_s1 <= 1'b0;
        end else begin
            product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 multiply => 48 bits

            // Exponent sum with bias correction
            exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS;

            sign_s1 <= sign_s0;

            // Propagate special-case flags
            a_is_zero_s1 <= a_is_zero_s0; b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1 <= a_is_inf_s0;   b_is_inf_s1 <= b_is_inf_s0;
            a_is_nan_s1 <= a_is_nan_s0;   b_is_nan_s1 <= b_is_nan_s0;
        end
    end

    // Stage 2: normalization and rounding bits extraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_norm_s2 <= 10'd0;
            sign_s2 <= 1'b0;

            a_is_zero_s2 <= 1'b0; b_is_zero_s2 <= 1'b0;
            a_is_inf_s2 <= 1'b0;  b_is_inf_s2 <= 1'b0;
            a_is_nan_s2 <= 1'b0;  b_is_nan_s2 <= 1'b0;

            mant_norm_s2 <= 24'd0;
            guard_s2 <= 1'b0; round_s2 <= 1'b0; sticky_s2 <= 1'b0;
        end else begin
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;

            a_is_zero_s2 <= a_is_zero_s1; b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1;   b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1;   b_is_nan_s2 <= b_is_nan_s1;

            // Normalize product:
            // If MSB (bit 47) is 1 => product >= 2 => shift right by 1 and increment exponent
            if (product_s1[47]) begin
                // Shift right 1: mantissa = bits [47:24], rounding bits from [23:0]
                mant_norm_s2 <= product_s1[47:24]; // 24 bits with leading 1 explicit
                exp_norm_s2 <= exp_sum_s1 + 10'd1;

                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
                sticky_s2 <= |product_s1[21:0];
            end else begin
                // No shift: mantissa = bits [46:23], rounding bits shifted accordingly
                mant_norm_s2 <= product_s1[46:23];
                exp_norm_s2 <= exp_sum_s1;

                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];
                sticky_s2 <= |product_s1[20:0];
            end
        end
    end

    // Combinational rounding logic before Stage 3
    always @(*) begin
        // Round to nearest even:
        // round_increment = guard && (round || sticky || LSB mantissa == 1)
        round_increment = guard_s2 && (round_s2 || sticky_s2 || mant_norm_s2[0]);

        if (round_increment)
            mant_rounded = {1'b0, mant_norm_s2} + 25'd1; // add rounding increment
        else
            mant_rounded = {1'b0, mant_norm_s2};

        // Check mantissa overflow from rounding (carry out bit 24)
        if (mant_rounded[24]) begin
            final_exp  = exp_norm_s2[7:0] + 8'd1;   // increment exponent
            final_mant = mant_rounded[24:2];        // shift right 1 dropping LSB
        end else begin
            final_exp  = exp_norm_s2[7:0];
            final_mant = mant_rounded[22:0];
        end

        final_sign = sign_s2;
    end

    // Stage 3: Output assembly and special case handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_s3 <= 1'b0;
            exp_s3 <= 10'd0;
            mant_s3 <= 24'd0;

            a_is_zero_s3 <= 1'b0; b_is_zero_s3 <= 1'b0;
            a_is_inf_s3 <= 1'b0;  b_is_inf_s3 <= 1'b0;
            a_is_nan_s3 <= 1'b0;  b_is_nan_s3 <= 1'b0;

            z <= 32'd0;
        end else begin
            sign_s3 <= final_sign;
            exp_s3 <= {2'b00, final_exp}; // zero-extend to 10 bits
            mant_s3 <= {1'b0, final_mant}; // store mantissa with explicit leading bit zero (not used)

            a_is_zero_s3 <= a_is_zero_s2;
            b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3  <= a_is_inf_s2;
            b_is_inf_s3  <= b_is_inf_s2;
            a_is_nan_s3  <= a_is_nan_s2;
            b_is_nan_s3  <= b_is_nan_s2;

            // Special cases output:
            // Priority:
            // 1) NaN: if either input is NaN -> output quiet NaN (exponent=0xFF, mantissa MSB=1)
            if (a_is_nan_s3 || b_is_nan_s3) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
            end
            // 2) Inf * 0 = NaN
            else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
            end
            // 3) Inf * non-zero = Inf (sign accordingly)
            else if (a_is_inf_s3 || b_is_inf_s3) begin
                z <= {sign_s3, 8'hFF, 23'd0};
            end
            // 4) Zero * anything = zero (sign accordingly)
            else if (a_is_zero_s3 || b_is_zero_s3) begin
                z <= {sign_s3, 31'd0};
            end
            // 5) Normalized numbers with exponent overflow/underflow handling
            else begin
                if (final_exp >= 8'hFF) begin
                    // Overflow: output infinity
                    z <= {sign_s3, 8'hFF, 23'd0};
                end else if (final_exp <= 0) begin
                    // Underflow: output zero (flush to zero)
                    z <= {sign_s3, 31'd0};
                end else begin
                    // Normal number: sign | exponent | mantissa (exclude leading 1)
                    z <= {sign_s3, final_exp, final_mant};
                end
            end
        end
    end

endmodule