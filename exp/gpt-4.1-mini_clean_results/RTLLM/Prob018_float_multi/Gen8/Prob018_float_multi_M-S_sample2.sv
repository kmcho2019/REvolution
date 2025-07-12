module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;

    // Cycle counter: controls operation sequencing
    reg [2:0] counter;

    // Extracted input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special flags for inputs
    reg a_zero, a_inf, a_nan, a_denorm;
    reg b_zero, b_inf, b_nan, b_denorm;

    // Intermediate mantissas (with implicit leading bit)
    reg [23:0] a_mantissa, b_mantissa;

    // Sign, exponent, mantissa of result
    reg z_sign;
    reg [9:0] z_exponent;  // extended width for calculations
    reg [23:0] z_mantissa;

    // Mantissa product: 24x24 bits = 48 bits product stored in 50 bits reg (for convenience)
    reg [47:0] product;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Flags for normalization shifts
    reg product_msb;

    // Internal normalized mantissa and exponent (after normalization and rounding)
    reg [24:0] mantissa_rounded; // one bit wider for possible carry
    reg [9:0] exponent_rounded;

    // Internal wires for sticky bit calculation in round stage
    reg [21:0] sticky_part;

    // Special case handling signals for result
    reg special_nan, special_inf, special_zero, special_nan_for_0inf;

    // Step 1: Input extraction and special case detection
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear intermediate registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_zero <= 1'b0; a_inf <= 1'b0; a_nan <= 1'b0; a_denorm <= 1'b0;
            b_zero <= 1'b0; b_inf <= 1'b0; b_nan <= 1'b0; b_denorm <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;
            special_nan <= 1'b0; special_inf <= 1'b0; special_zero <= 1'b0; special_nan_for_0inf <= 1'b0;
        end else begin
            case(counter)
            3'd0: begin
                // Extract sign, exp, frac
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_frac <= a[22:0];
                b_frac <= b[22:0];

                // Detect special cases for a
                a_zero <= (a[30:0] == 31'd0);
                a_inf <= (a_exp == 8'hFF) && (a_frac == 23'd0);
                a_nan <= (a_exp == 8'hFF) && (a_frac != 23'd0);
                a_denorm <= (a_exp == 8'd0) && (a_frac != 23'd0);

                // Detect special cases for b
                b_zero <= (b[30:0] == 31'd0);
                b_inf <= (b_exp == 8'hFF) && (b_frac == 23'd0);
                b_nan <= (b_exp == 8'hFF) && (b_frac != 23'd0);
                b_denorm <= (b_exp == 8'd0) && (b_frac != 23'd0);

                // Prepare mantissas with implicit leading 1 if normal, 0 if denorm/zero
                a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // Compute sign of result
                z_sign <= a[31] ^ b[31];

                counter <= 3'd1;
            end

            3'd1: begin
                // Handle special cases preliminary flags
                // special_nan: if either input is NaN
                special_nan <= a_nan || b_nan;

                // special_nan_for_0inf: Inf*0 or 0*Inf produces NaN
                special_nan_for_0inf <= ( (a_inf && b_zero) || (b_inf && a_zero) );

                // special_inf: either input is inf and no conflicting zero case
                special_inf <= (a_inf || b_inf) && !(special_nan_for_0inf);

                // special_zero: either input zero and no conflicting inf case
                special_zero <= (a_zero || b_zero) && !(special_nan_for_0inf);

                // Compute adjusted exponents (denormals treated as exponent 1)
                // Store extended exponents for addition in 10-bit registers
                z_exponent <= ((a_exp == 0) ? 10'd1 : {2'd0, a_exp}) + ((b_exp == 0) ? 10'd1 : {2'd0, b_exp}) - EXP_BIAS;

                // Multiply mantissas: 24x24 -> 48 bits product
                product <= a_mantissa * b_mantissa;

                counter <= 3'd2;
            end

            3'd2: begin
                // Normalize product and prepare for rounding

                product_msb <= product[47];
                if (product[47]) begin
                    // If MSB set, product >= 2.0, shift right by 1 (keep bits [47:24])
                    z_mantissa <= product[47:24];
                    z_exponent <= z_exponent + 10'd1;
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_part <= product[21:0];
                end else begin
                    // MSB not set, shift left by 1: product < 2.0 but >= 1.0 after shift
                    // mantissa is bits [46:23]
                    z_mantissa <= product[46:23];
                    // exponent unchanged
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_part <= product[20:0];
                end

                // Calculate sticky bit: OR of all sticky_part bits
                sticky_bit <= (|sticky_part);

                counter <= 3'd3;
            end

            3'd3: begin
                // Perform rounding: Round to nearest even

                // Determine if rounding increment is needed
                // Round increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                if (guard_bit && (round_bit || sticky_bit || z_mantissa[0])) begin
                    mantissa_rounded <= {1'b0, z_mantissa} + 25'd1;
                end else begin
                    mantissa_rounded <= {1'b0, z_mantissa};
                end

                exponent_rounded <= z_exponent;

                counter <= 3'd4;
            end

            3'd4: begin
                // Check if rounding caused carry out (bit 24)
                if (mantissa_rounded[24]) begin
                    // Shift mantissa right by 1, increment exponent
                    z_mantissa <= mantissa_rounded[24:2]; // 23 bits mantissa
                    z_exponent <= exponent_rounded + 10'd1;
                end else begin
                    // No carry, mantissa is lower 23 bits
                    z_mantissa <= mantissa_rounded[22:0];
                    z_exponent <= exponent_rounded;
                end

                counter <= 3'd5;
            end

            3'd5: begin
                // Handle overflow, underflow and special cases, and generate final result z

                // Exponent overflow and underflow flags
                wire exponent_overflow = (z_exponent >= 10'd255);
                wire exponent_underflow = (z_exponent <= 10'd0);

                if (special_nan) begin
                    // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_nan_for_0inf) begin
                    // Inf * 0 or 0 * Inf = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Inf * non-zero = Inf with sign
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero * non-inf = zero with sign
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal or denormal result
                    if (exponent_overflow) begin
                        // Overflow -> Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (exponent_underflow) begin
                        // Underflow -> zero (flush)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal result
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                end

                // After output, reset counter to start new operation
                counter <= 3'd0;
            end

            default: counter <= 3'd0;
            endcase
        end
    end

endmodule