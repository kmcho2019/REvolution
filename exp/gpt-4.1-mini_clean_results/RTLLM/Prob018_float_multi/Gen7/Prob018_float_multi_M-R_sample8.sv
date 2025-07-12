module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // Constants
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;

    // State counter for sequencing operations
    reg [2:0] counter;

    // Stage 0: Extract fields, determine special cases, prepare mantissas and exponents, compute sign
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [9:0] a_exponent_ext, b_exponent_ext; // extended for calculation
    reg [22:0] a_fraction, b_fraction;
    reg [23:0] a_mantissa, b_mantissa;        // 24-bit mantissas including implicit leading 1
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Stage 1: Multiply mantissas and add exponents
    reg [47:0] product;
    reg [9:0] exponent_sum;

    // Stage 2: Normalize product, extract rounding bits
    reg product_msb;
    reg [47:0] shifted_product;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Stage 3: Round, adjust exponent, handle overflow/underflow, finalize mantissa & exponent
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow, exponent_underflow;
    reg [7:0] final_exponent;

    // Output register intermediate
    reg [31:0] res;

    // Counter increments each cycle, reset clears
    always @(posedge clk) begin
        if (rst)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Stage 0: Extraction and special case detection
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            a_fraction <= 23'd0;
            b_fraction <= 23'd0;
            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exponent_ext <= 10'd0;
            b_exponent_ext <= 10'd0;
            z_sign <= 1'b0;
        end else if (counter == 3'd0) begin
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_fraction <= a[22:0];
            b_fraction <= b[22:0];

            // Detect special cases for a
            a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

            // Detect special cases for b
            b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Prepare mantissas with implicit leading 1 for normal, 0 for denormal and zero
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Exponent extension for calculation: For denormals exponent treated as 1
            a_exponent_ext <= (a[30:23] == 8'd0) ? 10'd1 : {2'b00, a[30:23]};
            b_exponent_ext <= (b[30:23] == 8'd0) ? 10'd1 : {2'b00, b[30:23]};

            // Calculate sign of result
            z_sign <= a[31] ^ b[31];
        end
    end

    // Stage 1: Multiply mantissas and add exponents
    always @(posedge clk) begin
        if (rst) begin
            product <= 48'd0;
            exponent_sum <= 10'd0;
        end else if (counter == 3'd1) begin
            product <= a_mantissa * b_mantissa; // 24x24=48 bits
            exponent_sum <= a_exponent_ext + b_exponent_ext - EXP_BIAS;
        end
    end

    // Stage 2: Normalize product and extract rounding bits
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
            if (product[47]) begin
                shifted_product <= product;
                norm_exponent <= exponent_sum + 10'd1;
            end else begin
                shifted_product <= product << 1;
                norm_exponent <= exponent_sum;
            end
            // norm_mantissa will be updated next cycle after shifted_product is stable
        end
    end

    // Since norm_mantissa depends on shifted_product from stage 2,
    // we update it in next clock cycle stage 3.
    // To keep timing clean, delay the mantissa extraction, rounding and final steps to counter=3

    always @(posedge clk) begin
        if (rst) begin
            norm_mantissa <= 24'd0;
        end else if (counter == 3'd3) begin
            norm_mantissa <= shifted_product[47:24];

            // Extract rounding bits
            guard_bit <= shifted_product[23];
            round_bit <= shifted_product[22];
            sticky_bit <= |shifted_product[21:0];
        end
    end

    // Stage 3: Round, adjust exponent, check overflow/underflow, prepare final mantissa and exponent
    always @(posedge clk) begin
        if (rst) begin
            round_increment <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
        end else if (counter == 3'd3) begin
            // Determine rounding increment (round to nearest even)
            round_increment <= guard_bit && (round_bit | sticky_bit | norm_mantissa[0]);

            rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

            mantissa_carry <= rounded_mantissa_pre[24];

            final_mantissa <= mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];

            final_exponent_pre <= mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;

            exponent_overflow <= (final_exponent_pre >= 10'd255);
            exponent_underflow <= (final_exponent_pre <= 10'd0);

            final_exponent <= exponent_overflow ? 8'hFF :
                              (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);
        end
    end

    // Stage 4: Output generation including special case handling
    always @(posedge clk) begin
        if (rst) begin
            res <= 32'd0;
        end else if (counter == 3'd4) begin
            // Special case priority:
            // 1. NaN input => quiet NaN output (sign=0, exp=FF, MSB mantissa=1)
            // 2. Inf*0 or 0*Inf => NaN
            // 3. Inf * non-zero => Inf with result sign
            // 4. Zero * anything => zero with result sign
            // 5. Else normal result with rounding and normalization
            if (a_nan || b_nan) begin
                res <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                res <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN
            end else if (a_inf || b_inf) begin
                res <= {z_sign, 8'hFF, 23'd0}; // Inf with sign
            end else if (a_zero || b_zero) begin
                res <= {z_sign, 31'd0};        // zero with sign
            end else begin
                if (exponent_overflow) begin
                    res <= {z_sign, 8'hFF, 23'd0}; // Overflow to Inf
                end else if (exponent_underflow) begin
                    res <= {z_sign, 31'd0};         // Underflow to zero
                end else begin
                    res <= {z_sign, final_exponent, final_mantissa};
                end
            end
        end
    end

    // Final registered output with reset
    always @(posedge clk) begin
        if (rst)
            z <= 32'd0;
        else if (counter == 3'd4)
            z <= res;
    end

endmodule