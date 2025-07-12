module float_multi (
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output reg  [31:0]  z
);

    // Pipeline stage registers

    // Stage 1: Input capture and decode
    reg         s1_a_sign, s1_b_sign;
    reg  [7:0]  s1_a_exp, s1_b_exp;
    reg  [22:0] s1_a_frac, s1_b_frac;
    reg  [23:0] s1_a_mantissa, s1_b_mantissa; // with implicit leading bit
    reg         s1_a_is_zero, s1_b_is_zero;
    reg         s1_a_is_inf, s1_b_is_inf;
    reg         s1_a_is_nan, s1_b_is_nan;

    // Stage 2: Multiply mantissas and add exponents
    reg         s2_sign;
    reg  [9:0]  s2_exp_sum;      // signed exponent sum (with bias handled)
    reg  [47:0] s2_product;      // mantissa product (24x24)
    reg         s2_a_is_zero, s2_b_is_zero;
    reg         s2_a_is_inf, s2_b_is_inf;
    reg         s2_a_is_nan, s2_b_is_nan;

    // Stage 3: Normalize product
    reg         s3_sign;
    reg  [9:0]  s3_exp;
    reg  [23:0] s3_mantissa;
    reg         s3_guard, s3_round, s3_sticky;
    reg         s3_a_is_zero, s3_b_is_zero;
    reg         s3_a_is_inf, s3_b_is_inf;
    reg         s3_a_is_nan, s3_b_is_nan;

    // Stage 4: Round mantissa
    reg         s4_sign;
    reg  [9:0]  s4_exp;
    reg  [23:0] s4_mantissa; // rounded mantissa (24 bits)
    reg         s4_a_is_zero, s4_b_is_zero;
    reg         s4_a_is_inf, s4_b_is_inf;
    reg         s4_a_is_nan, s4_b_is_nan;

    // Stage 5: Pack output result
    reg         s5_sign;
    reg  [7:0]  s5_exp;
    reg  [22:0] s5_frac;
    reg         s5_is_zero, s5_is_inf, s5_is_nan;

    // Constant bias for IEEE-754 single precision
    localparam EXP_BIAS = 8'd127;

    // --- Stage 1: Input capture and decode ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_a_sign   <= 1'b0;
            s1_b_sign   <= 1'b0;
            s1_a_exp    <= 8'd0;
            s1_b_exp    <= 8'd0;
            s1_a_frac   <= 23'd0;
            s1_b_frac   <= 23'd0;
            s1_a_mantissa <= 24'd0;
            s1_b_mantissa <= 24'd0;
            s1_a_is_zero <= 1'b0;
            s1_b_is_zero <= 1'b0;
            s1_a_is_inf  <= 1'b0;
            s1_b_is_inf  <= 1'b0;
            s1_a_is_nan  <= 1'b0;
            s1_b_is_nan  <= 1'b0;
        end else begin
            // Extract sign, exponent, fraction fields
            s1_a_sign <= a[31];
            s1_b_sign <= b[31];
            s1_a_exp  <= a[30:23];
            s1_b_exp  <= b[30:23];
            s1_a_frac <= a[22:0];
            s1_b_frac <= b[22:0];

            // Detect special cases for a
            s1_a_is_zero <= (a[30:0] == 31'd0); // Exponent=0 and fraction=0 means zero
            s1_a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            s1_a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);

            // Detect special cases for b
            s1_b_is_zero <= (b[30:0] == 31'd0);
            s1_b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            s1_b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);

            // Calculate mantissas (add implicit leading 1 for normalized numbers)
            // For zero or denormal numbers (exp=0), no leading 1 bit
            s1_a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            s1_b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // --- Stage 2: Multiply mantissas and add exponents ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s2_sign      <= 1'b0;
            s2_exp_sum   <= 10'sd0;
            s2_product   <= 48'd0;
            s2_a_is_zero <= 1'b0;
            s2_b_is_zero <= 1'b0;
            s2_a_is_inf  <= 1'b0;
            s2_b_is_inf  <= 1'b0;
            s2_a_is_nan  <= 1'b0;
            s2_b_is_nan  <= 1'b0;
        end else begin
            // Compute sign of result
            s2_sign <= s1_a_sign ^ s1_b_sign;

            // Compute exponent sum (with bias correction):
            // exponent_sum = a_exp + b_exp - bias
            // Use signed 10-bit for intermediate exponent sum
            s2_exp_sum <= $signed({2'b00, s1_a_exp}) + $signed({2'b00, s1_b_exp}) - 10'sdEXP_BIAS;

            // Multiply mantissas: 24 x 24 = 48 bits
            s2_product <= s1_a_mantissa * s1_b_mantissa;

            // Forward special flags
            s2_a_is_zero <= s1_a_is_zero;
            s2_b_is_zero <= s1_b_is_zero;
            s2_a_is_inf  <= s1_a_is_inf;
            s2_b_is_inf  <= s1_b_is_inf;
            s2_a_is_nan  <= s1_a_is_nan;
            s2_b_is_nan  <= s1_b_is_nan;
        end
    end

    // --- Stage 3: Normalize product ---
    reg [23:0] mantissa_shifted;
    reg signed [9:0] exp_shifted;
    reg guard, round_bit, sticky_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s3_sign       <= 1'b0;
            s3_exp        <= 10'sd0;
            s3_mantissa   <= 24'd0;
            s3_guard      <= 1'b0;
            s3_round      <= 1'b0;
            s3_sticky     <= 1'b0;
            s3_a_is_zero  <= 1'b0;
            s3_b_is_zero  <= 1'b0;
            s3_a_is_inf   <= 1'b0;
            s3_b_is_inf   <= 1'b0;
            s3_a_is_nan   <= 1'b0;
            s3_b_is_nan   <= 1'b0;
        end else begin
            s3_sign <= s2_sign;
            s3_a_is_zero <= s2_a_is_zero;
            s3_b_is_zero <= s2_b_is_zero;
            s3_a_is_inf  <= s2_a_is_inf;
            s3_b_is_inf  <= s2_b_is_inf;
            s3_a_is_nan  <= s2_a_is_nan;
            s3_b_is_nan  <= s2_b_is_nan;

            // Check if product[47] == 1 (leading one at bit 47)
            if (s2_product[47] == 1'b1) begin
                // No shift needed, exponent incremented by 1
                mantissa_shifted = s2_product[47:24];
                exp_shifted = s2_exp_sum + 10'sd1;

                // Bits for rounding
                guard = s2_product[23];
                round_bit = s2_product[22];
                sticky_bit = |s2_product[21:0];
            end else begin
                // Shift mantissa left by 1 (bits 46:23)
                mantissa_shifted = s2_product[46:23];
                exp_shifted = s2_exp_sum;

                // Bits for rounding (shifted accordingly)
                guard = s2_product[22];
                round_bit = s2_product[21];
                sticky_bit = |s2_product[20:0];
            end

            s3_exp <= exp_shifted;
            s3_mantissa <= mantissa_shifted;
            s3_guard <= guard;
            s3_round <= round_bit;
            s3_sticky <= sticky_bit;
        end
    end

    // --- Stage 4: Rounding ---
    reg [23:0] rounded_mantissa;
    reg signed [9:0] rounded_exp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s4_sign       <= 1'b0;
            s4_exp        <= 10'sd0;
            s4_mantissa   <= 24'd0;
            s4_a_is_zero  <= 1'b0;
            s4_b_is_zero  <= 1'b0;
            s4_a_is_inf   <= 1'b0;
            s4_b_is_inf   <= 1'b0;
            s4_a_is_nan   <= 1'b0;
            s4_b_is_nan   <= 1'b0;
        end else begin
            s4_sign <= s3_sign;
            s4_a_is_zero <= s3_a_is_zero;
            s4_b_is_zero <= s3_b_is_zero;
            s4_a_is_inf  <= s3_a_is_inf;
            s4_b_is_inf  <= s3_b_is_inf;
            s4_a_is_nan  <= s3_a_is_nan;
            s4_b_is_nan  <= s3_b_is_nan;

            // Round to nearest even:
            // increment if guard bit = 1 and (round_bit=1 or sticky=1 or LSB=1)
            if (s3_guard && (s3_round || s3_sticky || s3_mantissa[0])) begin
                rounded_mantissa = s3_mantissa + 24'd1;
            end else begin
                rounded_mantissa = s3_mantissa;
            end

            rounded_exp = s3_exp;

            // If mantissa overflowed (bit 23 == 1), shift right and increment exponent
            if (rounded_mantissa[23] == 1'b1) begin
                rounded_mantissa = rounded_mantissa >> 1;
                rounded_exp = rounded_exp + 10'sd1;
            end

            s4_mantissa <= rounded_mantissa;
            s4_exp <= rounded_exp;
        end
    end

    // --- Stage 5: Pack output and handle special cases ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
            s5_sign <= 1'b0;
            s5_exp <= 8'd0;
            s5_frac <= 23'd0;
            s5_is_zero <= 1'b0;
            s5_is_inf <= 1'b0;
            s5_is_nan <= 1'b0;
        end else begin
            s5_sign <= s4_sign;

            // Determine special cases based on inputs propagated through pipeline
            // NaN: if any input NaN or if inf * 0 (invalid)
            s5_is_nan <= (s4_a_is_nan || s4_b_is_nan)
                         || ((s4_a_is_inf && s4_b_is_zero) || (s4_b_is_inf && s4_a_is_zero));

            // Infinity: if either input is inf and not NaN case
            s5_is_inf <= ((s4_a_is_inf || s4_b_is_inf) && !s5_is_nan);

            // Zero: if either input zero and not special NaN or inf
            s5_is_zero <= ((s4_a_is_zero || s4_b_is_zero) && !s5_is_nan && !s5_is_inf);

            // Handle exponent and mantissa underflow/overflow
            // Exponent is signed s4_exp, biased exponent for final representation is s4_exp + bias
            // If underflow (<= 0 after bias), output zero (no denormal support)
            // If overflow (>= 255), output infinity

            if (s5_is_nan) begin
                // Quiet NaN pattern: sign=0, exponent=255, mantissa MSB=1, rest zero
                s5_exp <= 8'hFF;
                s5_frac <= 23'h400000; // Quiet NaN bit set (MSB of mantissa)
            end else if (s5_is_inf) begin
                s5_exp <= 8'hFF;
                s5_frac <= 23'd0;
            end else if (s5_is_zero) begin
                s5_exp <= 8'd0;
                s5_frac <= 23'd0;
            end else if (s4_exp + EXP_BIAS >= 10'd255) begin
                // Overflow to infinity
                s5_exp <= 8'hFF;
                s5_frac <= 23'd0;
            end else if (s4_exp + EXP_BIAS <= 0) begin
                // Underflow to zero (no denormals implemented)
                s5_exp <= 8'd0;
                s5_frac <= 23'd0;
            end else begin
                // Normal case: exponent biased, mantissa lower 23 bits (drop MSB implicit 1)
                s5_exp <= (s4_exp + EXP_BIAS)[7:0];
                s5_frac <= s4_mantissa[22:0];
            end

            z <= {s5_sign, s5_exp, s5_frac};
        end
    end

endmodule