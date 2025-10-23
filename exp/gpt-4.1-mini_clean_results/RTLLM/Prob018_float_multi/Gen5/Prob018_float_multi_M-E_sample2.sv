module float_multi(
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output reg  [31:0]  z
);

    // Pipeline stage 1 registers (input decode)
    reg         s1_a_sign, s1_b_sign;
    reg  [7:0]  s1_a_exp, s1_b_exp;
    reg  [22:0] s1_a_frac, s1_b_frac;

    reg         s1_a_is_zero, s1_b_is_zero;
    reg         s1_a_is_inf,  s1_b_is_inf;
    reg         s1_a_is_nan,  s1_b_is_nan;

    // Mantissas with implicit bit in stage 1
    reg  [23:0] s1_a_mantissa, s1_b_mantissa;

    // Pipeline stage 2 registers (multiply)
    reg         s2_sign;
    reg  [9:0]  s2_exp_sum;    // Signed exponent sum (including bias adjustment)
    reg  [47:0] s2_product;    // 24x24 bit product
    reg         s2_a_is_zero, s2_b_is_zero;
    reg         s2_a_is_inf,  s2_b_is_inf;
    reg         s2_a_is_nan,  s2_b_is_nan;

    // Pipeline stage 3 registers (normalize + rounding prep)
    reg         s3_sign;
    reg  [9:0]  s3_exp;      // normalized exponent (signed)
    reg  [23:0] s3_mantissa; // normalized mantissa 24 bits (including implicit bit)
    reg         s3_guard;
    reg         s3_round;
    reg         s3_sticky;

    reg         s3_is_zero;
    reg         s3_is_inf;
    reg         s3_is_nan;

    // Pipeline stage 4 registers (round + pack)
    reg         s4_sign;
    reg  [9:0]  s4_exp;
    reg  [23:0] s4_mantissa;
    reg         s4_is_zero;
    reg         s4_is_inf;
    reg         s4_is_nan;
    reg         s4_overflow;
    reg         s4_underflow;

    integer i;

    // =====================================================
    // Stage 1: Input decode and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_a_sign <= 0;
            s1_b_sign <= 0;
            s1_a_exp <= 0;
            s1_b_exp <= 0;
            s1_a_frac <= 0;
            s1_b_frac <= 0;

            s1_a_is_zero <= 0;
            s1_b_is_zero <= 0;
            s1_a_is_inf <= 0;
            s1_b_is_inf <= 0;
            s1_a_is_nan <= 0;
            s1_b_is_nan <= 0;

            s1_a_mantissa <= 0;
            s1_b_mantissa <= 0;
        end else begin
            s1_a_sign <= a[31];
            s1_b_sign <= b[31];
            s1_a_exp  <= a[30:23];
            s1_b_exp  <= b[30:23];
            s1_a_frac <= a[22:0];
            s1_b_frac <= b[22:0];

            // Zero detection: exponent==0 and fraction==0
            s1_a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            s1_b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            // Infinity: exponent=255, frac=0
            s1_a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
            s1_b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

            // NaN: exponent=255, frac!=0
            s1_a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
            s1_b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);

            // Prepare mantissa with implicit leading 1 for normal numbers, zero for subnormal/zero
            // If exponent != 0, implicit leading 1, else leading 0 (subnormal)
            s1_a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            s1_b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // =====================================================
    // Stage 2: Mantissa multiplication and exponent addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s2_sign <= 0;
            s2_exp_sum <= 0;
            s2_product <= 0;
            s2_a_is_zero <= 0;
            s2_b_is_zero <= 0;
            s2_a_is_inf  <= 0;
            s2_b_is_inf  <= 0;
            s2_a_is_nan  <= 0;
            s2_b_is_nan  <= 0;
        end else begin
            s2_sign <= s1_a_sign ^ s1_b_sign;
            // Exponent sum: add exponents and subtract bias (127)
            // Use signed to allow negative (underflow)
            s2_exp_sum <= $signed({2'b00, s1_a_exp}) + $signed({2'b00, s1_b_exp}) - 10'sd127;

            // Multiply mantissas 24x24 -> 48 bits
            s2_product <= s1_a_mantissa * s1_b_mantissa;

            // Pass special cases down pipeline
            s2_a_is_zero <= s1_a_is_zero;
            s2_b_is_zero <= s1_b_is_zero;
            s2_a_is_inf  <= s1_a_is_inf;
            s2_b_is_inf  <= s1_b_is_inf;
            s2_a_is_nan  <= s1_a_is_nan;
            s2_b_is_nan  <= s1_b_is_nan;
        end
    end

    // =====================================================
    // Stage 3: Normalization and rounding prep
    // Normalize the 48-bit product:
    // if MSB (bit 47) == 1, then mantissa = bits[47:24], exponent += 1
    // else shift mantissa left by 1 (use bits[46:23]), exponent unchanged
    //
    // Extract guard, round, sticky bits:
    // guard = bit 23, round = bit 22, sticky = OR bits 21..0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s3_sign <= 0;
            s3_exp <= 0;
            s3_mantissa <= 0;
            s3_guard <= 0;
            s3_round <= 0;
            s3_sticky <= 0;
            s3_is_zero <= 0;
            s3_is_inf <= 0;
            s3_is_nan <= 0;
        end else begin
            s3_sign <= s2_sign;

            // Pass special cases through
            // We'll handle special cases fully in stage 4
            s3_is_zero <= (s2_a_is_zero || s2_b_is_zero);
            s3_is_inf  <= (s2_a_is_inf || s2_b_is_inf);
            s3_is_nan  <= (s2_a_is_nan || s2_b_is_nan);

            if (s3_is_nan) begin
                // For NaN no normalization needed
                s3_exp <= 0;
                s3_mantissa <= 0;
                s3_guard <= 0;
                s3_round <= 0;
                s3_sticky <= 0;
            end else if (s3_is_inf) begin
                // For Infinity no normalization needed
                s3_exp <= 0;
                s3_mantissa <= 0;
                s3_guard <= 0;
                s3_round <= 0;
                s3_sticky <= 0;
            end else if (s3_is_zero) begin
                // Zero result
                s3_exp <= 0;
                s3_mantissa <= 0;
                s3_guard <= 0;
                s3_round <= 0;
                s3_sticky <= 0;
            end else begin
                // Normal case: normalize
                if (s2_product[47] == 1'b1) begin
                    // MSB=1, use bits [47:24], exponent +1
                    s3_exp <= s2_exp_sum + 10'sd1;
                    s3_mantissa <= s2_product[47:24];
                    s3_guard <= s2_product[23];
                    s3_round <= s2_product[22];
                    s3_sticky <= |s2_product[21:0];
                end else begin
                    // MSB=0, shift left by 1: use bits [46:23], exponent unchanged
                    s3_exp <= s2_exp_sum;
                    s3_mantissa <= s2_product[46:23];
                    s3_guard <= s2_product[22];
                    s3_round <= s2_product[21];
                    s3_sticky <= |s2_product[20:0];
                end
            end
        end
    end

    // =====================================================
    // Stage 4: Rounding and output packing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s4_sign <= 0;
            s4_exp <= 0;
            s4_mantissa <= 0;
            s4_is_zero <= 0;
            s4_is_inf <= 0;
            s4_is_nan <= 0;
            s4_overflow <= 0;
            s4_underflow <= 0;
            z <= 32'd0;
        end else begin
            s4_sign <= s3_sign;
            s4_is_zero <= s3_is_zero;
            s4_is_inf <= s3_is_inf;
            s4_is_nan <= s3_is_nan;

            // Default no overflow/underflow
            s4_overflow <= 0;
            s4_underflow <= 0;

            if (s3_is_nan) begin
                // Quiet NaN with payload
                // Use canonical quiet NaN: sign=0, exponent=255, mantissa MSB=1, payload arbitrary
                s4_exp <= 8'hFF;
                s4_mantissa <= 24'h400000; // Quiet bit set, other bits 0
            end else if (s3_is_inf) begin
                s4_exp <= 8'hFF;
                s4_mantissa <= 24'd0;
            end else if (s3_is_zero) begin
                s4_exp <= 8'd0;
                s4_mantissa <= 24'd0;
            end else begin
                // Normal number rounding (round to nearest even)
                // Round increment logic:
                // If guard=1 and (round=1 or sticky=1 or LSB=1), increment mantissa
                // LSB is mantissa bit 0

                // Calculate round increment
                reg round_increment;
                round_increment = s3_guard & (s3_round | s3_sticky | s3_mantissa[0]);

                reg [23:0] mantissa_rounded;
                reg [9:0] exp_rounded;
                mantissa_rounded = s3_mantissa + round_increment;
                exp_rounded = s3_exp;

                // Check mantissa overflow (bit 24 set means mantissa overflow)
                if (mantissa_rounded[23]) begin
                    // Shift right by 1, increment exponent
                    mantissa_rounded = mantissa_rounded >> 1;
                    exp_rounded = exp_rounded + 10'sd1;
                end

                // Check for exponent overflow/underflow
                if (exp_rounded >= 10'sd255) begin
                    // Overflow: output infinity
                    s4_overflow <= 1;
                    s4_exp <= 8'hFF;
                    s4_mantissa <= 24'd0;
                end else if (exp_rounded <= 0) begin
                    // Underflow: output zero (no subnormal support)
                    s4_underflow <= 1;
                    s4_exp <= 8'd0;
                    s4_mantissa <= 24'd0;
                end else begin
                    // Normal output
                    s4_exp <= exp_rounded[7:0];
                    s4_mantissa <= mantissa_rounded;
                end
            end

            // Final output packing
            if (s4_is_nan) begin
                z <= {1'b0, 8'hFF, 23'h400000}; // Quiet NaN
            end else if (s4_is_inf || s4_overflow) begin
                z <= {s4_sign, 8'hFF, 23'd0};
            end else if (s4_is_zero || s4_underflow) begin
                z <= {s4_sign, 31'd0};
            end else begin
                // Normal number: pack sign, exponent, mantissa[22:0] (remove implicit bit)
                z <= {s4_sign, s4_exp, s4_mantissa[22:0]};
            end
        end
    end

endmodule