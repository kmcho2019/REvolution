module float_multi (
    input              clk,
    input              rst,        // synchronous active high reset
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);

    // Constants for IEEE-754 single precision
    localparam EXP_BIAS   = 127;
    localparam EXP_INF_NAN = 8'hFF;
    localparam EXP_ZERO   = 8'd0;

    // Internal registered inputs
    reg [31:0] a_reg, b_reg;

    // Internal signals extracted from registered inputs
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Mantissas with implicit 1 for normalized, else zero for denormals/zero
    reg [23:0] a_mant, b_mant;

    // Mantissa multiplication product (48 bits)
    reg [47:0] product;

    // Exponent sum - bias (9 bits to hold carry)
    reg [8:0] exp_sum;

    // Sign of result
    reg z_sign;

    // Normalized mantissa and exponent after adjustment
    reg [23:0] norm_mant;
    reg [8:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Round increment and mantissa after rounding
    reg round_inc;
    reg [24:0] mant_rounded;

    // Final exponent and mantissa output
    reg [7:0] exp_out;
    reg [22:0] frac_out;

    // Flags for special cases
    reg special_nan;
    reg special_inf_zero;

    // Canonical quiet NaN for output
    wire [31:0] qnan = {1'b0, EXP_INF_NAN, 1'b1, 22'b0};

    // Internal combinational signals for sticky bit calculation
    integer i;

    // --- Input registering ---
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            z <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;

            // Extract sign, exponent and fraction
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp  <= a[30:23];
            b_exp  <= b[30:23];
            a_frac <= a[22:0];
            b_frac <= b[22:0];

            // Detect special cases for a
            a_is_zero <= (a_exp == EXP_ZERO) && (a_frac == 23'd0);
            a_is_inf  <= (a_exp == EXP_INF_NAN) && (a_frac == 23'd0);
            a_is_nan  <= (a_exp == EXP_INF_NAN) && (a_frac != 23'd0);

            // Detect special cases for b
            b_is_zero <= (b_exp == EXP_ZERO) && (b_frac == 23'd0);
            b_is_inf  <= (b_exp == EXP_INF_NAN) && (b_frac == 23'd0);
            b_is_nan  <= (b_exp == EXP_INF_NAN) && (b_frac != 23'd0);

            // Prepare mantissas with implicit 1 if normalized
            a_mant <= (a_exp == EXP_ZERO) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mant <= (b_exp == EXP_ZERO) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Sign is XOR of inputs
            z_sign <= a_sign ^ b_sign;

            // Special Inf*Zero = NaN case
            special_inf_zero <= (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

            // If any input is NaN, output is NaN
            special_nan <= a_is_nan || b_is_nan;
        end
    end

    // --- Combinational logic to perform multiplication and rounding ---
    always @(*) begin
        // Default outputs (will be overridden below)
        product = 48'd0;
        exp_sum = 9'd0;
        norm_exp = 9'd0;
        norm_mant = 24'd0;
        guard_bit = 1'b0;
        round_bit = 1'b0;
        sticky_bit = 1'b0;
        round_inc = 1'b0;
        mant_rounded = 25'd0;
        exp_out = 8'd0;
        frac_out = 23'd0;

        // Compute mantissa product
        product = a_mant * b_mant; // 24 x 24 => 48 bits

        // Sum of exponents minus bias (bias is 127)
        // Use 9 bits to hold carry
        // For zero or denormals exponent treated as 0, so exp_sum could underflow - handle later.
        // Using zero exponent for denormals is correct per IEEE-754 for multiplication.

        exp_sum = (a_exp == EXP_ZERO ? 0 : a_exp) + (b_exp == EXP_ZERO ? 0 : b_exp) - EXP_BIAS;

        // Normalize product:
        // product is 48 bits, range: [2^(47) ... 2^0]
        // Because mantissas include implicit 1's, the product's highest two bits tell if normalization is needed.
        // If MSB (bit 47) = 1: product already normalized (1.xxxx)
        // else shift left 1 bit and decrement exponent
        if (product[47] == 1'b1) begin
            norm_mant = product[46:23]; // 24 bits (1.xxxxx)
            norm_exp = exp_sum + 1'b1;  // Adjust exponent up because product is effectively shifted right by 1 in the representation
            // Rounding bits from product bits 22,21 and OR of bits 20:0
            guard_bit = product[22];
            round_bit = product[21];
            sticky_bit = |product[20:0];
        end else begin
            norm_mant = product[45:22]; // Shifted left one bit
            norm_exp = exp_sum;          // No exponent increment because we shifted left
            // Rounding bits from product bits 21,20 and OR of bits 19:0
            guard_bit = product[21];
            round_bit = product[20];
            sticky_bit = |product[19:0];
        end

        // Round to nearest even
        round_inc = guard_bit && (round_bit || sticky_bit || norm_mant[0]);

        mant_rounded = {1'b0, norm_mant} + (round_inc ? 25'd1 : 25'd0);

        // Check mantissa overflow after rounding (carry out)
        if (mant_rounded[24] == 1'b1) begin
            // Mantissa overflow, shift right and increment exponent
            mant_rounded = mant_rounded >> 1;
            norm_exp = norm_exp + 1'b1;
        end

        // After rounding mantissa is 24 bits (mant_rounded[23:0])
        // Handle exponent overflow and underflow
        if (norm_exp >= 9'd255) begin
            // Overflow -> output infinity
            exp_out = EXP_INF_NAN;
            frac_out = 23'd0;
        end else if (norm_exp <= 0) begin
            // Underflow -> output zero (no gradual underflow handling)
            exp_out = 8'd0;
            frac_out = 23'd0;
        end else begin
            // Normal result
            exp_out = norm_exp[7:0];
            frac_out = mant_rounded[22:0];
        end
    end

    // --- Output assignment considering special cases ---
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Priority for output:
            // 1) If any input NaN: quiet NaN output
            if (special_nan) begin
                z <= qnan;
            end 
            // 2) Inf*Zero = NaN
            else if (special_inf_zero) begin
                z <= qnan;
            end
            // 3) Infinity * non-zero/non-NaN = Infinity with correct sign
            else if (a_is_inf || b_is_inf) begin
                z <= {z_sign, EXP_INF_NAN, 23'd0};
            end
            // 4) Zero * non-infinity/non-NaN = Zero with correct sign
            else if (a_is_zero || b_is_zero) begin
                z <= {z_sign, 8'd0, 23'd0};
            end
            // 5) Overflow exponent = Infinity
            else if (exp_out == EXP_INF_NAN) begin
                z <= {z_sign, EXP_INF_NAN, 23'd0};
            end
            // 6) Underflow exponent = Zero
            else if (exp_out == 8'd0) begin
                z <= {z_sign, 8'd0, 23'd0};
            end
            // 7) Normal result
            else begin
                z <= {z_sign, exp_out, frac_out};
            end
        end
    end

endmodule