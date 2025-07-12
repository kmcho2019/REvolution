module float_multi (
    input               clk,
    input               rst, 
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // IEEE 754 single precision constants
    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;

    // Internal cycle counter: controls operation sequencing (0 to 2)
    reg [2:0] counter;

    // Input fields
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Flags for special inputs
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;

    // Mantissas including implicit bit (24 bits)
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate multiplication and exponent sum
    reg [47:0] product;     // 24x24 multiplication output
    reg [9:0]  exp_sum;     // wide for intermediate exponent calculation (8+8 bits + carry)

    reg z_sign;

    // Normalization and rounding signals
    reg [23:0] norm_mantissa;   // normalized mantissa (24 bits including implicit)
    reg [9:0]  norm_exp;        // normalized exponent (with extra bits for overflow)
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [23:0] rounded_mantissa;
    reg [9:0]  rounded_exp;

    // Flags for special cases after stage 2
    reg z_is_zero, z_is_inf, z_is_nan;

    // Sticky bit calculation helper: OR of bits below round bit
    function sticky_calc;
        input [21:0] bits;
        integer i;
        begin
            sticky_calc = 0;
            for (i=0; i<22; i=i+1)
                sticky_calc = sticky_calc | bits[i];
        end
    endfunction

    // Reset and cycle counter management
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
        end else begin
            if (counter == 3'd2)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

    // Cycle 0: Extract input fields, detect special cases, prepare mantissas
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 0;
            b_sign <= 0;
            a_exp <= 0;
            b_exp <= 0;
            a_frac <= 0;
            b_frac <= 0;

            a_is_zero <= 0;
            b_is_zero <= 0;
            a_is_inf <= 0;
            b_is_inf <= 0;
            a_is_nan <= 0;
            b_is_nan <= 0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z_sign <= 0;

        end else if (counter == 3'd0) begin
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_frac <= a[22:0];
            b_frac <= b[22:0];

            // Special cases detection for 'a'
            a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            a_is_inf  <= (a[30:23] == EXP_INF_NAN) && (a[22:0] == 23'd0);
            a_is_nan  <= (a[30:23] == EXP_INF_NAN) && (a[22:0] != 23'd0);

            // Special cases detection for 'b'
            b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            b_is_inf  <= (b[30:23] == EXP_INF_NAN) && (b[22:0] == 23'd0);
            b_is_nan  <= (b[30:23] == EXP_INF_NAN) && (b[22:0] != 23'd0);

            // Mantissas with implicit bit: if exponent is zero => denormal => implicit 0
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            z_sign <= a[31] ^ b[31];
        end
    end

    // Cycle 1: Multiply mantissas, sum exponents with bias adjustment
    always @(posedge clk) begin
        if (rst) begin
            product <= 48'd0;
            exp_sum <= 10'd0;
            z_sign <= 0;
            // preserve special flags
            a_is_zero <= 0;
            b_is_zero <= 0;
            a_is_inf <= 0;
            b_is_inf <= 0;
            a_is_nan <= 0;
            b_is_nan <= 0;
        end else if (counter == 3'd1) begin
            product <= a_mantissa * b_mantissa; // 24x24 multiply
            // sum exponents with bias subtraction; for zero or denorm exponent=0, treat as 1-bias
            // but IEEE 754 uses exponent field zero for denormals (exponent effective is 1 - bias)
            exp_sum <= (a_exp == 0 ? 1 : a_exp) + (b_exp == 0 ? 1 : b_exp) - EXP_BIAS;
            z_sign <= a_sign ^ b_sign;

            // propagate flags
            a_is_zero <= a_is_zero;
            b_is_zero <= b_is_zero;
            a_is_inf <= a_is_inf;
            b_is_inf <= b_is_inf;
            a_is_nan <= a_is_nan;
            b_is_nan <= b_is_nan;
        end
    end

    // Cycle 2: Normalize, round, adjust exponent and generate final output
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
            norm_mantissa <= 24'd0;
            norm_exp <= 10'd0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            rounded_mantissa <= 24'd0;
            rounded_exp <= 10'd0;
            z_is_zero <= 0;
            z_is_inf <= 0;
            z_is_nan <= 0;
        end else if (counter == 3'd2) begin
            // Determine if special cases require shortcut outputs
            if (a_is_nan || b_is_nan) begin
                // NaN output: quiet NaN = exponent all ones and MSB of mantissa set
                z_is_nan <= 1;
                z_is_inf <= 0;
                z_is_zero <= 0;
                z <= {1'b0, EXP_INF_NAN, 1'b1, 22'd0}; // quiet NaN pattern
            end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                // Inf * 0 = NaN
                z_is_nan <= 1;
                z_is_inf <= 0;
                z_is_zero <= 0;
                z <= {1'b0, EXP_INF_NAN, 1'b1, 22'd0};
            end else if (a_is_inf || b_is_inf) begin
                // Inf * nonzero = Inf (with correct sign)
                z_is_inf <= 1;
                z_is_nan <= 0;
                z_is_zero <= 0;
                z <= {z_sign, EXP_INF_NAN, 23'd0};
            end else if (a_is_zero || b_is_zero) begin
                // zero * anything = zero (with correct sign)
                z_is_zero <= 1;
                z_is_inf <= 0;
                z_is_nan <= 0;
                z <= {z_sign, 31'd0};
            end else begin
                // Normal/denorm multiplication path

                // Normalize product mantissa:
                // product is 48 bits; mantissa is 24 bits with implicit bit
                // If MSB (bit 47) = 1 => product >= 2, shift right 1 and increase exponent
                if (product[47]) begin
                    // normalized mantissa bits: [47:24]
                    norm_mantissa <= product[47:24];
                    norm_exp <= exp_sum + 1; // exponent increased by 1 due to shift right
                    // Extract rounding bits
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];
                end else begin
                    // MSB not set, shift not needed
                    norm_mantissa <= product[46:23];
                    norm_exp <= exp_sum;
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= |product[20:0];
                end

                // Rounding to nearest even
                // Round increment if guard=1 and (round or sticky or LSB=1)
                if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                    // Add one to mantissa
                    {rounded_exp, rounded_mantissa} <= {norm_exp, norm_mantissa} + 25'd1;
                end else begin
                    rounded_exp <= norm_exp;
                    rounded_mantissa <= norm_mantissa;
                end

                // After rounding, check mantissa overflow (bit 24)
                if (rounded_mantissa[24]) begin
                    // Mantissa overflow due to rounding, shift right and increase exponent
                    rounded_mantissa <= rounded_mantissa >> 1;
                    rounded_exp <= rounded_exp + 1;
                end

                // Handle overflow and underflow of exponent
                if (rounded_exp >= EXP_INF_NAN) begin
                    // Overflow to infinity
                    z <= {z_sign, EXP_INF_NAN, 23'd0};
                end else if (rounded_exp <= 0) begin
                    // Underflow -> zero (flush to zero)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal case: assemble sign, exponent, mantissa (drop implicit bit)
                    z <= {z_sign, rounded_exp[7:0], rounded_mantissa[22:0]};
                end

                // Clear special flags
                z_is_zero <= 0;
                z_is_inf <= 0;
                z_is_nan <= 0;
            end
        end
    end

endmodule