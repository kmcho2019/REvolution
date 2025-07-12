module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // --- Stage 1: Input extraction and special case detection ---

    // Extract fields from inputs (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];

    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];

    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detections for inputs (combinational)
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Pipeline registers between stage 1 and stage 2
    reg s1_sign;
    reg [7:0] s1_exp_a, s1_exp_b;
    reg [23:0] s1_mant_a, s1_mant_b;
    reg s1_a_zero, s1_b_zero;
    reg s1_a_inf, s1_b_inf;
    reg s1_a_nan, s1_b_nan;

    // Constants
    localparam EXP_BIAS = 127;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_sign   <= 1'b0;
            s1_exp_a  <= 8'd0;
            s1_exp_b  <= 8'd0;
            s1_mant_a <= 24'd0;
            s1_mant_b <= 24'd0;
            s1_a_zero <= 1'b0;
            s1_b_zero <= 1'b0;
            s1_a_inf  <= 1'b0;
            s1_b_inf  <= 1'b0;
            s1_a_nan  <= 1'b0;
            s1_b_nan  <= 1'b0;
        end else begin
            // Sign of result is XOR of input signs
            s1_sign <= a_sign ^ b_sign;

            // Pass input exponents
            s1_exp_a <= a_exp;
            s1_exp_b <= b_exp;

            // Prepare mantissas with implicit leading 1 if normalized, else keep denormal
            s1_mant_a <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            s1_mant_b <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Pass special cases
            s1_a_zero <= a_is_zero;
            s1_b_zero <= b_is_zero;

            s1_a_inf <= a_is_inf;
            s1_b_inf <= b_is_inf;

            s1_a_nan <= a_is_nan;
            s1_b_nan <= b_is_nan;
        end
    end

    // --- Stage 2: Multiply mantissas and normalize ---

    // Multiply mantissas: 24x24 -> 48-bit product
    reg [47:0] mantissa_product;
    reg [9:0]  exp_sum;   // 10 bits to hold exponent addition and bias subtraction

    // Pipeline registers between stage 2 and stage 3
    reg [47:0] s2_product;
    reg [9:0]  s2_exponent;
    reg        s2_sign;
    reg        s2_a_zero, s2_b_zero;
    reg        s2_a_inf, s2_b_inf;
    reg        s2_a_nan, s2_b_nan;

    // Normalized mantissa and adjusted exponent after normalization
    reg [23:0] s2_norm_mantissa;
    reg [9:0]  s2_norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mantissa_product <= 48'd0;
            exp_sum          <= 10'd0;

            s2_product       <= 48'd0;
            s2_exponent      <= 10'd0;
            s2_sign          <= 1'b0;

            s2_a_zero <= 1'b0;
            s2_b_zero <= 1'b0;
            s2_a_inf  <= 1'b0;
            s2_b_inf  <= 1'b0;
            s2_a_nan  <= 1'b0;
            s2_b_nan  <= 1'b0;

            s2_norm_mantissa <= 24'd0;
            s2_norm_exponent <= 10'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
        end else begin
            // Multiply mantissas (24x24) at this stage
            mantissa_product <= s1_mant_a * s1_mant_b;

            // Add exponents and subtract bias: exponent_r = a_exp + b_exp - bias
            // Use 10-bit width to catch overflow
            exp_sum <= s1_exp_a + s1_exp_b - EXP_BIAS;

            // Pass along special cases and sign
            s2_sign     <= s1_sign;
            s2_a_zero   <= s1_a_zero;
            s2_b_zero   <= s1_b_zero;
            s2_a_inf    <= s1_a_inf;
            s2_b_inf    <= s1_b_inf;
            s2_a_nan    <= s1_a_nan;
            s2_b_nan    <= s1_b_nan;

            // Latch product and exponent for normalization
            s2_product  <= mantissa_product;
            s2_exponent <= exp_sum;

            // Normalization:
            // If MSB of mantissa_product (bit 47) == 1, shift right by 1 and increment exponent
            // Else keep as is.

            if (mantissa_product[47] == 1'b1) begin
                s2_norm_mantissa <= mantissa_product[47:24]; // top 24 bits after shift right by 1
                s2_norm_exponent <= exp_sum + 10'd1;
            end else begin
                s2_norm_mantissa <= mantissa_product[46:23]; // top 24 bits, no shift
                s2_norm_exponent <= exp_sum;
            end

            // Extract rounding bits from lower bits of mantissa_product
            // guard = bit 23 (bit shifted accordingly), round = bit 22, sticky = OR of bits below 22
            if (mantissa_product[47] == 1'b1) begin
                // shifted right by 1 -> guard is bit 23, round bit 22, sticky bits 21:0 of mantissa_product >> 1 = bits 22:1 original
                guard_bit = mantissa_product[23];
                round_bit = mantissa_product[22];
                sticky_bit = |mantissa_product[21:0];
            end else begin
                // no shift: guard bit 23, round bit 22, sticky bits 21:0
                guard_bit = mantissa_product[22];
                round_bit = mantissa_product[21];
                sticky_bit = |mantissa_product[20:0];
            end
        end
    end

    // --- Stage 3: Rounding, exponent adjustment, special case handling, and output ---

    reg [31:0] z_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_reg <= 32'd0;
        end else begin
            // Start with default assignments
            reg [23:0] mantissa_rounded;
            reg [9:0] exponent_final;
            reg sign_final;

            sign_final = s2_sign;
            mantissa_rounded = s2_norm_mantissa;
            exponent_final = s2_norm_exponent;

            // Round to nearest even
            // Conditions for rounding up:
            // If guard bit == 1 and (round bit == 1 or sticky bit == 1 or LSB of mantissa_rounded == 1), increment mantissa
            if (guard_bit) begin
                if (round_bit | sticky_bit | mantissa_rounded[0]) begin
                    reg [24:0] mantissa_inc;
                    mantissa_inc = {1'b0, mantissa_rounded} + 25'd1;
                    if (mantissa_inc[24]) begin
                        // Mantissa overflow, shift right by 1 and increment exponent
                        mantissa_rounded = mantissa_inc[24:1];
                        exponent_final = exponent_final + 10'd1;
                    end else begin
                        mantissa_rounded = mantissa_inc[23:0];
                    end
                end
            end

            // Handle special cases from inputs first (NaN and Inf, zeros)

            // NaN propagation: if either input is NaN, output quiet NaN (exponent 0xFF, mantissa MSB=1)
            if (s2_a_nan || s2_b_nan) begin
                z_reg <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((s2_a_inf && s2_b_zero) || (s2_b_inf && s2_a_zero)) begin
                // Inf * 0 = NaN
                z_reg <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (s2_a_inf || s2_b_inf) begin
                // Inf times nonzero = Inf
                z_reg <= {sign_final, 8'hFF, 23'd0};
            end else if (s2_a_zero || s2_b_zero) begin
                // Zero times anything = zero
                z_reg <= {sign_final, 31'd0};
            end else begin
                // Normal numbers, check exponent overflow/underflow

                if (exponent_final >= 10'd255) begin
                    // Overflow: output infinity
                    z_reg <= {sign_final, 8'hFF, 23'd0};
                end else if (exponent_final <= 0) begin
                    // Underflow: output zero
                    z_reg <= {sign_final, 31'd0};
                end else begin
                    // Normalized result
                    z_reg <= {sign_final, exponent_final[7:0], mantissa_rounded[22:0]};
                end
            end
        end
    end

    // Output register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= z_reg;
        end
    end

endmodule