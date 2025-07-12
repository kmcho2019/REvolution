module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'h00;

    // Internal registers for pipeline stages
    reg [2:0] counter;

    // Stage 0: Extracted and preprocessed signals
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    // Mantissas prepared for multiplication
    reg [23:0] a_mantissa, b_mantissa;

    // Stage 1: After mantissa multiplication and exponent addition
    reg [47:0] product;     // 24x24 multiplication result
    reg [9:0] exp_sum;      // sum of exponents with bias adjustments
    reg res_sign;

    // Stage 2: Normalization and rounding inputs
    reg product_msb;
    reg [47:0] shifted_product;
    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding intermediate
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;

    // Final outputs before register
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow;
    reg exponent_underflow;
    reg [7:0] final_exponent;

    // Special cases registered from stage0
    reg a_nan_r, b_nan_r;
    reg a_inf_r, b_inf_r;
    reg a_zero_r, b_zero_r;

    // --- Pipeline Stage 0: Input extraction and preprocessing ---
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_frac <= 23'd0;
            b_frac <= 23'd0;

            a_zero <= 1'b0;
            a_denormal <= 1'b0;
            a_inf <= 1'b0;
            a_nan <= 1'b0;

            b_zero <= 1'b0;
            b_denormal <= 1'b0;
            b_inf <= 1'b0;
            b_nan <= 1'b0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;

            res_sign <= 1'b0;

            // Clear registered special cases
            a_nan_r <= 1'b0;
            b_nan_r <= 1'b0;
            a_inf_r <= 1'b0;
            b_inf_r <= 1'b0;
            a_zero_r <= 1'b0;
            b_zero_r <= 1'b0;

        end else begin
            case (counter)
                3'd0: begin
                    // Extract inputs
                    a_sign <= a[31];
                    a_exp <= a[30:23];
                    a_frac <= a[22:0];

                    b_sign <= b[31];
                    b_exp <= b[30:23];
                    b_frac <= b[22:0];

                    // Special cases detection for a
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                    // Special cases detection for b
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas for multiplication (implicit leading 1 for normal)
                    a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Compute result sign
                    res_sign <= a[31] ^ b[31];

                    // Register special cases for later stages
                    a_nan_r <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan_r <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
                    a_inf_r <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf_r <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_zero_r <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero_r <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    counter <= 3'd1;
                end

                // --- Pipeline Stage 1: Mantissa multiplication and exponent addition ---
                3'd1: begin
                    // 24x24 mantissa multiplication
                    product <= a_mantissa * b_mantissa;

                    // Adjust exponent for denormals treated as exponent=1 (instead of 0) per IEEE
                    // Extend to 10 bits to prevent overflow
                    // a_exp == 0 ? 1 : a_exp, similarly for b_exp
                    reg [9:0] a_exp_adj;
                    reg [9:0] b_exp_adj;
                    a_exp_adj = (a_exp == 0) ? 10'd1 : {2'd0, a_exp};
                    b_exp_adj = (b_exp == 0) ? 10'd1 : {2'd0, b_exp};

                    exp_sum <= a_exp_adj + b_exp_adj - EXP_BIAS;

                    counter <= 3'd2;
                end

                // --- Pipeline Stage 2: Normalization, rounding, special cases handling ---
                3'd2: begin
                    // Determine if product MSB is set (bit 47)
                    product_msb <= product[47];

                    // Shift product left by 1 if MSB=0 (to normalize)
                    shifted_product <= product_msb ? product : (product << 1);

                    // Extract normalized mantissa bits (24 bits)
                    norm_mantissa <= shifted_product[47:24];

                    // Adjust exponent depending on shift
                    norm_exponent <= product_msb ? exp_sum + 10'd1 : exp_sum;

                    // Extract rounding bits
                    guard_bit <= shifted_product[23];
                    round_bit <= shifted_product[22];
                    sticky_bit <= |shifted_product[21:0];

                    // Calculate round increment (round to nearest even)
                    round_increment <= guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);

                    // Add rounding increment
                    rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check carry from rounding
                    mantissa_carry <= rounded_mantissa_pre[24];

                    // Final mantissa and exponent adjustment after rounding
                    final_mantissa <= mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];
                    final_exponent_pre <= mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;

                    // Overflow and underflow detection
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    // Clamp exponent to 8 bits with overflow/underflow handling
                    final_exponent <= exponent_overflow ? 8'hFF :
                                      (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

                    counter <= 3'd3;
                end

                // --- Pipeline Stage 3: Final result assembly and output register write ---
                3'd3: begin
                    // Compose final IEEE-754 output with special cases handled
                    if (a_nan_r || b_nan_r) begin
                        // NaN propagation: quiet NaN with MSB=1 in mantissa
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf_r || b_inf_r) begin
                        // Inf * non-zero = Inf with correct sign
                        z <= {res_sign, 8'hFF, 23'd0};
                    end else if (a_zero_r || b_zero_r) begin
                        // Zero * anything = zero with sign
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Normal or denormal result
                        if (exponent_overflow) begin
                            // Overflow -> Inf
                            z <= {res_sign, 8'hFF, 23'd0};
                        end else if (exponent_underflow) begin
                            // Underflow -> zero
                            z <= {res_sign, 31'd0};
                        end else begin
                            // Normal result
                            z <= {res_sign, final_exponent, final_mantissa};
                        end
                    end

                    counter <= 3'd0; // Loop pipeline to accept next input
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule