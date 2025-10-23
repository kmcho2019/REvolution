module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_MIN  = 8'h00;

    // Cycle counter for sequencing
    reg [2:0] counter;

    // Internal registers for extracted fields
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [22:0] a_fraction, b_fraction;

    // Internal mantissas with leading bit (24 bits)
    reg [23:0] a_mantissa, b_mantissa;
    reg [9:0] a_exp_ext, b_exp_ext; // extended exponent (for addition and underflow handling)

    // Special case flags for inputs
    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    // Product of mantissas (24x24=48 bits)
    reg [47:0] product;

    // Signs and exponent of result (intermediate)
    reg z_sign;
    reg [9:0] z_exponent;

    // Normalized mantissa and rounding bits
    reg [23:0] norm_mantissa;      // 24 bits, leading 1 + fraction
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa (23 bits fraction after rounding)
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent;

    // Flags for exponent overflow/underflow
    reg exponent_overflow, exponent_underflow;

    // Sticky bit accumulator for rounding (OR of bits shifted out)
    reg sticky_acc;

    // Signals for leading 1 detection of product (bit 47 or 46)
    wire product_msb = product[47];

    // Rounding increment signal
    reg round_increment;

    // Temporary values for rounded mantissa
    reg [24:0] mantissa_25bit;

    // Output register (z) updated in last cycle

    // Combinational signals for special cases (extracted from registers)
    wire is_a_zero = a_zero;
    wire is_a_denormal = a_denormal;
    wire is_a_inf = a_inf;
    wire is_a_nan = a_nan;

    wire is_b_zero = b_zero;
    wire is_b_denormal = b_denormal;
    wire is_b_inf = b_inf;
    wire is_b_nan = b_nan;

    // FSM: multi-cycle operation
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear internal regs
            a_sign <= 1'b0;
            a_exponent <= 8'd0;
            a_fraction <= 23'd0;
            b_sign <= 1'b0;
            b_exponent <= 8'd0;
            b_fraction <= 23'd0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exp_ext <= 10'd0;
            b_exp_ext <= 10'd0;

            a_zero <= 1'b0;
            a_denormal <= 1'b0;
            a_inf <= 1'b0;
            a_nan <= 1'b0;
            b_zero <= 1'b0;
            b_denormal <= 1'b0;
            b_inf <= 1'b0;
            b_nan <= 1'b0;

            product <= 48'd0;

            z_sign <= 1'b0;
            z_exponent <= 10'd0;

            norm_mantissa <= 24'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            final_mantissa <= 23'd0;
            final_exponent <= 10'd0;

            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;

            sticky_acc <= 1'b0;

            round_increment <= 1'b0;

            mantissa_25bit <= 25'd0;

        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Extract sign, exponent, fraction and special cases from inputs
                    a_sign <= a[31];
                    a_exponent <= a[30:23];
                    a_fraction <= a[22:0];

                    b_sign <= b[31];
                    b_exponent <= b[30:23];
                    b_fraction <= b[22:0];

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

                    // Prepare mantissas with implicit leading 1 for normal numbers, 0 otherwise
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Prepare extended exponents: for zero/denormals treated as 1
                    a_exp_ext <= (a[30:23] == 8'd0) ? 10'd1 : {2'd0, a[30:23]};
                    b_exp_ext <= (b[30:23] == 8'd0) ? 10'd1 : {2'd0, b[30:23]};

                    // Compute sign of result
                    z_sign <= a[31] ^ b[31];

                    counter <= counter + 3'd1;
                end

                3'd1: begin
                    // Cycle 1: Mantissa multiplication (24x24)
                    product <= a_mantissa * b_mantissa;

                    // Calculate preliminary exponent sum (subtract bias)
                    z_exponent <= a_exp_ext + b_exp_ext - EXP_BIAS;

                    counter <= counter + 3'd1;
                end

                3'd2: begin
                    // Cycle 2: Normalization and rounding prep

                    // Normalize: if MSB (bit 47) of product is 1, product >= 2.0, shift right by 1 and increment exponent
                    if (product[47]) begin
                        // MSB=1, use bits [47:24] as mantissa
                        norm_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 10'd1;
                        // Rounding bits: guard, round, sticky from bits [23], [22], [21:0]
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_acc <= |product[21:0];
                    end else begin
                        // MSB=0, shift product left 1 to normalize
                        norm_mantissa <= product[46:23] << 1; // product[46:23] are 24 bits (bit 46 down to 23)
                        // z_exponent unchanged
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_acc <= |product[20:0];
                    end

                    sticky_bit <= sticky_acc;

                    // Prepare round increment calculation next cycle
                    counter <= counter + 3'd1;
                end

                3'd3: begin
                    // Cycle 3: Rounding and final exponent adjustment

                    // Compute round increment: round to nearest even
                    round_increment <= guard_bit && (round_bit | sticky_bit | norm_mantissa[0]);

                    // Add round increment to mantissa (25 bits to catch carry)
                    mantissa_25bit <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check carry out (bit 24) after rounding
                    if (mantissa_25bit[24]) begin
                        // Carry out means shift mantissa right 1 and increment exponent
                        final_mantissa <= mantissa_25bit[24:2]; // bits [24:2] (23 bits)
                        final_exponent <= z_exponent + 10'd1;
                    end else begin
                        // No carry, use mantissa lower bits as is
                        final_mantissa <= mantissa_25bit[22:0];
                        final_exponent <= z_exponent;
                    end

                    counter <= counter + 3'd1;
                end

                3'd4: begin
                    // Cycle 4: Final output generation with special case handling

                    // Check overflow and underflow
                    exponent_overflow <= (final_exponent >= 10'd255);
                    exponent_underflow <= (final_exponent <= 10'd0);

                    // Resolve special cases and assemble output
                    if (a_nan || b_nan) begin
                        // Quiet NaN: sign=0, exp=255, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf*0 or 0*Inf => NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero => Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero * anything => zero with sign
                        z <= {z_sign, 31'd0};
                    end else if (exponent_overflow) begin
                        // Overflow => Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (exponent_underflow) begin
                        // Underflow => zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal output
                        z <= {z_sign, final_exponent[7:0], final_mantissa};
                    end

                    counter <= 3'd0; // ready for next operation
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule