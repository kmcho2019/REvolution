module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent; // extended width for exponent calculations and overflow detection
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24 bits to include implicit leading 1

    reg [49:0] product; // 24x24 bits = 48 bits + 2 for rounding guard bits
    reg guard_bit, round_bit, sticky;

    // Flags for special cases
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Parameters for IEEE 754 single precision
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_ZERO = 8'h00;

    // Wires for field extraction
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Detect zero, inf, nan on inputs
    wire a_exp_all_ones = (a_exp == EXP_MAX);
    wire b_exp_all_ones = (b_exp == EXP_MAX);
    wire a_exp_zero = (a_exp == EXP_ZERO);
    wire b_exp_zero = (b_exp == EXP_ZERO);

    // Helper: fraction zero
    wire a_frac_zero = (a_frac == 0);
    wire b_frac_zero = (b_frac == 0);

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
            z_sign <= 0;
            z_exponent <= 0;
            z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            a_is_zero <= 0;
            b_is_zero <= 0;
            a_is_inf <= 0;
            b_is_inf <= 0;
            a_is_nan <= 0;
            b_is_nan <= 0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign bits
                    a_sign <= a_s;
                    b_sign <= b_s;
                    z_sign <= a_s ^ b_s;

                    // Extract exponents and convert to extended width
                    a_exponent <= {2'b00, a_exp}; // 10 bits for exponent calculation headroom
                    b_exponent <= {2'b00, b_exp};

                    // Special cases detect
                    a_is_zero <= (a_exp_zero && a_frac_zero);
                    b_is_zero <= (b_exp_zero && b_frac_zero);
                    a_is_inf <= (a_exp_all_ones && a_frac_zero);
                    b_is_inf <= (b_exp_all_ones && b_frac_zero);
                    a_is_nan <= (a_exp_all_ones && !a_frac_zero);
                    b_is_nan <= (b_exp_all_ones && !b_frac_zero);

                    // Mantissa prep: add implicit leading 1 if normalized, else zero for denormals or zero
                    a_mantissa <= (a_exp_zero) ? {1'b0, a_frac} : {1'b1, a_frac}; // 24 bits
                    b_mantissa <= (b_exp_zero) ? {1'b0, b_frac} : {1'b1, b_frac};

                    counter <= 3'd1;

                    // Reset product and outputs for next stages
                    product <= 0;
                    z_exponent <= 0;
                    z_mantissa <= 0;
                    guard_bit <= 0;
                    round_bit <= 0;
                    sticky <= 0;
                end

                3'd1: begin
                    // Handle special cases and early result

                    // NaN cases: if either input is NaN => output NaN
                    if (a_is_nan || b_is_nan) begin
                        // Output a quiet NaN: exponent all ones, mantissa nonzero
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // quiet NaN with MSB mantissa bit set
                        counter <= 3'd0;
                    end
                    // Inf * zero = NaN
                    else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // quiet NaN
                        counter <= 3'd0;
                    end
                    // Inf * nonzero => Inf
                    else if (a_is_inf || b_is_inf) begin
                        // Sign = xor inputs
                        z <= {z_sign, 8'hFF, 23'b0};
                        counter <= 3'd0;
                    end
                    // Zero * anything = zero (except handled above)
                    else if (a_is_zero || b_is_zero) begin
                        // Result zero with correct sign
                        z <= {z_sign, 31'b0};
                        counter <= 3'd0;
                    end
                    else begin
                        // Normal multiplication path

                        // Add exponents and subtract bias: exponent = a_exp + b_exp - bias
                        // Remember a_exponent and b_exponent are 10 bits with leading zeros
                        z_exponent <= a_exponent + b_exponent - EXP_BIAS;

                        // Multiply mantissas: 24 bits x 24 bits = 48 bits product
                        product <= a_mantissa * b_mantissa;

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Normalize product mantissa and adjust exponent

                    // product is 48 bits; the high bits determine normalization
                    // product format:
                    // product[47:24] = upper 24 bits (mantissa candidate)
                    // product[23:0] = lower bits for rounding

                    // Check leading bit at product[47]
                    if (product[47]) begin
                        // MSB 1 means product is normalized (1.xxxx)
                        // Mantissa is bits [46:24] (23 bits) + rounding bits [23:0]
                        // We shift right by 1 is not needed because MSB is already 1 at bit 47

                        // Mantissa before rounding is bits [46:24]
                        z_mantissa <= product[46:24];

                        // Rounding bits: guard = bit 23, round = bit 22, sticky = OR bits [21:0]
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];

                        // Exponent increment because leading bit is at bit 47
                        z_exponent <= z_exponent + 1;
                    end else begin
                        // Leading 1 is at bit 46 (normalized after shift left 1)
                        // Shift left mantissa by 1 to normalize
                        z_mantissa <= product[45:23];

                        // Rounding bits after shift: guard = bit 22, round = bit 21, sticky = OR bits [20:0]
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];

                        // Exponent no increment
                        // z_exponent unchanged
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding: round to nearest even

                    // Calculate round increment
                    // Round up if guard bit = 1 and (round bit or sticky bit or lsb of mantissa is 1)
                    // This implements round to nearest, ties to even
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        {z_mantissa, z_exponent} <= ({1'b0, z_mantissa} + 1'b1 == 25'b1000000000000000000000000) ?
                            // Mantissa overflowed (24 bits all 0, carry out 1)
                            // shift mantissa right by 1 and increment exponent
                            {24'b100000000000000000000000, z_exponent + 1} :
                            {z_mantissa + 1'b1, z_exponent};
                    end

                    // No rounding increment needed: mantissa and exponent unchanged

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Handle overflow and underflow

                    if (z_exponent >= (EXP_MAX << 2)) begin
                        // Exponent overflow: output infinity
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent[7:0] >= EXP_MAX) begin
                        // Clamp exponent to max (overflow)
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent[7:0] <= 0) begin
                        // Underflow: output zero (flush to zero)
                        z <= {z_sign, 31'b0};
                    end else begin
                        // Normal output assembly
                        // Mantissa: remove implicit leading 1 for normalized numbers
                        // z_mantissa is 24 bits with implicit leading 1 at MSB

                        // IEEE 754 mantissa = bits [22:0] excluding the implicit 1
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule