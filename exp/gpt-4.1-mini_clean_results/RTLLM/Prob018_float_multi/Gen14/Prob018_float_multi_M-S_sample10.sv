module float_multi(
    input              clk,
    input              rst,
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Cycle counter
    reg [2:0] counter;

    // Registers to hold extracted input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Extended exponent registers for calculation
    reg [9:0] a_exp_ext, b_exp_ext;

    // Mantissas with implicit leading 1 or 0 for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Computation registers
    reg product_msb;
    reg [47:0] product;

    reg [9:0] exp_sum;
    reg [9:0] exponent_norm;
    reg [23:0] mantissa_norm;

    reg guard_bit, round_bit, sticky_bit;

    reg round_increment;
    reg [24:0] mantissa_rounded_pre; // 25 bits for carry

    reg mantissa_overflow;
    reg [7:0] final_exp;
    reg [22:0] final_frac;
    reg z_sign;

    // Special case flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;
    reg any_nan, any_inf, any_zero, inf_zero;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_exp_ext <= 10'd0; b_exp_ext <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            product_msb <= 1'b0;
            exp_sum <= 10'd0;
            exponent_norm <= 10'd0;
            mantissa_norm <= 24'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            round_increment <= 1'b0;
            mantissa_rounded_pre <= 25'd0;
            mantissa_overflow <= 1'b0;
            final_exp <= 8'd0;
            final_frac <= 23'd0;
            z_sign <= 1'b0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            any_nan <= 1'b0; any_inf <= 1'b0; any_zero <= 1'b0; inf_zero <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, fraction from inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Special cases detection
                    a_zero <= (a[30:0] == 31'd0);
                    b_zero <= (b[30:0] == 31'd0);
                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    any_nan <= ((a[30:23] == 8'hFF) && (a[22:0] != 0)) || ((b[30:23] == 8'hFF) && (b[22:0] != 0));
                    any_inf <= ((a[30:23] == 8'hFF) && (a[22:0] == 0)) || ((b[30:23] == 8'hFF) && (b[22:0] == 0));
                    any_zero <= (a[30:0] == 0) || (b[30:0] == 0);
                    inf_zero <= (((a[30:23] == 8'hFF) && (a[22:0] == 0)) && (b[30:0] == 0)) || (((b[30:23] == 8'hFF) && (b[22:0] == 0)) && (a[30:0] == 0));

                    // Prepare mantissas with implicit leading 1 if normalized, else 0
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Extended exponent (for denormals, treat exponent as 1)
                    a_exp_ext <= (a[30:23] == 8'd0) ? 10'd1 : {2'b00, a[30:23]};
                    b_exp_ext <= (b[30:23] == 8'd0) ? 10'd1 : {2'b00, b[30:23]};

                    // Sign of output
                    z_sign <= a[31] ^ b[31];
                end
                3'd1: begin
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;

                    // Sum exponents with bias subtraction
                    exp_sum <= a_exp_ext + b_exp_ext - EXP_BIAS;
                end
                3'd2: begin
                    // Normalize product mantissa
                    product_msb <= product[47];
                    if (product[47]) begin
                        mantissa_norm <= product[47:24];
                        exponent_norm <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        mantissa_norm <= product[46:23];
                        exponent_norm <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end
                3'd3: begin
                    // Round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || mantissa_norm[0]);
                    mantissa_rounded_pre <= {1'b0, mantissa_norm} + round_increment;
                    mantissa_overflow <= mantissa_rounded_pre[24];

                    // Adjust exponent and fraction for possible overflow after rounding
                    if (mantissa_overflow) begin
                        final_exp <= exponent_norm[7:0] + 8'd1;
                        final_frac <= mantissa_rounded_pre[24:2];
                    end else begin
                        final_exp <= exponent_norm[7:0];
                        final_frac <= mantissa_rounded_pre[22:0];
                    end

                    // Handle special cases and output final result
                    if (any_nan) begin
                        // Quiet NaN (set MSB of mantissa)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (inf_zero) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (any_inf) begin
                        // Inf * non-zero = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (any_zero) begin
                        // Zero * anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal numbers with overflow/underflow handling
                        if (final_exp >= 8'hFF) begin
                            // Overflow → Inf
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (final_exp <= 0) begin
                            // Underflow → zero (flush, no subnormals)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal result
                            z <= {z_sign, final_exp, final_frac};
                        end
                    end
                end
            endcase
            // Increment counter modulo 4 (0..3)
            if (counter == 3'd3)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end
endmodule