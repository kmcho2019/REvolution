module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Stage 0: Input extraction and special cases
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;
    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;
    reg [23:0]  a_mant_s0, b_mant_s0;
    reg         sign_s0;
    reg         operand_valid_s0; // Indicates if both operands are normal/denorm or special

    // Stage 1: Mantissa multiplication and exponent addition
    reg [47:0]  product_s1;
    reg [8:0]   exp_sum_s1;   // 9 bits sufficient for exponent sum: max 255+255-127=383 fits in 9 bits
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;
    reg         operand_valid_s1;

    // Stage 2: Normalization and rounding bits extraction
    reg [47:0]  product_s2;
    reg [8:0]   exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;
    reg         operand_valid_s2;

    reg [23:0]  mant_norm_s2;
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3: Rounding and output assembly
    reg [24:0]  mant_round_s3;
    reg [8:0]   exp_round_s3;
    reg         sign_s3;
    reg         a_is_zero_s3, b_is_zero_s3;
    reg         a_is_inf_s3,  b_is_inf_s3;
    reg         a_is_nan_s3,  b_is_nan_s3;
    reg         operand_valid_s3;

    reg         round_increment_s3;
    reg [22:0]  mant_final_s3;
    reg [7:0]   exp_final_s3;
    reg         sign_final_s3;

    // Stage 0: Extract fields and detect special cases
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
            operand_valid_s0 <= 0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];
            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];
            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 0);
            b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 0);

            a_is_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
            b_is_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

            a_is_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
            b_is_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

            // Prepare mantissas with implicit leading one for normal numbers, zero for denormals
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            sign_s0 <= a[31] ^ b[31];

            // Determine if both operands are valid for multiplication (normal or denorm or special but not NaN)
            operand_valid_s0 <= ~ (a_is_nan_s0 | b_is_nan_s0);
        end
    end

    // Stage 1: Multiply mantissas only if operands valid (to reduce switching)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 48'd0;
            exp_sum_s1 <= 9'd0;
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

            // Gating multiplication to avoid switching if invalid operands
            if (operand_valid_s0) begin
                product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 -> 48 bits
                exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS; // exponent add + bias subtraction
            end else begin
                product_s1 <= 48'd0;
                exp_sum_s1 <= 9'd0;
            end
        end
    end

    // Stage 2: Normalize mantissa product and extract rounding bits
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_norm_s2 <= 9'd0;
            sign_s2 <= 0;
            a_is_zero_s2 <= 0; b_is_zero_s2 <= 0;
            a_is_inf_s2 <= 0; b_is_inf_s2 <= 0;
            a_is_nan_s2 <= 0; b_is_nan_s2 <= 0;
            operand_valid_s2 <= 0;
            mant_norm_s2 <= 24'd0;
            guard_s2 <= 0; round_s2 <= 0; sticky_s2 <= 0;
        end else begin
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;
            a_is_zero_s2 <= a_is_zero_s1; b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1; b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1; b_is_nan_s2 <= b_is_nan_s1;
            operand_valid_s2 <= operand_valid_s1;

            // Normalize product:
            // If MSB (bit 47) == 1 => shift right 1, increment exponent
            if (operand_valid_s1 && product_s1[47]) begin
                mant_norm_s2 <= product_s1[47:24]; // 24 bits mantissa including leading one
                exp_norm_s2 <= exp_sum_s1 + 9'd1;

                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];

                // Sticky bit: OR reduction of bits 0 to 21 inclusive
                // Use hierarchical OR to reduce switching and improve timing
                sticky_s2 <= |product_s1[21:0];
            end else if (operand_valid_s1) begin
                mant_norm_s2 <= product_s1[46:23];
                exp_norm_s2 <= exp_sum_s1;

                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];

                sticky_s2 <= |product_s1[20:0];
            end else begin
                mant_norm_s2 <= 24'd0;
                guard_s2 <= 0; round_s2 <= 0; sticky_s2 <= 0;
                exp_norm_s2 <= 9'd0;
            end
        end
    end

    // Stage 3: Rounding and final output assembly with special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mant_round_s3 <= 25'd0;
            exp_round_s3 <= 9'd0;
            sign_s3 <= 0;
            a_is_zero_s3 <= 0; b_is_zero_s3 <= 0;
            a_is_inf_s3 <= 0; b_is_inf_s3 <= 0;
            a_is_nan_s3 <= 0; b_is_nan_s3 <= 0;
            operand_valid_s3 <= 0;
            round_increment_s3 <= 0;
            mant_final_s3 <= 23'd0;
            exp_final_s3 <= 8'd0;
            sign_final_s3 <= 0;
            z <= 32'd0;
        end else begin
            exp_round_s3 <= exp_norm_s2;
            sign_s3 <= sign_s2;
            a_is_zero_s3 <= a_is_zero_s2; b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3 <= a_is_inf_s2; b_is_inf_s3 <= b_is_inf_s2;
            a_is_nan_s3 <= a_is_nan_s2; b_is_nan_s3 <= b_is_nan_s2;
            operand_valid_s3 <= operand_valid_s2;

            // Round to nearest even:
            // increment if guard bit is 1 and (round bit or sticky bit or LSB is 1)
            round_increment_s3 <= guard_s2 & (round_s2 | sticky_s2 | mant_norm_s2[0]);

            if (round_increment_s3)
                mant_round_s3 <= {1'b0, mant_norm_s2} + 25'd1;
            else
                mant_round_s3 <= {1'b0, mant_norm_s2};

            // Handle mantissa overflow from rounding (carry out)
            if (mant_round_s3[24]) begin
                exp_final_s3 <= exp_round_s3[7:0] + 8'd1;
                mant_final_s3 <= mant_round_s3[24:2]; // shift right 1, drop LSB
            end else begin
                exp_final_s3 <= exp_round_s3[7:0];
                mant_final_s3 <= mant_round_s3[22:0];
            end

            sign_final_s3 <= sign_s3;

            // Output generation with priority for special cases
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN: sign=0, exp=all 1s, MSB mantissa=1 for quiet NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s3 || b_is_inf_s3) begin
                // Inf times non-zero or Inf times Inf = Inf
                z <= {sign_final_s3, 8'hFF, 23'd0};
            end else if (a_is_zero_s3 || b_is_zero_s3) begin
                // Zero times anything = Zero
                z <= {sign_final_s3, 31'd0};
            end else begin
                // Normal numbers: handle overflow, underflow, and normal output
                if (exp_final_s3 >= 8'hFF) begin
                    // Overflow: set to infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 <= 0) begin
                    // Underflow: flush to zero (no gradual underflow handling)
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    // Normal number output
                    z <= {sign_final_s3, exp_final_s3, mant_final_s3};
                end
            end
        end
    end

endmodule