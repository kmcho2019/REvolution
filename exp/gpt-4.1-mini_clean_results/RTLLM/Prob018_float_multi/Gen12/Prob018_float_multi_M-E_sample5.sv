module float_multi (
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Internal registers and wires
    reg [2:0] counter;            // cycle counter: 0..4

    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    reg [23:0]  a_mantissa, b_mantissa; // 1 + fraction
    reg [9:0]   exponent_sum; // extended width for exponent + bias sums and adjustments
    reg         result_sign;

    // product registers: 48-bit product from 24x24 bit multiplication
    reg [47:0]  product;

    // Normalization signals
    reg [7:0]   final_exp;
    reg [23:0]  norm_mantissa;   // normalized mantissa including implicit 1
    reg         guard_bit, round_bit, sticky_bit;

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Temporary signals for sticky calculation
    wire sticky_calc;

    // Extracted at counter == 0
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            z <= 32'd0;
            // Clear internal regs
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            product <= 0;
            exponent_sum <= 0;
            result_sign <= 0;
            final_exp <= 0;
            norm_mantissa <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture inputs and decode special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    // Mantissa with hidden bit: if exponent==0, denormal number -> leading 0
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    result_sign <= a[31] ^ b[31];

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Compute exponent sum and mantissa product
                    // exponent_sum = a_exp + b_exp - bias
                    exponent_sum <= a_exp + b_exp - EXP_BIAS;
                    product <= a_mantissa * b_mantissa; // 24x24=48 bits product
                    counter <= counter + 1;
                end

                3'd2: begin
                    // Normalize product

                    // If product MSB is 1 (bit 47), mantissa is product[47:24], exponent_sum +1
                    // Else mantissa is product[46:23], exponent_sum unchanged
                    if (product[47]) begin
                        final_exp <= exponent_sum[7:0] + 1;
                        norm_mantissa <= product[47:24];
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        final_exp <= exponent_sum[7:0];
                        norm_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= counter + 1;
                end

                3'd3: begin
                    // Rounding: round to nearest even

                    // Round increment condition:
                    // If guard_bit == 1 and (round_bit or sticky_bit or LSB of mantissa)
                    // then increment mantissa by 1
                    reg round_increment;
                    reg [24:0] mantissa_25;

                    round_increment = guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);
                    mantissa_25 = {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check for mantissa overflow due to rounding
                    if (mantissa_25[24]) begin
                        // Mantissa overflow -> shift right by 1, increment exponent
                        final_exp <= final_exp + 1;
                        norm_mantissa <= mantissa_25[24:1];
                    end else begin
                        norm_mantissa <= mantissa_25[23:0];
                    end

                    counter <= counter + 1;
                end

                3'd4: begin
                    // Final output assembly and special case handling

                    // Handle special cases per IEEE-754 standard:
                    // NaN if either input NaN
                    // Inf * 0 = NaN
                    // Inf * nonzero = Inf
                    // Zero * anything = zero
                    if (a_nan || b_nan) begin
                        // Quiet NaN: sign=0, exp=all 1's, MSB mantissa=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity times nonzero = infinity
                        z <= {result_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero times anything = zero
                        z <= {result_sign, 31'd0};
                    end else begin
                        // Check exponent overflow/underflow
                        if (final_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {result_sign, 8'hFF, 23'd0};
                        end else if (final_exp == 8'd0) begin
                            // Underflow to zero (flush)
                            z <= {result_sign, 31'd0};
                        end else begin
                            // Normal case
                            z <= {result_sign, final_exp, norm_mantissa[22:0]};
                        end
                    end

                    counter <= 0; // Ready for next input
                end

                default: begin
                    counter <= 0;
                end
            endcase
        end
    end

endmodule