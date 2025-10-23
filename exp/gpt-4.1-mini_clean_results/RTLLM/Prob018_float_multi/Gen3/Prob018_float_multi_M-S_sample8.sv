module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;

    reg [47:0] product;

    reg guard_bit, round_bit, sticky_bit;

    // Special case flags
    reg a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    reg is_nan, is_inf, is_zero, inf_zero_case;

    // Temporary regs for rounding
    reg round_increment;
    reg [23:0] mantissa_rnd;
    reg [9:0] exponent_rnd;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'd0;
            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exponent <= 0; b_exponent <= 0; z_exponent <= 0;
            a_mantissa <= 0; b_mantissa <= 0; z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            a_is_nan <= 0; b_is_nan <= 0; a_is_inf <= 0; b_is_inf <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            is_nan <= 0; is_inf <= 0; is_zero <= 0; inf_zero_case <= 0;
            round_increment <= 0;
            mantissa_rnd <= 0;
            exponent_rnd <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign
                    a_sign <= a[31];
                    b_sign <= b[31];
                    // Exponent as 10-bit unsigned for safety
                    a_exponent <= {2'b00, a[30:23]};
                    b_exponent <= {2'b00, b[30:23]};
                    // Mantissa with implicit leading 1 if normal exponent nonzero
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Special cases detection
                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                    a_is_inf <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                    b_is_inf <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                    a_is_zero <= (a[30:23] == 8'd0) && (~|a[22:0]);
                    b_is_zero <= (b[30:23] == 8'd0) && (~|b[22:0]);

                    inf_zero_case <= ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
                    is_nan <= a_is_nan || b_is_nan || inf_zero_case;
                    is_inf <= ((a_is_inf || b_is_inf) && ~inf_zero_case);
                    is_zero <= ((a_is_zero || b_is_zero) && ~is_nan && ~is_inf);

                    counter <= 1;
                end
                3'd1: begin
                    // Multiply mantissas: 24x24=48 bits
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias(127)
                    // Stored as 10-bit for safety, result can be negative
                    z_exponent <= a_exponent + b_exponent - 10'd127;

                    // Sign of product
                    z_sign <= a_sign ^ b_sign;

                    counter <= 2;
                end
                3'd2: begin
                    // Normalize product:
                    // If MSB is 1 (bit 47), shift mantissa right by 0, exponent +1
                    // else shift mantissa left by 1 (use bits 46:23), exponent unchanged

                    if (product[47]) begin
                        z_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        z_mantissa <= product[46:23];
                        // exponent unchanged
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3;
                end
                3'd3: begin
                    // Round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);
                    mantissa_rnd <= z_mantissa + round_increment;
                    exponent_rnd <= z_exponent;

                    // Handle mantissa overflow after rounding
                    if (mantissa_rnd[23]) begin
                        mantissa_rnd <= mantissa_rnd >> 1;
                        exponent_rnd <= exponent_rnd + 10'd1;
                    end

                    // Output generation and special case handling
                    if (is_nan) begin
                        // Quiet NaN: sign=0, exp=0xFF, MSB mantissa=1, rest 0
                        z <= {1'b0, 8'hFF, 23'h400000};
                    end else if (is_inf) begin
                        // Infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (is_zero) begin
                        // Zero
                        z <= {z_sign, 31'd0};
                    end else if (exponent_rnd >= 10'd255) begin
                        // Overflow to infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (exponent_rnd <= 10'd0) begin
                        // Underflow to zero (no denormals handled)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {z_sign, exponent_rnd[7:0], mantissa_rnd[22:0]};
                    end

                    counter <= 0;
                end
                default: counter <= 0;
            endcase
        end
    end

endmodule