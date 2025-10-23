module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Stage 1 registers (input capture and special case detection)
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg a_zero_s1, b_zero_s1;
    reg a_inf_s1, b_inf_s1;
    reg a_nan_s1, b_nan_s1;
    reg [23:0] a_mantissa_s1, b_mantissa_s1;
    reg [9:0] a_exp_ext_s1, b_exp_ext_s1;
    reg z_sign_s1;
    reg valid_s1;

    // Stage 2 registers (multiplication and exponent addition)
    reg [49:0] product_s2;       // 24x24=48 bits plus 2 bits for headroom (for easier normalization)
    reg [9:0] exp_sum_s2;
    reg z_sign_s2;
    reg a_zero_s2, b_zero_s2;
    reg a_inf_s2, b_inf_s2;
    reg a_nan_s2, b_nan_s2;
    reg valid_s2;

    // Stage 3 registers (normalization, rounding, final formatting)
    reg [31:0] z_next;
    reg valid_s3;

    // --- Stage 1: input processing ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s1    <= 1'b0;
            b_sign_s1    <= 1'b0;
            a_exp_s1     <= 8'd0;
            b_exp_s1     <= 8'd0;
            a_frac_s1    <= 23'd0;
            b_frac_s1    <= 23'd0;
            a_zero_s1    <= 1'b0;
            b_zero_s1    <= 1'b0;
            a_inf_s1     <= 1'b0;
            b_inf_s1     <= 1'b0;
            a_nan_s1     <= 1'b0;
            b_nan_s1     <= 1'b0;
            a_mantissa_s1 <= 24'd0;
            b_mantissa_s1 <= 24'd0;
            a_exp_ext_s1  <= 10'd0;
            b_exp_ext_s1  <= 10'd0;
            z_sign_s1     <= 1'b0;
            valid_s1      <= 1'b0;
        end else begin
            // Extract fields
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exp_s1  <= a[30:23];
            b_exp_s1  <= b[30:23];
            a_frac_s1 <= a[22:0];
            b_frac_s1 <= b[22:0];

            // Detect special cases
            a_zero_s1 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_zero_s1 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            a_inf_s1  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_inf_s1  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            a_nan_s1  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_nan_s1  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Prepare mantissas: normalized = implicit 1, denormal = implicit 0
            a_mantissa_s1 <= (a_exp_s1 == 8'd0) ? {1'b0, a_frac_s1} : {1'b1, a_frac_s1};
            b_mantissa_s1 <= (b_exp_s1 == 8'd0) ? {1'b0, b_frac_s1} : {1'b1, b_frac_s1};

            // Exponent extended: denormals exponent 1, else real exponent
            a_exp_ext_s1 <= (a_exp_s1 == 8'd0) ? 10'd1 : {2'b00, a_exp_s1};
            b_exp_ext_s1 <= (b_exp_s1 == 8'd0) ? 10'd1 : {2'b00, b_exp_s1};

            // Sign of output
            z_sign_s1 <= a[31] ^ b[31];

            valid_s1 <= 1'b1;  // Input valid every cycle
        end
    end

    // --- Stage 2: multiply mantissas and add exponents ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 50'd0;
            exp_sum_s2 <= 10'd0;
            z_sign_s2  <= 1'b0;
            a_zero_s2  <= 1'b0;
            b_zero_s2  <= 1'b0;
            a_inf_s2   <= 1'b0;
            b_inf_s2   <= 1'b0;
            a_nan_s2   <= 1'b0;
            b_nan_s2   <= 1'b0;
            valid_s2   <= 1'b0;
        end else begin
            product_s2 <= a_mantissa_s1 * b_mantissa_s1; // 24x24=48 bits product stored in lower bits of 50-bit reg
            // Add exponents and subtract bias (127)
            exp_sum_s2 <= a_exp_ext_s1 + b_exp_ext_s1 - EXP_BIAS;
            z_sign_s2  <= z_sign_s1;

            a_zero_s2  <= a_zero_s1;
            b_zero_s2  <= b_zero_s1;
            a_inf_s2   <= a_inf_s1;
            b_inf_s2   <= b_inf_s1;
            a_nan_s2   <= a_nan_s1;
            b_nan_s2   <= b_nan_s1;

            valid_s2   <= valid_s1;
        end
    end

    // --- Stage 3: normalize, round, handle special cases and output ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
            z_next <= 32'd0;
            valid_s3 <= 1'b0;
        end else begin
            valid_s3 <= valid_s2;

            if (!valid_s2) begin
                z <= 32'd0;
            end else begin
                // Unpack signals
                // product_s2 is 50 bits, product[47:0] used by original code; extra bits for safety
                wire product_msb = product_s2[47];
                wire [23:0] mantissa_norm = product_msb ? product_s2[47:24] : product_s2[46:23];
                wire [9:0] exponent_norm = product_msb ? (exp_sum_s2 + 10'd1) : exp_sum_s2;
                wire guard_bit = product_msb ? product_s2[23] : product_s2[22];
                wire round_bit = product_msb ? product_s2[22] : product_s2[21];
                wire sticky_bit = product_msb ? |product_s2[21:0] : |product_s2[20:0];

                // Round to nearest even
                wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_norm[0]);
                wire [24:0] mantissa_rounded_pre = {1'b0, mantissa_norm} + round_increment;
                wire mantissa_overflow = mantissa_rounded_pre[24];

                wire [7:0] final_exp_no_overflow = exponent_norm[7:0];
                wire [7:0] final_exp = mantissa_overflow ? (final_exp_no_overflow + 8'd1) : final_exp_no_overflow;
                wire [22:0] final_frac = mantissa_overflow ? mantissa_rounded_pre[24:2] : mantissa_rounded_pre[22:0];

                // Special case flags
                wire any_nan = a_nan_s2 || b_nan_s2;
                wire inf_zero = (a_inf_s2 && b_zero_s2) || (b_inf_s2 && a_zero_s2);
                wire any_inf = a_inf_s2 || b_inf_s2;
                wire any_zero = a_zero_s2 || b_zero_s2;

                if (any_nan) begin
                    // Quiet NaN (set MSB of mantissa)
                    z_next <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (inf_zero) begin
                    // Inf * 0 = NaN
                    z_next <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (any_inf) begin
                    // Inf * non-zero = Inf
                    z_next <= {z_sign_s2, 8'hFF, 23'd0};
                end else if (any_zero) begin
                    // Zero * anything = zero
                    z_next <= {z_sign_s2, 31'd0};
                end else begin
                    // Normal result with overflow and underflow handling
                    if (final_exp >= 8'hFF) begin
                        // Overflow to infinity
                        z_next <= {z_sign_s2, 8'hFF, 23'd0};
                    end else if (final_exp <= 0) begin
                        // Underflow flush to zero (no subnormals)
                        z_next <= {z_sign_s2, 31'd0};
                    end else begin
                        // Normal number
                        z_next <= {z_sign_s2, final_exp, final_frac};
                    end
                end
                z <= z_next;
            end
        end
    end
endmodule