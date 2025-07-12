module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Internal registers and signals
    reg [2:0]   counter;

    reg         a_sign, b_sign;
    reg [8:0]   a_exp, b_exp;  // 9 bits to avoid overflow on add
    reg [23:0]  a_mantissa, b_mantissa; // 24 bits including implicit leading 1

    reg         a_is_zero, b_is_zero;
    reg         a_is_inf,  b_is_inf;
    reg         a_is_nan,  b_is_nan;

    reg         z_sign;
    reg [9:0]   z_exp;          // wider for intermediate sum
    reg [47:0]  product;        // 24x24 mantissa multiplication
    reg [23:0]  norm_mantissa;
    reg         guard_bit, round_bit, sticky_bit;

    reg [24:0]  mantissa_rounded;
    reg [9:0]   exp_rounded;

    // Temporary signals
    reg special_nan, special_inf, special_zero;

    // State machine for multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter    <= 0;
            z          <= 32'd0;
            // Clear internal regs
            a_sign     <= 0; b_sign <= 0;
            a_exp      <= 0; b_exp <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            a_is_zero  <= 0; b_is_zero <= 0;
            a_is_inf   <= 0; b_is_inf <= 0;
            a_is_nan   <= 0; b_is_nan <= 0;
            z_sign     <= 0;
            z_exp      <= 0;
            product    <= 0;
            norm_mantissa <= 0;
            guard_bit  <= 0; round_bit <= 0; sticky_bit <= 0;
            mantissa_rounded <= 0;
            exp_rounded <= 0;
        end else begin
            case(counter)
            3'd0: begin
                // Extract fields and detect special cases
                a_sign     <= a[31];
                b_sign     <= b[31];

                a_exp      <= {1'b0, a[30:23]}; // extend to 9 bits
                b_exp      <= {1'b0, b[30:23]};

                a_is_zero  <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_is_zero  <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                a_is_inf   <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_is_inf   <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                a_is_nan   <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_is_nan   <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Mantissa with implicit leading 1 for normalized, else zero for denormals
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                z_sign <= a[31] ^ b[31];

                counter <= counter + 1;
            end

            3'd1: begin
                // Handle special cases flag for output selection later
                special_nan  <= a_is_nan || b_is_nan;
                // Inf * 0 or 0 * Inf => NaN
                special_inf  <= (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
                special_zero <= a_is_zero || b_is_zero;

                // Multiply mantissas (24x24 -> 48 bits)
                product <= a_mantissa * b_mantissa;

                // Exponent sum: add and subtract bias
                z_exp <= a_exp + b_exp - EXP_BIAS;

                counter <= counter + 1;
            end

            3'd2: begin
                // Normalize product and extract rounding bits
                if (product[47]) begin
                    // MSB=1 => product already normalized, shift right by 1 and increment exponent
                    norm_mantissa <= product[47:24];
                    z_exp <= z_exp + 1;
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];
                end else begin
                    // MSB=0 => shift left by 0 (keep as is), exponent no change
                    norm_mantissa <= product[46:23];
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= |product[20:0];
                end

                counter <= counter + 1;
            end

            3'd3: begin
                // Round mantissa (round to nearest even)
                if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0]))
                    mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                else
                    mantissa_rounded <= {1'b0, norm_mantissa};

                exp_rounded <= z_exp;

                counter <= counter + 1;
            end

            3'd4: begin
                // Adjust exponent if mantissa overflow after rounding
                if (mantissa_rounded[24]) begin
                    exp_rounded <= exp_rounded + 1;
                    norm_mantissa <= mantissa_rounded[24:2]; // shifted right by 1 (drop LSB)
                end else begin
                    norm_mantissa <= mantissa_rounded[23:1];
                end

                counter <= counter + 1;
            end

            3'd5: begin
                // Final output assembly with special cases

                if (special_nan || special_inf) begin
                    // Output quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1, rest 0
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Inf * 0 or 0 * Inf = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (a_is_inf || b_is_inf) begin
                    // Inf * non-zero = Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero * anything = Zero (preserve sign)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal number: check for overflow/underflow
                    if (exp_rounded >= 10'd255) begin
                        // Overflow to infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (exp_rounded <= 0) begin
                        // Underflow flush to zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        z <= {z_sign, exp_rounded[7:0], norm_mantissa[22:0]};
                    end
                end

                counter <= 0; // Ready for next operation
            end

            default: counter <= 0;
            endcase
        end
    end

endmodule