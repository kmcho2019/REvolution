module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;

    // Cycle counter for sequencing
    reg [2:0] counter;

    // Internal registers for input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special case flags
    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    // Mantissas with hidden bit, extended to 24 bits
    reg [23:0] a_mantissa, b_mantissa;

    // Exponent extended to 10 bits for intermediate calc
    reg [9:0] a_exp_adj, b_exp_adj;
    reg [9:0] exp_sum;

    // Mantissa product 48 bits
    reg [47:0] product;

    // Normalization signals
    reg product_msb;
    reg [47:0] shifted_product;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa extended to 25 bits to detect carry
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;

    // Final mantissa and exponent before special case handling
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;

    // Flags for overflow/underflow exponent
    reg exponent_overflow;
    reg exponent_underflow;

    // Output sign
    wire res_sign = a_sign ^ b_sign;

    // Temporary result before output register
    reg [31:0] res;

    // Cycle counter and main FSM
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
        end else begin
            if (counter == 3'd3) begin
                counter <= 3'd0;
                z <= res; // output registered
            end else begin
                counter <= counter + 3'd1;
            end
        end
    end

    // Cycle 0: Extract inputs and detect special cases
    always @(posedge clk) begin
        if (rst) begin
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
        end else if (counter == 3'd0) begin
            a_sign <= a[31];
            a_exp <= a[30:23];
            a_frac <= a[22:0];

            b_sign <= b[31];
            b_exp <= b[30:23];
            b_frac <= b[22:0];

            // Detect special cases for a
            a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
            a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

            // Detect special cases for b
            b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
            b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
        end
    end

    // Cycle 1: Prepare mantissas, adjust exponents, multiply mantissas
    always @(posedge clk) begin
        if (rst) begin
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exp_adj <= 10'd0;
            b_exp_adj <= 10'd0;
            exp_sum <= 10'd0;
            product <= 48'd0;
        end else if (counter == 3'd1) begin
            // Mantissa with implicit bit for normal, no implicit bit for denorm/zero
            a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Exponent adjusted for denormals (treat exponent as 1 for them)
            a_exp_adj <= (a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp};
            b_exp_adj <= (b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp};

            // Sum of exponents minus bias
            exp_sum <= ( (a_exp == 8'd0 ? 10'd1 : {2'd0,a_exp}) +
                         (b_exp == 8'd0 ? 10'd1 : {2'd0,b_exp}) ) - EXP_BIAS;

            // Multiply mantissas 24x24
            product <= a_mantissa * b_mantissa;
        end
    end

    // Cycle 2: Normalize and extract rounding bits
    always @(posedge clk) begin
        if (rst) begin
            product_msb <= 1'b0;
            shifted_product <= 48'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
        end else if (counter == 3'd2) begin
            product_msb <= product[47];

            // Normalize mantissa: if MSB=1, no shift; else shift left 1 and decrement exponent later
            if (product[47]) begin
                shifted_product <= product;
                norm_exponent <= exp_sum + 10'd1;
            end else begin
                shifted_product <= product << 1;
                norm_exponent <= exp_sum;
            end

            norm_mantissa <= shifted_product[47:24];

            guard_bit <= shifted_product[23];
            round_bit <= shifted_product[22];
            sticky_bit <= |shifted_product[21:0];
        end
    end

    // Cycle 3: Rounding, exponent adjustment, special case handling, and output assembly
    always @(posedge clk) begin
        if (rst) begin
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            res <= 32'd0;
        end else if (counter == 3'd3) begin
            // Round to nearest even
            if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0])) begin
                rounded_mantissa_pre <= {1'b0, norm_mantissa} + 25'd1;
            end else begin
                rounded_mantissa_pre <= {1'b0, norm_mantissa};
            end

            mantissa_carry <= (rounded_mantissa_pre[24] == 1'b1);

            // Adjust exponent if carry generated after rounding
            if (mantissa_carry) begin
                final_mantissa <= rounded_mantissa_pre[24:2];
                final_exponent_pre <= norm_exponent + 10'd1;
            end else begin
                final_mantissa <= rounded_mantissa_pre[22:0];
                final_exponent_pre <= norm_exponent;
            end

            // Exponent overflow and underflow detection
            exponent_overflow <= (final_exponent_pre >= 10'd255);
            exponent_underflow <= (final_exponent_pre <= 10'd0);

            // Special cases handling
            if (a_nan || b_nan) begin
                // quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                res <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf * 0 = NaN
                res <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Inf * non-zero = Inf with correct sign
                res <= {res_sign, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // zero * anything = zero with sign
                res <= {res_sign, 31'd0};
            end else begin
                // Normal result or overflow/underflow
                if (exponent_overflow) begin
                    // Overflow => Inf
                    res <= {res_sign, 8'hFF, 23'd0};
                end else if (exponent_underflow) begin
                    // Underflow => zero (flush to zero)
                    res <= {res_sign, 31'd0};
                end else begin
                    // Normal result
                    res <= {res_sign, final_exponent_pre[7:0], final_mantissa};
                end
            end
        end
    end

endmodule