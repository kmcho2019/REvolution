module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [1:0] counter;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Mantissas with implicit leading 1 if normalized, else leading 0 for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Special case flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate results
    reg [47:0] product;    // 24x24 multiplication
    reg [9:0] exp_sum;     // exponent sum with headroom
    reg sign_result;

    // Normalized mantissa and exponent before rounding
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'd0;

            // Clear internal registers
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;
            product <= 0;
            exp_sum <= 0;
            sign_result <= 0;
            norm_mantissa <= 0;
            norm_exp <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            mantissa_rounded <= 0;
            exponent_rounded <= 0;
        end else begin
            case(counter)
                2'd0: begin
                    // Extract fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    // Mantissas with implicit leading one for normals
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Result sign
                    sign_result <= a[31] ^ b[31];

                    counter <= 2'd1;
                end
                2'd1: begin
                    // Multiply mantissas and add exponents with bias correction
                    product <= a_mantissa * b_mantissa;  // 24x24 -> 48 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS; // 10-bit to cover overflow

                    counter <= 2'd2;
                end
                2'd2: begin
                    // Normalize product and prepare rounding bits
                    if (product[47]) begin
                        // Leading bit 1: shift right, increment exponent
                        norm_mantissa <= product[47:24];
                        norm_exp <= exp_sum + 10'd1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // Leading bit 0: no shift, exponent stays
                        norm_mantissa <= product[46:23];
                        norm_exp <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    // Handle special cases and rounding in next cycle
                    counter <= 2'd3;
                end
                2'd3: begin
                    // Handle special cases first
                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity result
                        z <= {sign_result, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero result
                        z <= {sign_result, 31'd0};
                    end else begin
                        // Round to nearest even
                        if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                            mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                        else
                            mantissa_rounded <= {1'b0, norm_mantissa};

                        // Adjust exponent if mantissa overflows
                        if (mantissa_rounded[24]) begin
                            exponent_rounded <= norm_exp + 10'd1;
                            // Result mantissa shifts right by 1 (drop LSB)
                            if (exponent_rounded[7:0] >= 8'hFF) begin
                                // Overflow to infinity
                                z <= {sign_result, 8'hFF, 23'd0};
                            end else if (exponent_rounded <= 0) begin
                                // Underflow to zero
                                z <= {sign_result, 31'd0};
                            end else begin
                                z <= {sign_result, exponent_rounded[7:0], mantissa_rounded[23:1]};
                            end
                        end else begin
                            exponent_rounded <= norm_exp;
                            if (exponent_rounded[7:0] >= 8'hFF) begin
                                // Overflow to infinity
                                z <= {sign_result, 8'hFF, 23'd0};
                            end else if (exponent_rounded <= 0) begin
                                // Underflow to zero
                                z <= {sign_result, 31'd0};
                            end else begin
                                z <= {sign_result, exponent_rounded[7:0], mantissa_rounded[22:0]};
                            end
                        end
                    end

                    counter <= 2'd0;
                end
                default: counter <= 2'd0;
            endcase
        end
    end

endmodule