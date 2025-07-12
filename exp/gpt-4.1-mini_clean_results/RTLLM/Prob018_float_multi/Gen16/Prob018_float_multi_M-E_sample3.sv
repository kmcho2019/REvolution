module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_MIN  = 8'h00;

    // FSM counter: counts 0 to 6 for stages of operation
    reg [2:0] counter;

    // Stage registers
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg zero_inf_conflict; // zero * inf special case

    // Mantissas with implicit bit (normalized or denormal)
    reg [23:0] a_mantissa, b_mantissa;

    // Exponent adjusted for denormals as 1 if zero exponent
    reg [9:0] a_exp_adj, b_exp_adj;

    // Product and exponent sum registers
    reg [47:0] mantissa_product;
    reg [9:0] exp_sum;

    // Normalized mantissa and exponent after shifting
    reg [47:0] norm_mantissa_product;
    reg product_msb;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] rounded_mantissa_pre; // 25 bits to include carry
    reg round_increment;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;

    // Overflow and underflow flags
    reg exponent_overflow;
    reg exponent_underflow;

    // Final exponent 8-bit
    reg [7:0] final_exponent;

    // Special case result stored for cycles 1..6
    reg [31:0] special_case_result;
    reg special_case_flag;

    // FSM and processing
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Reset all stage registers to zero
            a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            zero_inf_conflict <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_exp_adj <= 10'd0; b_exp_adj <= 10'd0;
            mantissa_product <= 48'd0;
            exp_sum <= 10'd0;
            norm_mantissa_product <= 48'd0;
            product_msb <= 1'b0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            round_increment <= 1'b0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            special_case_result <= 32'd0;
            special_case_flag <= 1'b0;
        end else begin
            case(counter)
            3'd0: begin
                // Extract inputs fields
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_frac <= a[22:0];
                b_frac <= b[22:0];

                // Special cases for a
                a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                // Special cases for b
                b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Reset special case flag
                special_case_flag <= 1'b0;

                // Compute output sign
                z_sign <= a[31] ^ b[31];

                counter <= 3'd1;
            end
            3'd1: begin
                // Check zero*inf conflict special case
                zero_inf_conflict <= ( (a_inf && b_zero) || (b_inf && a_zero) );

                // Prepare mantissas with implicit bit
                // For normal numbers, implicit 1; for denormals and zero, implicit 0
                if (a_exp == 8'd0)
                    a_mantissa <= {1'b0, a_frac};
                else
                    a_mantissa <= {1'b1, a_frac};

                if (b_exp == 8'd0)
                    b_mantissa <= {1'b0, b_frac};
                else
                    b_mantissa <= {1'b1, b_frac};

                // Adjust exponent for denormals: treat exponent as 1 if zero (denormals)
                a_exp_adj <= (a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp};
                b_exp_adj <= (b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp};

                // Prepare special case result if needed
                if (a_nan || b_nan) begin
                    // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                    special_case_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    special_case_flag <= 1'b1;
                end else if (zero_inf_conflict) begin
                    // zero * inf => NaN
                    special_case_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    special_case_flag <= 1'b1;
                end else begin
                    special_case_flag <= 1'b0;
                end

                counter <= 3'd2;
            end
            3'd2: begin
                if (!special_case_flag) begin
                    // Mantissa multiply 24x24 -> 48 bits
                    mantissa_product <= a_mantissa * b_mantissa;
                    // Add exponents and subtract bias
                    exp_sum <= a_exp_adj + b_exp_adj - EXP_BIAS;
                end else begin
                    mantissa_product <= 48'd0;
                    exp_sum <= 10'd0;
                end
                counter <= 3'd3;
            end
            3'd3: begin
                if (!special_case_flag) begin
                    // Normalize product
                    product_msb <= mantissa_product[47];
                    // If product_msb==1, no shift; else shift left by 1
                    if (mantissa_product[47]) begin
                        norm_mantissa_product <= mantissa_product;
                        norm_exponent <= exp_sum + 10'd1;
                    end else begin
                        norm_mantissa_product <= mantissa_product << 1;
                        norm_exponent <= exp_sum;
                    end

                    // Extract rounding bits
                    guard_bit <= product_msb ? mantissa_product[23] : (mantissa_product << 1)[23];
                    round_bit <= product_msb ? mantissa_product[22] : (mantissa_product << 1)[22];
                    // sticky is OR of bits below round_bit
                    if (product_msb)
                        sticky_bit <= |mantissa_product[21:0];
                    else
                        sticky_bit <= |((mantissa_product << 1)[21:0]);
                end else begin
                    norm_mantissa_product <= 48'd0;
                    norm_exponent <= 10'd0;
                    guard_bit <= 1'b0;
                    round_bit <= 1'b0;
                    sticky_bit <= 1'b0;
                end
                counter <= 3'd4;
            end
            3'd4: begin
                if (!special_case_flag) begin
                    // Compose 24-bit mantissa: bits [47:24] are leading+fraction
                    rounded_mantissa_pre <= {1'b0, norm_mantissa_product[47:24]};

                    // Round increment: guard_bit AND (round_bit OR sticky_bit OR LSB)
                    round_increment <= guard_bit && (round_bit || sticky_bit || norm_mantissa_product[24]);

                    // Add rounding
                    rounded_mantissa_pre <= {1'b0, norm_mantissa_product[47:24]} + (round_increment ? 25'd1 : 25'd0);

                    // Check carry out (bit 24)
                    mantissa_carry <= ( ( {1'b0, norm_mantissa_product[47:24]} + (round_increment ? 25'd1 : 25'd0) ) >> 24 ) & 1'b1;

                    // Final mantissa and exponent after rounding
                    if (mantissa_carry) begin
                        final_mantissa <= ( ( {1'b0, norm_mantissa_product[47:24]} + (round_increment ? 25'd1 : 25'd0) ) >> 1 )[22:0];
                        final_exponent_pre <= norm_exponent + 10'd1;
                    end else begin
                        final_mantissa <= ( ( {1'b0, norm_mantissa_product[47:24]} + (round_increment ? 25'd1 : 25'd0) ) )[22:0];
                        final_exponent_pre <= norm_exponent;
                    end

                    // Overflow and underflow checks
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    // Clamp final exponent to 8 bits
                    if (exponent_overflow)
                        final_exponent <= 8'hFF;
                    else if (exponent_underflow)
                        final_exponent <= 8'd0;
                    else
                        final_exponent <= final_exponent_pre[7:0];

                end else begin
                    final_mantissa <= 23'd0;
                    final_exponent <= 8'd0;
                    exponent_overflow <= 1'b0;
                    exponent_underflow <= 1'b0;
                end
                counter <= 3'd5;
            end
            3'd5: begin
                // Assemble output based on special cases and normal result
                if (special_case_flag) begin
                    z <= special_case_result;
                end else if (a_inf || b_inf) begin
                    // If zero_inf_conflict would have been caught earlier by special_case_flag
                    // Inf * non-zero => Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (a_zero || b_zero) begin
                    // Zero * anything (except inf) => zero
                    z <= {z_sign, 31'd0};
                end else begin
                    if (exponent_overflow) begin
                        // Overflow => Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (exponent_underflow) begin
                        // Underflow => zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal output
                        z <= {z_sign, final_exponent, final_mantissa};
                    end
                end
                counter <= 3'd6;
            end
            3'd6: begin
                // Hold output stable, wait for next inputs
                // Loop back for next operation
                counter <= 3'd0;
            end
            default: counter <= 3'd0;
            endcase
        end
    end

endmodule