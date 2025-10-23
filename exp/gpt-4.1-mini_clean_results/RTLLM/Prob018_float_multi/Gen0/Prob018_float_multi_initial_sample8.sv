module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    reg [2:0] counter;

    // Inputs decomposition
    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent; // wider to handle intermediate sums
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 1 implicit + 23 bits fraction
    reg [49:0] product;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg z_zero, z_inf, z_nan;

    // intermediate mantissa product normalization shift
    reg product_msb;

    // Sticky bit calculation helper
    wire sticky_bit_calc;

    // Extract input fields and detect specials on counter=0
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exponent <= 10'd0; b_exponent <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            z_sign <= 1'b0; z_exponent <= 10'd0; z_mantissa <= 24'd0;
            product <= 50'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky <= 1'b0;
            a_zero <= 1'b0; b_zero <= 1'b0; a_inf <= 1'b0; b_inf <= 1'b0; a_nan <= 1'b0; b_nan <= 1'b0;
            z_zero <= 1'b0; z_inf <= 1'b0; z_nan <= 1'b0;
            product_msb <= 1'b0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign
                    a_sign <= a[31];
                    b_sign <= b[31];
                    // Extract exponent (8 bits) -> use 10 bits for intermediate calculation
                    a_exponent <= {2'd0, a[30:23]};
                    b_exponent <= {2'd0, b[30:23]};
                    // Extract mantissa
                    // If exponent !=0 then implicit leading 1 else leading 0 (denormals)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect specials for a
                    a_zero <= (a[30:0] == 31'd0); // exponent=0 and mantissa=0
                    a_inf <= ((a[30:23] == 8'hFF) && (a[22:0] == 23'd0));
                    a_nan <= ((a[30:23] == 8'hFF) && (a[22:0] != 23'd0));
                    // Detect specials for b
                    b_zero <= (b[30:0] == 31'd0);
                    b_inf <= ((b[30:23] == 8'hFF) && (b[22:0] == 23'd0));
                    b_nan <= ((b[30:23] == 8'hFF) && (b[22:0] != 23'd0));

                    counter <= counter + 3'd1;
                end

                3'd1: begin
                    // Determine output sign
                    z_sign <= a_sign ^ b_sign;

                    // Handle special cases: NaN if any operand is NaN
                    if (a_nan || b_nan) begin
                        z_nan <= 1'b1;
                        z_inf <= 1'b0;
                        z_zero <= 1'b0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z_nan <= 1'b1;
                        z_inf <= 1'b0;
                        z_zero <= 1'b0;
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero = Inf
                        z_inf <= 1'b1;
                        z_nan <= 1'b0;
                        z_zero <= 1'b0;
                    end else if (a_zero || b_zero) begin
                        // zero product
                        z_zero <= 1'b1;
                        z_inf <= 1'b0;
                        z_nan <= 1'b0;
                    end else begin
                        z_zero <= 1'b0;
                        z_inf <= 1'b0;
                        z_nan <= 1'b0;
                    end

                    if (!z_nan && !z_inf && !z_zero) begin
                        // Calculate exponent sum and subtract bias 127
                        // Exponent = a_exp + b_exp - bias (127)
                        // Use wider to avoid overflow
                        z_exponent <= (a_exponent + b_exponent) - 10'd127;
                        // mantissas are already prepared with leading 1 or 0
                        // mantissas are 24 bits
                    end else begin
                        z_exponent <= 10'd0;
                    end

                    counter <= counter + 3'd1;
                end

                3'd2: begin
                    // Multiply mantissas: 24x24 = 48 bits
                    if (!z_nan && !z_inf && !z_zero) begin
                        product <= a_mantissa * b_mantissa; // 24x24=48 bits result fits in 50-bit reg
                        // product msb is bit 47 (0-based), store for normalization
                        product_msb <= ( (a_mantissa * b_mantissa) & (1 << 47) ) ? 1'b1 : 1'b0;
                    end else begin
                        product <= 50'd0;
                        product_msb <= 1'b0;
                    end
                    counter <= counter + 3'd1;
                end

                3'd3: begin
                    if (!z_nan && !z_inf && !z_zero) begin
                        // Normalize product:
                        // If product MSB is 1 (bit47), mantissa is (bits47:24) 24 bits,
                        // exponent is already adjusted so no change
                        // else shift left one and decrement exponent
                        if (product[47] == 1'b1) begin
                            // No shift needed, mantissa is bits [47:24]
                            z_exponent <= z_exponent + 1; // Because mantissa is effectively 1.xxx
                            z_mantissa <= product[47:24];
                            // Rounding bits: guard = bit23, round = bit22, sticky = OR of bits21:0
                            guard_bit <= product[23];
                            round_bit <= product[22];
                            sticky <= |product[21:0];
                        end else begin
                            // Shift left 1: mantissa = bits[46:23]
                            z_exponent <= z_exponent;
                            z_mantissa <= product[46:23];
                            guard_bit <= product[22];
                            round_bit <= product[21];
                            sticky <= |product[20:0];
                        end
                    end else begin
                        // No mantissa
                        z_mantissa <= 24'd0;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky <= 1'b0;
                    end
                    counter <= counter + 3'd1;
                end

                3'd4: begin
                    // Rounding: round to nearest even
                    if (!z_nan && !z_inf && !z_zero) begin
                        // Round conditions
                        // round up if guard=1 and (round=1 or sticky=1 or lsb of mantissa=1)
                        if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                            {z_exponent, z_mantissa} <= {z_exponent, z_mantissa} + 1;
                            // Check overflow after rounding mantissa increment
                            if (z_mantissa == 24'hFFFFFF) begin
                                // mantissa overflowed, shift right and increment exponent
                                z_mantissa <= 24'h800000; // normalized leading 1 followed by 23 zeros
                                z_exponent <= z_exponent + 1;
                            end
                        end
                    end

                    // Check exponent overflow and underflow, handle special cases
                    if (z_nan) begin
                        // Return canonical NaN: sign=0 exponent=0xFF mantissa!=0
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                    end else if (z_inf) begin
                        // Return infinity: sign, exponent=0xFF mantissa=0
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_zero) begin
                        // Return zero: sign, exponent=0 mantissa=0
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal case
                        if (z_exponent >= 10'd255) begin
                            // Overflow: set to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exponent <= 0) begin
                            // Underflow or subnormal
                            // Shift mantissa right by 1 - z_exponent (denormalize)
                            // exponent set to zero
                            integer shift_amount;
                            reg [47:0] mantissa_shift;
                            shift_amount = 1 - z_exponent;
                            if (shift_amount > 24) begin
                                // too small, result is zero
                                z <= {z_sign, 31'd0};
                            end else begin
                                // Compose mantissa with guard, round, sticky bits as 48 bits for shifting
                                mantissa_shift = {z_mantissa, guard_bit, round_bit, sticky ? 1'b1 : 1'b0, 22'd0};
                                mantissa_shift = mantissa_shift >> shift_amount;
                                // Now extract mantissa, rounding bits again
                                reg new_guard, new_round, new_sticky;
                                new_guard = mantissa_shift[23];
                                new_round = mantissa_shift[22];
                                new_sticky = |mantissa_shift[21:0];
                                reg [23:0] new_mantissa;
                                new_mantissa = mantissa_shift[46:23]; // 24 bits

                                // Round again
                                if (new_guard && (new_round | new_sticky | new_mantissa[0])) begin
                                    new_mantissa = new_mantissa + 1;
                                end

                                z <= {z_sign, 8'd0, new_mantissa[22:0]}; // exponent=0
                            end
                        end else begin
                            // Normal number
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end
                    counter <= 3'd0; // Ready for next operation
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule