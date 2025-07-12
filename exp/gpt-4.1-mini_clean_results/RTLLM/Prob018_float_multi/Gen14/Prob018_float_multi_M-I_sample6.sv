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
    reg         operand_valid_s0; // Indicates operands valid for multiplication

    // Stage 1: Mantissa multiplication and exponent addition
    reg [47:0]  product_s1;       // 24x24 bits product
    reg [8:0]   exp_sum_s1;       // 9 bits exponent sum (max 383)
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;
    reg         operand_valid_s1;

    // Stage 2: Normalization, rounding bit extraction
    reg [47:0]  product_s2;
    reg [8:0]   exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;
    reg         operand_valid_s2;

    reg [23:0]  mant_norm_s2;
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3: Rounding and final output assembly
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

    // Sticky bit hierarchical OR function for 22 bits
    function sticky_or22;
        input [21:0] bits;
        reg [5:0] or_level1; // 22 bits reduced to 6 bits
        reg [1:0] or_level2; // 6 bits to 2 bits
        reg or_level3;
    begin
        or_level1[0] = |bits[3:0];      // 4 bits
        or_level1[1] = |bits[7:4];      // 4 bits
        or_level1[2] = |bits[11:8];     // 4 bits
        or_level1[3] = |bits[15:12];    // 4 bits
        or_level1[4] = |bits[19:16];    // 4 bits
        or_level1[5] = |bits[21:20];    // 2 bits

        or_level2[0] = |or_level1[2:0]; // or of 3 bits
        or_level2[1] = |or_level1[5:3]; // or of 3 bits

        or_level3 = |or_level2;          // or of 2 bits

        sticky_or22 = or_level3;
    end
    endfunction

    // Stage 0: Extract fields and detect special cases; operand gating included
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

            // Operand valid if neither input is NaN (other cases handled later)
            operand_valid_s0 <= ~ (a_is_nan_s0 | b_is_nan_s0);
        end
    end

    // Stage 1: Mantissa multiply and exponent add with operand gating
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

            if (operand_valid_s0) begin
                product_s1 <= a_mant_s0 * b_mant_s0; // 24x24=48 bits
                exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS;
            end else begin
                product_s1 <= 48'd0;
                exp_sum_s1 <= 9'd0;
            end
        end
    end

    // Stage 2: Normalization and rounding bits extraction
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

            if (operand_valid_s1) begin
                if (product_s1[47]) begin
                    // MSB set, shift right 1, increment exponent
                    mant_norm_s2 <= product_s1[47:24]; // top 24 bits including leading 1
                    exp_norm_s2 <= exp_sum_s1 + 9'd1;

                    guard_s2 <= product_s1[23];
                    round_s2 <= product_s1[22];
                    sticky_s2 <= sticky_or22(product_s1[21:0]);
                end else begin
                    mant_norm_s2 <= product_s1[46:23];
                    exp_norm_s2 <= exp_sum_s1;

                    guard_s2 <= product_s1[22];
                    round_s2 <= product_s1[21];
                    sticky_s2 <= sticky_or22(product_s1[20:0]);
                end
            end else begin
                mant_norm_s2 <= 24'd0;
                guard_s2 <= 0; round_s2 <= 0; sticky_s2 <= 0;
                exp_norm_s2 <= 9'd0;
            end
        end
    end

    // Stage 3: Rounding and output assembly with special cases and overflow/underflow handling
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

            // Round to nearest even (tie to even)
            round_increment_s3 <= guard_s2 & (round_s2 | sticky_s2 | mant_norm_s2[0]);

            if (round_increment_s3)
                mant_round_s3 <= {1'b0, mant_norm_s2} + 25'd1;
            else
                mant_round_s3 <= {1'b0, mant_norm_s2};

            // Handle mantissa overflow after rounding
            if (mant_round_s3[24]) begin
                // Mantissa overflowed (25 bits), shift right by 1 and increment exponent
                exp_final_s3 <= exp_round_s3[7:0] + 8'd1;
                mant_final_s3 <= mant_round_s3[24:2]; // drop 1 LSB after shift
            end else begin
                exp_final_s3 <= exp_round_s3[7:0];
                mant_final_s3 <= mant_round_s3[22:0];
            end

            sign_final_s3 <= sign_s3;

            // Output generation considering special cases with priority
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN (sign=0, exp=all 1s, MSB mantissa=1)
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
                // Normal numbers: check overflow and underflow
                if (exp_final_s3 >= 8'hFF) begin
                    // Overflow: set to infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 <= 0) begin
                    // Underflow: flush to zero (no gradual underflow)
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    // Normalized result
                    z <= {sign_final_s3, exp_final_s3, mant_final_s3};
                end
            end
        end
    end

endmodule