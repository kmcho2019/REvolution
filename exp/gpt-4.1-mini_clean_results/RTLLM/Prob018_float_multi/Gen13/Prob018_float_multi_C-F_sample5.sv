module float_multi (
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;

    // Cycle counter for sequencing operation stages
    reg [2:0] counter; // 0..4

    // Input decomposed signals
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Flags for special cases
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Mantissas with implicit leading 1 or 0 for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Sign and exponent sum registers
    reg result_sign;
    reg [9:0] exponent_sum; // wider to avoid overflow in intermediate addition

    // Product of mantissas (48 bits)
    reg [47:0] product;

    // Normalized mantissa and exponent registers
    reg [23:0] norm_mantissa;
    reg [7:0]  norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa 25 bits (24 + possible carry)
    reg [24:0] rounded_mantissa;

    // Final exponent after rounding
    reg [8:0]  final_exponent;

    // Internal signals for rounding calculation
    wire round_increment;

    // Combinational rounding increment signal (round to nearest even)
    assign round_increment = guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);

    // Reset and sequential control
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers and output
            counter        <= 3'd0;
            a_sign         <= 1'b0;
            b_sign         <= 1'b0;
            a_exp          <= 8'd0;
            b_exp          <= 8'd0;
            a_frac         <= 23'd0;
            b_frac         <= 23'd0;
            a_zero         <= 1'b0;
            b_zero         <= 1'b0;
            a_inf          <= 1'b0;
            b_inf          <= 1'b0;
            a_nan          <= 1'b0;
            b_nan          <= 1'b0;
            a_mantissa     <= 24'd0;
            b_mantissa     <= 24'd0;
            result_sign    <= 1'b0;
            exponent_sum   <= 10'd0;
            product        <= 48'd0;
            norm_mantissa  <= 24'd0;
            norm_exponent  <= 8'd0;
            guard_bit      <= 1'b0;
            round_bit      <= 1'b0;
            sticky_bit     <= 1'b0;
            rounded_mantissa <= 25'd0;
            final_exponent <= 9'd0;
            z              <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture inputs and decode special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp  <= a[30:23];
                    b_exp  <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);

                    a_inf <= (a[30:23] == EXP_INF_NAN) && (a[22:0] == 0);
                    b_inf <= (b[30:23] == EXP_INF_NAN) && (b[22:0] == 0);

                    a_nan <= (a[30:23] == EXP_INF_NAN) && (a[22:0] != 0);
                    b_nan <= (b[30:23] == EXP_INF_NAN) && (b[22:0] != 0);

                    // Prepare mantissas with implicit leading 1 if normalized, else leading 0 (denormal)
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Determine sign of result
                    result_sign <= a[31] ^ b[31];

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Early special case handling: if any input is NaN or (Inf*0)
                    // This is checked again in output stage, but we can skip multiplier for these

                    // Compute exponent sum and mantissa product if no special bypass needed
                    if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero)) begin
                        // No multiplication needed, just proceed to output assembly
                        exponent_sum <= 0;
                        product <= 0;
                    end else if (a_inf || b_inf || a_zero || b_zero) begin
                        // Special cases but no multiplication needed, set zeros to product for output stage
                        exponent_sum <= 0;
                        product <= 0;
                    end else begin
                        // Normal multiplication path
                        // exponent_sum = a_exp + b_exp - bias
                        exponent_sum <= a_exp + b_exp - EXP_BIAS;
                        // Mantissa multiply (24x24)
                        product <= a_mantissa * b_mantissa; // 48-bit product
                    end

                    counter <= counter + 1;
                end

                3'd2: begin
                    // Normalize product mantissa and prepare rounding bits
                    // Skip normalization if special case (product=0)

                    if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero) ||
                        a_inf || b_inf || a_zero || b_zero) begin
                        // No normalization needed, clear signals
                        norm_mantissa <= 24'd0;
                        norm_exponent <= 8'd0;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else begin
                        // Normalization according to MSB of product
                        if (product[47]) begin
                            // MSB=1, mantissa is bits [47:24], exponent +1
                            norm_mantissa <= product[47:24];
                            norm_exponent <= exponent_sum[7:0] + 1;
                            guard_bit <= product[23];
                            round_bit <= product[22];
                            sticky_bit <= |product[21:0];
                        end else begin
                            // MSB=0, mantissa bits [46:23], exponent unchanged
                            norm_mantissa <= product[46:23];
                            norm_exponent <= exponent_sum[7:0];
                            guard_bit <= product[22];
                            round_bit <= product[21];
                            sticky_bit <= |product[20:0];
                        end
                    end

                    counter <= counter + 1;
                end

                3'd3: begin
                    // Rounding step (round to nearest even)
                    // Calculate rounded mantissa with potential increment
                    if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero) ||
                        a_inf || b_inf || a_zero || b_zero) begin
                        // No rounding needed
                        rounded_mantissa <= 25'd0;
                        final_exponent <= 9'd0;
                    end else begin
                        // Round increment combinational logic
                        if (round_increment) begin
                            rounded_mantissa <= {1'b0, norm_mantissa} + 25'd1;
                        end else begin
                            rounded_mantissa <= {1'b0, norm_mantissa};
                        end

                        // Adjust exponent if mantissa overflow due to rounding
                        if (rounded_mantissa[24]) begin
                            final_exponent <= norm_exponent + 1;
                        end else begin
                            final_exponent <= norm_exponent;
                        end
                    end

                    counter <= counter + 1;
                end

                3'd4: begin
                    // Final output assembly with special case handling

                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exp=all 1's, MSB mantissa=1, rest 0
                        z <= {1'b0, EXP_INF_NAN, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, EXP_INF_NAN, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity times nonzero = infinity
                        z <= {result_sign, EXP_INF_NAN, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero times anything = zero
                        z <= {result_sign, 31'd0};
                    end else begin
                        // Normal case assembly

                        // Handle exponent overflow
                        if (final_exponent >= EXP_INF_NAN) begin
                            // Overflow to infinity
                            z <= {result_sign, EXP_INF_NAN, 23'd0};
                        end
                        // Handle exponent underflow (flush to zero)
                        else if (final_exponent <= 0) begin
                            z <= {result_sign, 31'd0};
                        end else begin
                            // Assemble normal float: sign, exponent, fraction
                            // If mantissa overflowed after rounding, drop LSB by shifting right 1
                            if (rounded_mantissa[24]) begin
                                z <= {result_sign, final_exponent[7:0], rounded_mantissa[23:1]};
                            end else begin
                                z <= {result_sign, final_exponent[7:0], rounded_mantissa[22:0]};
                            end
                        end
                    end

                    // Ready for next multiplication
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule