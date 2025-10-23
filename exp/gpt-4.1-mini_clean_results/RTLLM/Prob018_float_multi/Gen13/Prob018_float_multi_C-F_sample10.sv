module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Cycle counter for sequencing operations (0..3)
    reg [2:0] counter;

    // Stage 0 registers: input extraction and special case detection
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;
    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;
    reg [23:0]  a_mant_s0, b_mant_s0;
    reg         sign_s0;
    reg         operand_valid_s0;

    // Stage 1 registers: multiplication and exponent addition
    reg [47:0]  product_s1;
    reg [8:0]   exp_sum_s1;   // 9 bits: sum of exponents - bias
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;
    reg         operand_valid_s1;

    // Stage 2 registers: normalization and rounding bits extraction
    reg [47:0]  product_s2;
    reg [8:0]   exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;
    reg         operand_valid_s2;
    reg [23:0]  mant_norm_s2;
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3 registers: rounding and final output assembly
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

    // Cycle control and state sequencing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
        end else begin
            counter <= (counter == 3'd3) ? 3'd0 : counter + 3'd1;
        end
    end

    // Cycle 0: Extract input fields, detect special cases, prepare mantissas
    always @(posedge clk) begin
        if (counter == 3'd0) begin
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

            // Prepare mantissa: implicit leading 1 for normal numbers, else zero-leading denormal
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            sign_s0 <= a[31] ^ b[31];

            // Valid operands: not NaN (NaNs excluded early)
            operand_valid_s0 <= ~(a_is_nan_s0 | b_is_nan_s0);
        end
    end

    // Cycle 1: Mantissa multiplication and exponent addition, carry flags forward
    always @(posedge clk) begin
        if (counter == 3'd1) begin
            a_is_zero_s1 <= a_is_zero_s0;
            b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1 <= a_is_inf_s0;
            b_is_inf_s1 <= b_is_inf_s0;
            a_is_nan_s1 <= a_is_nan_s0;
            b_is_nan_s1 <= b_is_nan_s0;
            sign_s1 <= sign_s0;
            operand_valid_s1 <= operand_valid_s0;

            if (operand_valid_s0) begin
                product_s1 <= a_mant_s0 * b_mant_s0;          // 24x24 => 48 bits
                exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS; // add exponents and subtract bias
            end else begin
                product_s1 <= 48'd0;
                exp_sum_s1 <= 9'd0;
            end
        end
    end

    // Cycle 2: Normalization and rounding bits extraction
    always @(posedge clk) begin
        if (counter == 3'd2) begin
            a_is_zero_s2 <= a_is_zero_s1;
            b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1;
            b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1;
            b_is_nan_s2 <= b_is_nan_s1;
            sign_s2 <= sign_s1;
            operand_valid_s2 <= operand_valid_s1;

            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;

            if (operand_valid_s1) begin
                if (product_s1[47]) begin
                    // MSB=1: shift right 24 bits, exponent +1
                    mant_norm_s2 <= product_s1[47:24];
                    exp_norm_s2 <= exp_sum_s1 + 9'd1;
                    guard_s2 <= product_s1[23];
                    round_s2 <= product_s1[22];
                    // Sticky is OR of bits 21 down to 0 (hierarchical OR to reduce switching)
                    sticky_s2 <= |product_s1[21:0];
                end else begin
                    // MSB=0: shift right 23 bits, exponent unchanged
                    mant_norm_s2 <= product_s1[46:23];
                    exp_norm_s2 <= exp_sum_s1;
                    guard_s2 <= product_s1[22];
                    round_s2 <= product_s1[21];
                    sticky_s2 <= |product_s1[20:0];
                end
            end else begin
                mant_norm_s2 <= 24'd0;
                guard_s2 <= 1'b0;
                round_s2 <= 1'b0;
                sticky_s2 <= 1'b0;
                exp_norm_s2 <= 9'd0;
            end
        end
    end

    // Cycle 3: Rounding and output assembly with special cases
    always @(posedge clk) begin
        if (counter == 3'd3) begin
            a_is_zero_s3 <= a_is_zero_s2;
            b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3 <= a_is_inf_s2;
            b_is_inf_s3 <= b_is_inf_s2;
            a_is_nan_s3 <= a_is_nan_s2;
            b_is_nan_s3 <= b_is_nan_s2;
            sign_s3 <= sign_s2;
            operand_valid_s3 <= operand_valid_s2;

            exp_round_s3 <= exp_norm_s2;

            // Round to nearest even:
            round_increment_s3 <= guard_s2 & (round_s2 | sticky_s2 | mant_norm_s2[0]);

            if (round_increment_s3)
                mant_round_s3 <= {1'b0, mant_norm_s2} + 25'd1;
            else
                mant_round_s3 <= {1'b0, mant_norm_s2};

            // Handle mantissa overflow from rounding
            if (mant_round_s3[24]) begin
                exp_final_s3 <= exp_round_s3[7:0] + 8'd1;
                mant_final_s3 <= mant_round_s3[24:2]; // shift right 1 to normalize
            end else begin
                exp_final_s3 <= exp_round_s3[7:0];
                mant_final_s3 <= mant_round_s3[22:0];
            end

            sign_final_s3 <= sign_s3;

            // Assemble output z with correct priority for special cases
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN (exponent all 1s, mantissa MSB 1)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s3 || b_is_inf_s3) begin
                // Inf times nonzero or Inf*Inf = Inf
                z <= {sign_final_s3, 8'hFF, 23'd0};
            end else if (a_is_zero_s3 || b_is_zero_s3) begin
                // Zero times anything = zero
                z <= {sign_final_s3, 31'd0};
            end else begin
                // Normal numbers with overflow and underflow handling
                if (exp_final_s3 >= 8'hFF) begin
                    // Overflow to infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 == 0) begin
                    // Underflow and flush to zero (no gradual denormals)
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    // Normal IEEE754 number
                    z <= {sign_final_s3, exp_final_s3, mant_final_s3};
                end
            end
        end
    end

endmodule