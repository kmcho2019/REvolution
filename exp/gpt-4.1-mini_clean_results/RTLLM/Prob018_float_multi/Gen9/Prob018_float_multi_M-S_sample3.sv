module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Mantissas with implicit leading 1 if normalized, else 0
    reg [23:0] a_mantissa, b_mantissa;

    // Sign and exponent of result
    reg z_sign;
    reg signed [9:0] z_exp;

    // 48-bit product of mantissas
    reg [47:0] product;

    // Normalized mantissa and rounding bits
    reg [23:0] norm_mantissa;
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa extended for carry
    reg [24:0] mantissa_rounded;

    // Final exponent and mantissa
    reg [7:0] final_exp;
    reg [22:0] final_frac;

    // Special output flags
    reg special_nan;
    reg special_inf;
    reg special_zero;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            z_sign <= 1'b0;
            z_exp <= 10'd0;
            product <= 48'd0;
            norm_mantissa <= 24'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            final_exp <= 8'd0; final_frac <= 23'd0;
            special_nan <= 1'b0; special_inf <= 1'b0; special_zero <= 1'b0;
        end else begin
            case(counter)
                3'd0: begin
                    // Decode inputs: sign, exponent, fraction
                    a_sign <= a[31];  b_sign <= b[31];
                    a_exp <= a[30:23]; b_exp <= b[30:23];
                    a_frac <= a[22:0]; b_frac <= b[22:0];

                    // Identify special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    // Prepare mantissas (add implicit 1 if normalized)
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Result sign
                    z_sign <= a_sign ^ b_sign;

                    // Initialize special output flags
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Determine special output cases
                    if (a_nan || b_nan) begin
                        special_nan <= 1'b1;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        special_nan <= 1'b1;
                    end else if (a_inf || b_inf) begin
                        special_inf <= 1'b1;
                    end else if (a_zero || b_zero) begin
                        special_zero <= 1'b1;
                    end

                    // Calculate exponent sum for normalized mantissas (subtract bias)
                    z_exp <= $signed({1'b0,a_exp}) + $signed({1'b0,b_exp}) - EXP_BIAS;

                    // Multiply mantissas (24 x 24 bits = 48 bits)
                    product <= a_mantissa * b_mantissa;

                    counter <= counter + 1;
                end

                3'd2: begin
                    // Normalize product and extract rounding bits
                    if (product[47]) begin
                        // MSB=1, shift right 24 bits; exponent incremented
                        norm_mantissa <= product[47:24];
                        z_exp <= z_exp + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB=0, shift right 23 bits; exponent no change
                        norm_mantissa <= product[46:23];
                        // z_exp unchanged
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                    counter <= counter + 1;
                end

                3'd3: begin
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                        mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                    end else begin
                        mantissa_rounded <= {1'b0, norm_mantissa};
                    end
                    counter <= counter + 1;
                end

                3'd4: begin
                    // Handle mantissa overflow after rounding
                    if (mantissa_rounded[24]) begin
                        final_exp <= z_exp + 1;
                        final_frac <= mantissa_rounded[23:1];
                    end else begin
                        final_exp <= z_exp[7:0];
                        final_frac <= mantissa_rounded[22:0];
                    end
                    counter <= counter + 1;
                end

                3'd5: begin
                    // Pack output with special case handling
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=255, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal range check for overflow/underflow
                        if (final_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (final_exp <= 0) begin
                            // Underflow flush to zero
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal number
                            z <= {z_sign, final_exp, final_frac};
                        end
                    end
                    counter <= 3'd0; // Ready for next input
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule