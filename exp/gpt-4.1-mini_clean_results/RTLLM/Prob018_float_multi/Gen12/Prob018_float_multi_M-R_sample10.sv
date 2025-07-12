module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    // Internal cycle counter (0 to 4)
    reg [2:0] counter;

    // Internal registered inputs/signals
    reg a_sign, b_sign;
    reg [9:0] a_exponent, b_exponent;  // wider to allow bias math
    reg [23:0] a_mantissa, b_mantissa;

    // Special cases detection registers
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Intermediate computation registers
    reg [49:0] product;       // 24x24 multiply result (max 48 bits, use 50 bits for rounding bits)
    reg [9:0]  exp_sum;       // sum of exponents - bias

    reg z_sign;
    reg [9:0] z_exponent;
    reg [23:0] z_mantissa;

    // Normalization and rounding bits
    reg guard_bit, round_bit, sticky;

    // Flags to control output special cases propagation
    reg output_nan, output_inf, output_zero;

    // Registers for normalized mantissa/exponent and rounded results
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg [23:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    localparam EXP_BIAS = 127;

    // Stage 0: Input capture and special case detection
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;

            a_exponent <= 10'd0;
            b_exponent <= 10'd0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;

            a_is_zero <= 1'b0;
            b_is_zero <= 1'b0;

            a_is_inf <= 1'b0;
            b_is_inf <= 1'b0;

            a_is_nan <= 1'b0;
            b_is_nan <= 1'b0;

            product <= 50'd0;
            exp_sum <= 10'd0;

            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;

            output_nan <= 1'b0;
            output_inf <= 1'b0;
            output_zero <= 1'b0;

            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            mantissa_rounded <= 24'd0;
            exponent_rounded <= 10'd0;

            z <= 32'd0;

        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign
                    a_sign <= a[31];
                    b_sign <= b[31];
                    z_sign <= a[31] ^ b[31];

                    // Extract and extend exponents to 10 bits for safety
                    a_exponent <= {2'b00, a[30:23]};
                    b_exponent <= {2'b00, b[30:23]};

                    // Detect special cases
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);

                    // Build mantissas with implicit leading 1 for normal numbers
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Reset flags for output special case
                    output_nan <= 1'b0;
                    output_inf <= 1'b0;
                    output_zero <= 1'b0;

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Handle special cases early and store flags for later

                    if (a_is_nan || b_is_nan) begin
                        output_nan <= 1'b1;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        output_nan <= 1'b1;
                    end else if (a_is_inf || b_is_inf) begin
                        output_inf <= 1'b1;
                    end else if (a_is_zero || b_is_zero) begin
                        output_zero <= 1'b1;
                    end

                    if (!(output_nan || output_inf || output_zero)) begin
                        // Perform mantissa multiplication: 24x24 => 48 bits product
                        product <= a_mantissa * b_mantissa;  // 24x24 multiply

                        // Sum exponents, subtract bias
                        exp_sum <= (a_exponent + b_exponent) - EXP_BIAS;
                    end

                    counter <= counter + 1;
                end

                3'd2: begin
                    if (output_nan || output_inf || output_zero) begin
                        // Skip product processing if special case
                        product <= product;
                        exp_sum <= exp_sum;
                    end else begin
                        // Normalize product:
                        // If MSB product[47] == 1, shift right 1 and increment exponent
                        if (product[47]) begin
                            product <= product >> 1;
                            exp_sum <= exp_sum + 1;
                        end

                        // Extract normalized mantissa (24 bits) from product[46:23]
                        norm_mantissa <= product[46:23];

                        // Extract rounding bits: guard(22), round(21), sticky (OR lower bits)
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];

                        norm_exponent <= exp_sum;
                    end
                    counter <= counter + 1;
                end

                3'd3: begin
                    if (output_nan || output_inf || output_zero) begin
                        // No rounding needed if special case
                        mantissa_rounded <= norm_mantissa;
                        exponent_rounded <= norm_exponent;
                    end else begin
                        // Round to nearest even
                        if (guard_bit && (round_bit | sticky | norm_mantissa[0])) begin
                            // Round up
                            {exponent_rounded, mantissa_rounded} <= {norm_exponent, norm_mantissa} + 1'b1;

                            // Handle mantissa overflow (carry out of bit 23)
                            if (mantissa_rounded == 24'h1000000) begin
                                mantissa_rounded <= 24'h800000;  // shift right by 1
                                exponent_rounded <= exponent_rounded + 1;
                            end
                        end else begin
                            // No rounding increment
                            mantissa_rounded <= norm_mantissa;
                            exponent_rounded <= norm_exponent;
                        end
                    end
                    counter <= counter + 1;
                end

                3'd4: begin
                    if (output_nan) begin
                        // Quiet NaN: sign=0, exponent=255, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (output_inf) begin
                        // Infinity with correct sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (output_zero) begin
                        // Zero with sign
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number: handle overflow/underflow
                        if (exponent_rounded >= 10'd255) begin
                            // Overflow to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exponent_rounded <= 0) begin
                            // Underflow to zero (no gradual underflow for simplicity)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal final result
                            z <= {z_sign, exponent_rounded[7:0], mantissa_rounded[22:0]};
                        end
                    end

                    counter <= 3'd0; // restart cycle
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule