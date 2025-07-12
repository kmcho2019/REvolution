module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Counter for operation step (0 to 5)
    reg [2:0] counter;

    // Internal registers for extracted fields
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [7:0] z_exponent;
    reg [22:0] a_fraction, b_fraction;
    reg [23:0] a_mantissa; // 24 bits (implicit leading 1 if normalized)
    reg [23:0] b_mantissa;

    // Special case flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Intermediate signals
    reg [9:0] exp_sum;     // 10 bits for sum + adjustments
    reg [47:0] product;    // 24x24-bit product mantissa
    reg [23:0] norm_mantissa; // normalized mantissa 24 bits
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Rounded result
    reg [24:0] mantissa_rounded; // 25 bits to detect overflow after rounding
    reg [9:0] exponent_rounded;

    // Rounding helper signals
    wire round_increment;
    wire round_sticky_or_lsb;

    // Intermediate signals for sticky bit calculation
    reg sticky_or_lower_bits;

    // Cycle operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Reset all internal registers
            a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
            a_exponent <= 8'd0; b_exponent <= 8'd0; z_exponent <= 8'd0;
            a_fraction <= 23'd0; b_fraction <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_is_zero <= 1'b0; b_is_zero <= 1'b0;
            a_is_inf <= 1'b0; b_is_inf <= 1'b0;
            a_is_nan <= 1'b0; b_is_nan <= 1'b0;
            exp_sum <= 10'd0;
            product <= 48'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;
            sticky_or_lower_bits <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Idle state: wait for inputs, clear output
                    z <= 32'd0;
                    counter <= 3'd1;
                end

                3'd1: begin
                    // Extract inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_fraction <= a[22:0];
                    b_fraction <= b[22:0];

                    // Detect special cases
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_is_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas (add implicit leading 1 if normalized, else zero for denormals)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Compute sign of result
                    z_sign <= a[31] ^ b[31];

                    // Reset intermediate signals
                    product <= 48'd0;
                    exp_sum <= 10'd0;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Multiply mantissas and sum exponents - bias
                    product <= a_mantissa * b_mantissa;
                    exp_sum <= a_exponent + b_exponent - EXP_BIAS;

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Normalize product
                    if (product[47]) begin
                        // Leading 1 at bit 47, product is >= 2.0, shift right by 1
                        norm_mantissa <= product[47:24]; // top 24 bits after shift
                        norm_exponent <= exp_sum + 1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // Leading 1 at bit 46 or below, no shift
                        norm_mantissa <= product[46:23]; // top 24 bits
                        norm_exponent <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Round mantissa according to round-to-nearest-even
                    // Round if guard=1 and (round=1 or sticky=1 or LSB=1)
                    // LSB of mantissa is norm_mantissa[0]
                    if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                        mantissa_rounded <= norm_mantissa + 1;
                    else
                        mantissa_rounded <= norm_mantissa;

                    exponent_rounded <= norm_exponent;

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Final adjustments and output assembly

                    // Adjust exponent and mantissa if mantissa overflowed after rounding
                    if (mantissa_rounded[24]) begin
                        exponent_rounded <= exponent_rounded + 1;
                    end

                    // Handle special cases: NaN, Inf, Zero, overflow, underflow
                    if (a_is_nan || b_is_nan) begin
                        // Quiet NaN: sign=0, exp=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Result is Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Result zero with sign
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal case
                        if (exponent_rounded >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exponent_rounded <= 0) begin
                            // Underflow to zero (no subnormal support here)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal number, drop mantissa overflow bit if set
                            if (mantissa_rounded[24])
                                z <= {z_sign, exponent_rounded[7:0], mantissa_rounded[23:1]};
                            else
                                z <= {z_sign, exponent_rounded[7:0], mantissa_rounded[22:0]};
                        end
                    end

                    counter <= 3'd0; // ready for next inputs
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule