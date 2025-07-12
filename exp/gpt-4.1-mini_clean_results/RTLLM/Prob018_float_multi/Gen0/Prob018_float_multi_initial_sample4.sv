module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers and wires
    reg [2:0] counter;

    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [7:0] z_exponent;
    reg [23:0] a_mantissa, b_mantissa;
    reg [49:0] product;
    reg z_sign;

    reg [23:0] z_mantissa;

    // Special cases flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate pipeline registers for rounding and normalization
    reg [49:0] product_r;
    reg [9:0] exponent_r;
    reg sign_r;
    reg [2:0] guard_round_sticky; // guard, round, sticky bits for rounding

    // Extract fields from input operands
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Bias for exponent
    localparam EXP_BIAS = 127;

    // Detect zero, inf, nan
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Temporary variables for rounding and normalization
    reg [49:0] shifted_product;
    reg [9:0] exponent_after_norm;
    reg normalization_shifted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Reset internal regs
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            product <= 50'd0;
            z_sign <= 1'b0;
            z_exponent <= 8'd0;
            z_mantissa <= 24'd0;

            product_r <= 50'd0;
            exponent_r <= 10'd0;
            sign_r <= 1'b0;
            guard_round_sticky <= 3'b000;
        end else begin
            case(counter)
            3'd0: begin
                // Cycle 0: Extract fields and special case detection

                a_sign <= a_s;
                b_sign <= b_s;

                a_exponent <= a_exp;
                b_exponent <= b_exp;

                // Compose mantissa with implicit leading 1 for normalized numbers
                // For denormals (exponent == 0), mantissa is fraction only (no leading 1)
                a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // We'll handle zero and special cases later during output

                counter <= 3'd1;
            end
            3'd1: begin
                // Cycle 1: Multiply mantissas and add exponents

                // Multiply 24-bit mantissas -> 48-bit product (stored in 50-bit for guard bits)
                product <= a_mantissa * b_mantissa; // 24x24 = 48 bits result stored at lower bits

                // Determine sign of result
                z_sign <= a_sign ^ b_sign;

                // Exponent addition: add input exponents and subtract bias
                // Extend to 10 bits for possible exponent overflow handling
                exponent_r <= a_exponent + b_exponent - EXP_BIAS;

                counter <= 3'd2;
            end
            3'd2: begin
                // Cycle 2: Normalize product and extract rounding bits

                product_r <= product;

                // Product is 48 bits, but stored in 50 bits. The product lies in bits [47:0].
                // Check if MSB (bit 47) of product is 1 (means product >= 2)
                // If yes, shift right by 1 and increase exponent by 1.
                if (product[47] == 1'b1) begin
                    shifted_product = product >> 1;
                    exponent_after_norm = exponent_r + 10'd1;
                    normalization_shifted = 1'b1;
                end else begin
                    shifted_product = product;
                    exponent_after_norm = exponent_r;
                    normalization_shifted = 1'b0;
                end

                // Extract mantissa bits [46:24] (23 bits fraction), 
                // IEEE format mantissa is 23 bits but we have a leading 1 implicit, so store 24 bits (leading 1 included)
                // But in product, the leading 1 is at bit 46 (if normalized to [47] shifted), so mantissa is bits [46:24]

                // Extract mantissa with leading 1 at bit 23
                // We'll store mantissa as 24 bits with leading 1 explicit

                // For rounding bits:
                // guard bit: bit 23
                // round bit: bit 22
                // sticky bit: OR of bits 21 down to 0

                guard_bit = shifted_product[23];
                round_bit = shifted_product[22];
                sticky_bit = |shifted_product[21:0];

                guard_round_sticky <= {guard_bit, round_bit, sticky_bit};

                z_mantissa <= shifted_product[46:23]; // 24 bits mantissa (leading 1 bit included)

                exponent_r <= exponent_after_norm;
                counter <= 3'd3;
            end
            3'd3: begin
                // Cycle 3: Rounding and final adjustments

                // Round to nearest even
                // Round if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)
                // else truncate.

                // Round increment flag
                reg round_increment;
                round_increment = 0;

                if (guard_round_sticky[2] == 1'b1) begin // guard bit
                    if (guard_round_sticky[1] || guard_round_sticky[0] || (z_mantissa[0] == 1'b1)) begin
                        round_increment = 1'b1;
                    end
                end

                // Apply rounding
                {z_sign, z_exponent, z_mantissa} = {sign_r, exponent_r[7:0], z_mantissa};

                if (round_increment) begin
                    // Add 1 to mantissa
                    reg [24:0] mantissa_plus; // 25 bits to detect overflow
                    mantissa_plus = {1'b0, z_mantissa} + 25'd1;
                    if (mantissa_plus[24] == 1'b1) begin
                        // Mantissa overflow, shift right by 1, increment exponent
                        z_mantissa = mantissa_plus[24:1];
                        z_exponent = z_exponent + 1;
                    end else begin
                        z_mantissa = mantissa_plus[23:0];
                    end
                end

                // Handle special cases

                // Check for input NaN
                if (a_is_nan || b_is_nan) begin
                    // Output NaN: exponent all ones, mantissa non-zero (quiet NaN: leading mantissa bit set)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Inf * 0 = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (a_is_inf || b_is_inf) begin
                    // Inf times normal/nonzero = Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (a_is_zero || b_is_zero) begin
                    // Zero times anything = zero
                    z <= {z_sign, 31'd0};
                end else begin
                    // Handle exponent overflow and underflow
                    if (z_exponent >= 8'hFF) begin
                        // Overflow, output infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exponent <= 0) begin
                        // Underflow, output zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        // Assemble final IEEE 754 format:
                        // sign(1), exponent(8), mantissa(23) (excluding leading 1)
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                end

                counter <= 3'd0;
            end
            default: begin
                counter <= 3'd0;
            end
            endcase
        end
    end

    // Pipeline register sign_r must be set on cycle 1 for use in cycle 3
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_r <= 1'b0;
        end else begin
            if (counter == 3'd1) begin
                sign_r <= a_sign ^ b_sign;
            end
        end
    end

endmodule