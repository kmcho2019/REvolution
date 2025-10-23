module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_MIN  = 8'h00;

    reg [2:0] counter;

    // Cycle 0 registers: extracted input fields and special flags
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg a_zero, b_zero;
    reg a_denormal, b_denormal;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Mantissas with implicit leading bit (24 bits)
    reg [23:0] a_mantissa, b_mantissa;

    // Cycle 1 registers: mantissa product and exponent sum
    reg [47:0] product;
    reg [9:0] exp_sum;    // 10 bits to avoid overflow in exponent calculation
    reg sign_result;

    // Cycle 2 registers: normalized mantissa and exponent, rounding bits
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Cycle 3 registers: rounded mantissa and exponent, final output sign
    reg [24:0] rounded_mantissa_pre;   // 25 bits to capture possible carry-out from rounding
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow, exponent_underflow;
    reg [7:0] final_exponent;
    reg [31:0] result;

    // Sticky bit calculation helper for cycle 2: OR reduction of bits below round bit
    reg sticky_acc;

    // Internal combinational wires (for sticky bit calculation)
    wire [21:0] sticky_range;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;

            // Clear all registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_denormal <= 1'b0; b_denormal <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;

            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            product <= 48'd0;
            exp_sum <= 10'd0;
            sign_result <= 1'b0;

            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            result <= 32'd0;

            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, fraction
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases for a
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                    // Detect special cases for b
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normal, 0 for denormal or zero
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Compute result sign
                    sign_result <= a[31] ^ b[31];

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Multiply mantissas (24x24=48 bits)
                    product <= a_mantissa * b_mantissa;

                    // Adjust exponents: for denormals exponent treated as 1, else normal exponent
                    // Convert to 10 bits to avoid overflow
                    exp_sum <= ((a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp}) +
                               ((b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp}) - EXP_BIAS;

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Normalize product and extract rounding bits

                    if (product[47]) begin
                        // MSB 1 means product >= 2, shift right by 1 and increment exponent
                        norm_mantissa <= product[47:24];     // top 24 bits (leading one + fraction)
                        norm_exponent <= exp_sum + 10'd1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB 0 means product < 2, use as is
                        norm_mantissa <= product[46:23];     // top 24 bits shifted left 1 implicitly
                        norm_exponent <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Round to nearest even

                    // Add rounding increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                        rounded_mantissa_pre <= {1'b0, norm_mantissa} + 25'd1;
                    end else begin
                        rounded_mantissa_pre <= {1'b0, norm_mantissa};
                    end

                    mantissa_carry <= (rounded_mantissa_pre[24]);

                    // Shift mantissa and adjust exponent if carry from rounding
                    if (mantissa_carry) begin
                        final_mantissa <= rounded_mantissa_pre[24:2]; // drop lowest bit after shift right by 1
                        final_exponent_pre <= norm_exponent + 10'd1;
                    end else begin
                        final_mantissa <= rounded_mantissa_pre[22:0];
                        final_exponent_pre <= norm_exponent;
                    end

                    // Exponent overflow/underflow detection
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    // Clamp exponent to 8 bits (will be used below)
                    final_exponent <= exponent_overflow ? 8'hFF :
                                      (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Special cases and final output assembly

                    // Priority:
                    // 1. NaN inputs => quiet NaN
                    // 2. Inf * 0 or 0 * Inf => NaN
                    // 3. Inf * non-zero => Inf with sign
                    // 4. 0 * anything => zero with sign
                    // 5. Else normal number, with rounding and exponent checks
                    if (a_nan || b_nan) begin
                        // quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                        result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity * non-zero
                        result <= {sign_result, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero * anything
                        result <= {sign_result, 31'd0};
                    end else begin
                        // Normal or denormal result

                        if (exponent_overflow) begin
                            // Overflow -> Infinity
                            result <= {sign_result, 8'hFF, 23'd0};
                        end else if (exponent_underflow) begin
                            // Underflow -> zero (flush to zero)
                            result <= {sign_result, 31'd0};
                        end else begin
                            // Normal result
                            result <= {sign_result, final_exponent, final_mantissa};
                        end
                    end

                    // Register the output
                    z <= result;

                    // Reset counter for next operation
                    counter <= 3'd0;
                end
                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule