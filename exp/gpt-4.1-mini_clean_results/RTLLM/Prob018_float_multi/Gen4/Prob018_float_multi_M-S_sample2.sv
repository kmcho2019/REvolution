module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;

    // Extracted fields
    reg        a_sign, b_sign, z_sign;
    reg signed [9:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man; // 24 bits: implicit leading 1 for normal, else subnormal mantissa

    reg [47:0] product; // 24x24 => 48 bits

    reg guard, round, sticky;

    // Special flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    reg special_nan, special_inf, special_zero;

    reg round_increment;
    reg mantissa_overflow;

    // Function to count leading zeros in 24-bit input
    function [4:0] clz24;
        input [23:0] val;
        integer i;
        begin
            clz24 = 0;
            for (i=23; i>=0; i=i-1) begin
                if (val[i] == 1'b0)
                    clz24 = clz24 + 1;
                else
                    i = -1; // break
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

                // Extract exponents as signed 10-bit (to allow negative values after bias subtraction)
                a_exp <= {2'd0, a[30:23]}; // zero-extended
                b_exp <= {2'd0, b[30:23]};

                // Extract mantissa: add implicit 1 for normal numbers, 0 for subnormals and zero
                a_man <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_man <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);
                a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);

                // Clear flags
                special_nan  <= 1'b0;
                special_inf  <= 1'b0;
                special_zero <= 1'b0;

                product <= 48'd0;
                guard <= 1'b0;
                round <= 1'b0;
                sticky <= 1'b0;
                round_increment <= 1'b0;
                mantissa_overflow <= 1'b0;

                z <= 32'd0;

                counter <= counter + 3'd1;
            end

            3'd1: begin
                // Normalize subnormal inputs: shift mantissa left until MSB=1 and adjust exponent accordingly
                if (!a_is_zero && !a_is_nan && !a_is_inf && (a_exp == 10'd0)) begin
                    // a is subnormal: shift left until MSB=1 or zero
                    integer shift_a;
                    shift_a = clz24(a_man);
                    a_man <= a_man << shift_a;
                    a_exp <= 10'd1 - shift_a;
                end
                if (!b_is_zero && !b_is_nan && !b_is_inf && (b_exp == 10'd0)) begin
                    // b is subnormal: shift left until MSB=1 or zero
                    integer shift_b;
                    shift_b = clz24(b_man);
                    b_man <= b_man << shift_b;
                    b_exp <= 10'd1 - shift_b;
                end
                counter <= counter + 3'd1;
            end

            3'd2: begin
                // Handle special cases and compute exponent and product for normal inputs
                // Determine if special cases occur
                special_nan  <= a_is_nan || b_is_nan || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
                special_inf  <= (!special_nan) && (a_is_inf || b_is_inf);
                special_zero <= (!special_nan && !special_inf) && (a_is_zero || b_is_zero);

                if (special_nan || special_inf || special_zero) begin
                    // No product or exponent calculation needed
                    product <= 48'd0;
                    z_exp <= 10'sd0;
                    z_man <= 24'd0;
                end else begin
                    // Calculate new exponent: sum of exponents - bias (127)
                    z_exp <= (a_exp + b_exp) - 10'sd127;
                    // Multiply mantissas (24x24=48 bits)
                    product <= a_man * b_man;
                end
                counter <= counter + 3'd1;
            end

            3'd3: begin
                if (special_nan || special_inf || special_zero) begin
                    // No normalization needed
                    guard <= 1'b0;
                    round <= 1'b0;
                    sticky <= 1'b0;
                end else begin
                    // Normalize product mantissa so that leading 1 is at bit 47
                    if (product[47] == 1'b1) begin
                        // Already normalized: mantissa bits are bits [46:23]
                        z_man <= product[46:23];
                        // Extract rounding bits
                        guard  <= product[22];
                        round  <= product[21];
                        sticky <= |product[20:0];
                        // Adjust exponent up by 1 since product MSB is at bit 47
                        z_exp <= z_exp + 10'sd1;
                    end else begin
                        // Shift left by 1 to normalize leading 1
                        product <= product << 1;
                        z_man <= product[45:22]; // shifted left, mantissa bits now from bit 45 to 22
                        // Extract rounding bits after shift
                        guard  <= product[21];
                        round  <= product[20];
                        sticky <= |product[19:0];
                        // Exponent unchanged because shifted mantissa left (product is doubled)
                        // But since previous exponent assumed product MSB at 47, now one less
                        // So exponent stays as is (no increment)
                    end
                end
                counter <= counter + 3'd1;
            end

            3'd4: begin
                if (special_nan || special_inf || special_zero) begin
                    round_increment <= 1'b0;
                    mantissa_overflow <= 1'b0;
                end else begin
                    // Round to nearest even: increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    round_increment <= guard && (round || sticky || z_man[0]);
                    {mantissa_overflow, z_man} <= z_man + round_increment;
                end
                counter <= counter + 3'd1;
            end

            3'd5: begin
                if (special_nan) begin
                    // Quiet NaN: sign=0, exponent=255, mantissa MSB=1 (quiet bit), rest 0
                    z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                end else if (special_inf) begin
                    // Infinity: sign, exponent=255, mantissa=0
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero: sign, exponent=0, mantissa=0
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal or subnormal result

                    // If mantissa overflowed due to rounding, shift right by 1 and increment exponent
                    if (mantissa_overflow) begin
                        z_man <= z_man >> 1;
                        z_exp <= z_exp + 10'sd1;
                    end

                    // Handle exponent overflow -> Inf
                    if (z_exp >= 10'sd255) begin
                        z <= {z_sign, 8'hFF, 23'd0}; // Inf
                    end
                    // Handle exponent underflow -> subnormal or zero
                    else if (z_exp <= 10'sd0) begin
                        // Exponent negative or zero => subnormal or zero
                        // Shift mantissa right by (1 - z_exp)
                        // Compute shift amount as positive integer
                        integer shift_amt;
                        shift_amt = 1 - z_exp;
                        if (shift_amt > 24) begin
                            // Too small, becomes zero
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Shift right mantissa by shift_amt with rounding bits discarded
                            reg [23:0] shifted_man;
                            shifted_man = z_man >> shift_amt;
                            z <= {z_sign, 8'd0, shifted_man[22:0]};
                        end
                    end
                    else begin
                        // Normal result
                        z <= {z_sign, z_exp[7:0], z_man[22:0]};
                    end
                end
                counter <= 3'd0; // Ready for next multiplication
            end

            default: counter <= 3'd0;
            endcase
        end
    end

endmodule