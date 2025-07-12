module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Cycle counter
    reg [2:0] counter;

    // Sign bits
    reg a_sign, b_sign, z_sign;

    // Exponents (wider width for intermediate calculation to avoid overflow)
    reg [9:0] a_exponent, b_exponent, z_exponent;

    // Mantissas: 24 bits (23 fraction + implicit leading 1)
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;

    // Product of mantissas: 24x24 = 48 bits + some extra bits for rounding (50 bits total)
    reg [49:0] product;

    // Rounding control bits
    reg guard_bit, round_bit, sticky;

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Internal signals for normalization shift count
    reg [5:0] norm_shift;  // up to 50 bits, so max 50 shift

    // Bias for IEEE 754 single precision exponent
    localparam BIAS = 127;

    // Pre-extract inputs for easier use
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Helper function to detect NaN and Infinity
    function is_nan;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_nan = (exp == 8'hFF) && (frac != 0);
        end
    endfunction

    function is_inf;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_inf = (exp == 8'hFF) && (frac == 0);
        end
    endfunction

    function is_zero;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_zero = (exp == 0) && (frac == 0);
        end
    endfunction

    // Normalize function shifts mantissa left until MSB at bit 47 and adjusts exponent accordingly.
    // Returns normalized mantissa in product and updated exponent
    // This will be unrolled in FSM with code; no separate function for shifting with sticky bits.

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'b0;
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            z_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            a_zero <= 0;
            b_zero <= 0;
            a_inf <= 0;
            b_inf <= 0;
            a_nan <= 0;
            b_nan <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa and flags
                    a_sign <= a_s;
                    b_sign <= b_s;

                    a_exponent <= {2'b00, a_exp}; // widen to 10 bits
                    b_exponent <= {2'b00, b_exp};

                    // Handle zero and subnormal: if exponent==0, mantissa no implicit 1
                    a_zero <= is_zero(a_exp, a_frac);
                    b_zero <= is_zero(b_exp, b_frac);
                    a_inf <= is_inf(a_exp, a_frac);
                    b_inf <= is_inf(b_exp, b_frac);
                    a_nan <= is_nan(a_exp, a_frac);
                    b_nan <= is_nan(b_exp, b_frac);

                    // Mantissa with implicit leading 1 if exponent != 0, else 0
                    a_mantissa <= (a_exp == 8'b0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'b0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Reset output to 0 for now
                    z <= 32'b0;

                    counter <= counter + 1'b1;
                end

                3'd1: begin
                    // Handle special cases

                    // NaN if either input is NaN
                    if (a_nan || b_nan) begin
                        // Produce QNaN: sign = 0, exponent all 1s, MSB fraction 1
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        counter <= 3'd0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        counter <= 3'd0;
                    end else if (a_inf || b_inf) begin
                        // Infinity * finite (non-zero) = infinity
                        // sign = XOR signs
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'd255; // all ones for exponent
                        z_mantissa <= 24'b0;
                        // Compose output
                        z <= {z_sign, 8'hFF, 23'b0};
                        counter <= 3'd0;
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'd0;
                        z_mantissa <= 24'b0;
                        z <= {z_sign, 8'd0, 23'd0};
                        counter <= 3'd0;
                    end else begin
                        // Normal multiplication path
                        // Compute sign of result
                        z_sign <= a_sign ^ b_sign;

                        // Adjust exponents by subtracting bias (127) later after sum
                        counter <= counter + 1'b1;
                    end
                end

                3'd2: begin
                    // Multiply mantissas: 24x24 bits = 48 bits product stored in 50 bits product reg (bits [47:0])
                    // We keep product in bits [47:0], upper bits zero
                    // product = a_mantissa * b_mantissa
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias: result exponent = a_exp + b_exp - bias
                    // a_exponent and b_exponent are 10 bits now to prevent overflow
                    // Subtract bias once
                    z_exponent <= a_exponent + b_exponent - BIAS;

                    counter <= counter + 1'b1;
                end

                3'd3: begin
                    // Normalize product
                    // The product mantissa is 48 bits (bits 47 down to 0)
                    // If highest bit is 1 at bit 47, product is already normalized with implicit leading 1 at bit 47
                    // Else, shift left by 1 and decrement exponent
                    // Mantissa final is 24 bits (to keep) with rounding bits after those

                    // Check MSB (bit 47)
                    if (product[47]) begin
                        // MSB is 1, normalized
                        z_mantissa <= product[46:23]; // take bits 46 down to 23 as mantissa (24 bits)
                        // guard bit = bit 22, round bit = bit 21, sticky = OR bits 20 down to 0
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                        // exponent stays as is
                        z_exponent <= z_exponent;
                    end else begin
                        // MSB not set, shift left by 1 (normalize)
                        product <= product << 1;
                        z_exponent <= z_exponent - 1'b1;

                        // After shift, take mantissa bits and rounding bits similarly
                        z_mantissa <= (product << 1)[46:23]; // after shift
                        guard_bit <= (product << 1)[22];
                        round_bit <= (product << 1)[21];
                        sticky <= |(product << 1)[20:0];
                    end

                    counter <= counter + 1'b1;
                end

                3'd4: begin
                    // Rounding - Round to nearest even
                    // If guard bit == 1
                    // and (round bit or sticky bit == 1 or mantissa LSB == 1) then add 1 to mantissa

                    reg [23:0] mantissa_rounded;
                    mantissa_rounded = z_mantissa;

                    if (guard_bit) begin
                        if (round_bit | sticky | z_mantissa[0]) begin
                            mantissa_rounded = z_mantissa + 1'b1;
                        end
                    end

                    // Check mantissa overflow after rounding (24 bits can overflow into 25th bit)
                    if (mantissa_rounded[23] == 1'b0 && mantissa_rounded == 24'hFFFFFF + 1) begin
                        // If overflow (mantissa_rounded becomes 0 after increment?), actually mantissa_rounded[23] is MSB
                        // Correction: mantissa is 24 bits. Overflow means mantissa_rounded > 24'hFFFFFF (all ones)
                        // So check if mantissa_rounded == 24'h1000000 (25 bits)
                        // Can't be represented in 24 bits, so shift right by 1 and increase exponent

                        // For safety, we test if mantissa_rounded == 24'h1000000, so actually 25 bits needed
                        // Since mantissa_rounded is 24 bits, this can't happen, but if adding 1 overflows,
                        // it will wrap to zero. To detect this, check if mantissa_rounded == 0 after incrementing from max.
                        if (mantissa_rounded == 24'd0) begin
                            // Overflow, shift right by 1, increment exponent
                            mantissa_rounded = mantissa_rounded >> 1;
                            z_exponent <= z_exponent + 1'b1;
                        end
                    end else if (mantissa_rounded == 24'h1000000) begin
                        // If mantissa_rounded reached 25 bits
                        mantissa_rounded = mantissa_rounded >> 1;
                        z_exponent <= z_exponent + 1'b1;
                    end

                    z_mantissa <= mantissa_rounded;

                    counter <= counter + 1'b1;
                end

                3'd5: begin
                    // Final output compose

                    // Handle exponent overflow or underflow
                    if (z_exponent >= 10'd255) begin
                        // Overflow -> infinity
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent <= 0) begin
                        // Underflow -> zero
                        z <= {z_sign, 8'd0, 23'd0};
                    end else begin
                        // Normal number output
                        // Remove implicit leading 1 from mantissa: mantissa is 24 bits with MSB as implicit 1
                        // IEEE 754 fractional bits are bits 22 down to 0, so take z_mantissa[22:0]
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd0; // ready for next multiplication
                end

                default: begin
                    counter <= 3'd0;
                    z <= 32'b0;
                end
            endcase
        end
    end

endmodule