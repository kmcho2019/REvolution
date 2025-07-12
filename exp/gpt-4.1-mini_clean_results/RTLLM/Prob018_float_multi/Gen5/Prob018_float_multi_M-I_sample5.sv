module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;

    // Fields and intermediate signals
    reg        a_sign, b_sign, z_sign;
    reg signed [9:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man; // 24 bits mantissa (including implicit bit for normal)
    reg [47:0] product; // 24x24=48 bits product

    // Rounding bits
    reg guard, round, sticky;

    // Special cases flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan,  b_is_nan;

    reg special_nan, special_inf, special_zero;

    reg round_increment;
    reg mantissa_overflow;

    integer i;

    // Count leading zeros in a 24-bit value (clz24)
    function [4:0] clz24;
        input [23:0] val;
        integer idx;
        begin
            clz24 = 0;
            for (idx = 23; idx >= 0; idx = idx - 1) begin
                if (val[idx] == 1'b0)
                    clz24 = clz24 + 1;
                else
                    idx = -1; // break
            end
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter      <= 3'd0;
            z            <= 32'd0;

            a_sign       <= 1'b0;
            b_sign       <= 1'b0;
            z_sign       <= 1'b0;

            a_exp        <= 10'sd0;
            b_exp        <= 10'sd0;
            z_exp        <= 10'sd0;

            a_man        <= 24'd0;
            b_man        <= 24'd0;
            z_man        <= 24'd0;

            product      <= 48'd0;

            guard        <= 1'b0;
            round        <= 1'b0;
            sticky       <= 1'b0;

            a_is_zero    <= 1'b0;
            b_is_zero    <= 1'b0;
            a_is_inf     <= 1'b0;
            b_is_inf     <= 1'b0;
            a_is_nan     <= 1'b0;
            b_is_nan     <= 1'b0;

            special_nan  <= 1'b0;
            special_inf  <= 1'b0;
            special_zero <= 1'b0;

            round_increment <= 1'b0;
            mantissa_overflow <= 1'b0;
        end else begin
            case (counter)
            3'd0: begin
                // Extract sign bits
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a[31] ^ b[31];

                // Extract exponents as unsigned, then convert to signed unbiased exponent
                // If exponent = 0, biased exponent 0 means subnormal or zero → unbiased exponent = -126
                a_exp <= (a[30:23] == 8'd0) ? -10'sd126 : $signed({2'b00, a[30:23]}) - 10'sd127;
                b_exp <= (b[30:23] == 8'd0) ? -10'sd126 : $signed({2'b00, b[30:23]}) - 10'sd127;

                // Extract mantissas:
                // If exponent==0 (subnormal or zero), leading implicit bit = 0
                // Else normal number: leading implicit bit = 1
                a_man <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_man <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);

                a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);

                // Clear special flags
                special_nan  <= 1'b0;
                special_inf  <= 1'b0;
                special_zero <= 1'b0;

                product <= 48'd0;

                guard <= 1'b0;
                round <= 1'b0;
                sticky <= 1'b0;

                round_increment <= 1'b0;
                mantissa_overflow <= 1'b0;

                z_exp <= 10'sd0;
                z_man <= 24'd0;

                counter <= counter + 3'd1;
            end

            3'd1: begin
                // Normalize subnormal inputs: shift mantissa left until MSB=1 or zero, decrement exponent accordingly
                if (!a_is_zero && !a_is_nan && !a_is_inf && (a_exp == -10'sd126)) begin
                    // a is subnormal: shift left to normalize mantissa
                    reg [4:0] shift_a;
                    shift_a = clz24(a_man);
                    if (shift_a == 24) begin
                        // Zero mantissa, keep as zero, exponent = -126
                        a_man <= 24'd0;
                        a_exp <= -10'sd126;
                    end else begin
                        a_man <= a_man << shift_a;
                        a_exp <= -10'sd126 - shift_a;
                    end
                end
                if (!b_is_zero && !b_is_nan && !b_is_inf && (b_exp == -10'sd126)) begin
                    // b is subnormal: normalize similarly
                    reg [4:0] shift_b;
                    shift_b = clz24(b_man);
                    if (shift_b == 24) begin
                        b_man <= 24'd0;
                        b_exp <= -10'sd126;
                    end else begin
                        b_man <= b_man << shift_b;
                        b_exp <= -10'sd126 - shift_b;
                    end
                end
                counter <= counter + 3'd1;
            end

            3'd2: begin
                // Determine special results
                special_nan  <= a_is_nan || b_is_nan || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
                special_inf  <= (!special_nan) && (a_is_inf || b_is_inf);
                special_zero <= (!special_nan && !special_inf) && (a_is_zero || b_is_zero);

                if (special_nan || special_inf || special_zero) begin
                    // No multiplication needed in these cases
                    product <= 48'd0;
                    z_exp <= 10'sd0;
                    z_man <= 24'd0;
                end else begin
                    // Normal multiplication:
                    // exponent = a_exp + b_exp + bias removed
                    z_exp <= a_exp + b_exp;

                    // Multiply mantissas
                    product <= a_man * b_man;
                end
                counter <= counter + 3'd1;
            end

            3'd3: begin
                if (special_nan || special_inf || special_zero) begin
                    guard <= 1'b0;
                    round <= 1'b0;
                    sticky <= 1'b0;
                end else begin
                    // Normalize product:
                    // If product[47] == 1, shift mantissa bits down, exponent +1
                    if (product[47] == 1'b1) begin
                        z_man <= product[46:23]; // 24 bits: MSB implicit 1 + 23 mantissa bits
                        z_exp <= z_exp + 10'sd1;
                        guard <= product[22];
                        round <= product[21];
                        sticky <= |product[20:0];
                    end else begin
                        // Shift product left by 1 to normalize (leading 1 at bit 46)
                        product <= product << 1;
                        z_man <= product[46:23];
                        // exponent stays the same because we normalized here
                        guard <= product[22];
                        round <= product[21];
                        sticky <= |product[20:0];
                    end
                end
                counter <= counter + 3'd1;
            end

            3'd4: begin
                if (special_nan || special_inf || special_zero) begin
                    round_increment <= 1'b0;
                    mantissa_overflow <= 1'b0;
                end else begin
                    // Round to nearest even:
                    // increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    round_increment <= guard && (round || sticky || z_man[0]);
                    {mantissa_overflow, z_man} <= z_man + round_increment;
                end
                counter <= counter + 3'd1;
            end

            3'd5: begin
                if (special_nan) begin
                    // Quiet NaN: sign=0, exp=255, mantissa MSB=1 (quiet bit), rest 0
                    z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                end else if (special_inf) begin
                    // Infinity: sign, exp=255, mantissa=0
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero: sign, exp=0, mantissa=0
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal or subnormal

                    // Handle mantissa overflow after rounding
                    if (mantissa_overflow) begin
                        z_man <= z_man >> 1;
                        z_exp <= z_exp + 10'sd1;
                    end

                    // Check exponent overflow
                    if (z_exp >= 10'sd128) begin
                        // Overflow: set to Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exp <= -10'sd126) begin
                        // Underflow: produce subnormal or zero

                        // shift amount = ( -126 - z_exp )
                        integer shift_amt;
                        reg [23:0] shifted_man;
                        shift_amt = (-10'sd126) - z_exp;

                        if (shift_amt >= 24) begin
                            // Too small -> zero
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Shift mantissa right by shift_amt with sticky bits
                            reg sticky_bit;
                            sticky_bit = |(z_man[shift_amt-1:0]);
                            shifted_man = z_man >> shift_amt;
                            // Round again if sticky bits set and guard bits lost
                            if (sticky_bit && ((shifted_man[0]) == 1'b1)) begin
                                shifted_man = shifted_man + 1;
                                if (shifted_man == 24'd0) begin
                                    // Rounded to zero
                                    z <= {z_sign, 31'd0};
                                end else begin
                                    z <= {z_sign, 8'd0, shifted_man[22:0]};
                                end
                            end else begin
                                z <= {z_sign, 8'd0, shifted_man[22:0]};
                            end
                        end
                    end else begin
                        // Normal exponent pack with bias added back
                        // z_exp in range [-126,127], add bias 127 to get exponent field
                        reg [7:0] final_exp;
                        final_exp = z_exp + 10'sd127;

                        // Handle corner case: if final_exp=0, means subnormal -> should be handled by underflow branch above
                        // So here final_exp != 0 guaranteed
                        z <= {z_sign, final_exp, z_man[22:0]};
                    end
                end

                counter <= 3'd0; // Ready for next multiplication
            end

            default: counter <= 3'd0;

            endcase
        end
    end

endmodule