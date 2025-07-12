module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [2:0] counter;

    reg        a_sign, b_sign, z_sign;
    reg [9:0]  a_exponent, b_exponent, z_exponent;      // wider to handle sum and intermediate overflows
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;      // 1 implicit bit + 23 mantissa bits
    reg [49:0] product;                                 // 24x24 = 48 bits product + 2 extra for shifting

    // For rounding
    reg guard_bit, round_bit, sticky;

    // Internal signals for special cases
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Intermediate signals for normalization and rounding
    reg [49:0] normalized_product;
    reg [9:0]  normalized_exp;
    reg product_msb;

    // Helper wires
    wire [7:0] a_exp_raw = a[30:23];
    wire [7:0] b_exp_raw = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_sign_in = a[31];
    wire b_sign_in = b[31];

    // Constants
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam MANT_WIDTH = 23;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'd0;
            // Reset intermediate regs
            a_sign <= 0;
            b_sign <= 0;
            z_sign <= 0;
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
            a_is_nan <= 0;
            b_is_nan <= 0;
            a_is_inf <= 0;
            b_is_inf <= 0;
            a_is_zero <= 0;
            b_is_zero <= 0;
        end else begin
            case(counter)
            3'd0: begin
                // Extract signs
                a_sign <= a_sign_in;
                b_sign <= b_sign_in;
                z_sign <= a_sign_in ^ b_sign_in;

                // Extract exponents and mantissas with hidden leading 1 if normalized
                // Identify special cases

                a_is_nan  <= (a_exp_raw == EXP_MAX) && (a_frac != 0);
                b_is_nan  <= (b_exp_raw == EXP_MAX) && (b_frac != 0);

                a_is_inf  <= (a_exp_raw == EXP_MAX) && (a_frac == 0);
                b_is_inf  <= (b_exp_raw == EXP_MAX) && (b_frac == 0);

                a_is_zero <= (a_exp_raw == 0) && (a_frac == 0);
                b_is_zero <= (b_exp_raw == 0) && (b_frac == 0);

                // Set mantissas with hidden bit if normalized, else zero or denormalized
                a_mantissa <= (a_exp_raw == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp_raw == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // Store exponents as integer with bias included
                // For denormals exponent is zero, keep as zero
                a_exponent <= a_exp_raw;
                b_exponent <= b_exp_raw;

                counter <= counter + 1;
            end

            3'd1: begin
                // Handle special cases first: NaN propagation, zero and infinity rules
                
                if (a_is_nan) begin
                    // propagate NaN from a
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    counter <= 0;
                end else if (b_is_nan) begin
                    // propagate NaN from b
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    counter <= 0;
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Infinity times zero is NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    counter <= 0;
                end else if (a_is_inf || b_is_inf) begin
                    // infinity times non-zero non-NaN is infinity
                    z_exponent <= 8'hFF;
                    z_mantissa <= 0;
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, 8'hFF, 23'd0};
                    counter <= 0;
                end else if (a_is_zero || b_is_zero) begin
                    // zero times anything non-inf, non-NaN is zero
                    z_exponent <= 0;
                    z_mantissa <= 0;
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, 31'd0};
                    counter <= 0;
                end else begin
                    // Normal multiplication
                    // Multiply mantissas: 24 bits * 24 bits = 48 bits product
                    product <= a_mantissa * b_mantissa; // 24x24=48 bits, stored in 50 bits for extra room

                    // Add exponents and subtract bias
                    z_exponent <= a_exponent + b_exponent - EXP_BIAS;

                    counter <= counter + 1;
                end
            end

            3'd2: begin
                // Normalize product mantissa and adjust exponent
                // The product is 48 bits (stored in 50 bits for convenience)
                // The highest possible product_msb is bit 47 (indexing from 0)
                // Because mantissas have leading 1 for normalized inputs, max product has leading bit at position 47 or 46

                product_msb = product[47];

                if (product_msb) begin
                    // No shift needed, product in form 1.xxx... (bit 47 set)
                    normalized_product <= product;
                    normalized_exp <= z_exponent + 1; // because product is 2.xxx, we shift right one later
                end else begin
                    // Shift left one to normalize (leading 1 at bit 46)
                    normalized_product <= product << 1;
                    normalized_exp <= z_exponent;
                end

                counter <= counter + 1;
            end

            3'd3: begin
                // Extract rounding bits: mantissa will be bits [46:24] after shift if no shift, or [47:25] if shift done
                // After normalization mantissa is 24 bits starting from bit 46 or 47 depending on normalization
                // We pick bits for mantissa and bits for rounding (guard, round, sticky)

                // mantissa is 23 bits stored in bits [46:24], so assign 23 bits from normalized_product starting from bit 46 down
                // but since the mantissa field in IEEE754 is 23 bits fraction and 1 hidden leading bit, here we store 24 bits (including leading 1)
                // We will output 23 bits + hidden bit excluded

                // Guard bit: bit 23 below mantissa (bit 23)
                // Round bit: bit 22 below mantissa (bit 22)
                // Sticky bit: OR of all bits below round bit (bits 21 down to 0)

                // We'll pick bits according to normalization above

                // According to normalization step:

                // If normalized_exp was incremented (shift right 1 needed), then mantissa is bits [47:24]
                // Else bits [46:23]

                // Let's define a base index

                integer base_idx;

                base_idx = product_msb ? 47 : 46;

                z_mantissa <= normalized_product[base_idx -:24]; // bits [base_idx : base_idx-23]

                guard_bit <= normalized_product[base_idx - 24];
                round_bit <= normalized_product[base_idx - 25];

                // Sticky bit: OR of all bits from bit (base_idx - 26) down to 0

                sticky <= |normalized_product[base_idx - 26:0];

                normalized_exp <= normalized_exp;

                counter <= counter + 1;
            end

            3'd4: begin
                // Rounding: round to nearest even

                // Round if guard bit == 1 and (round_bit == 1 or sticky == 1 or LSB of mantissa == 1)

                if (guard_bit && (round_bit | sticky | (z_mantissa[0]))) begin
                    // Add 1 to mantissa
                    z_mantissa <= z_mantissa + 1;

                    // Check for mantissa overflow (carry out)
                    if (z_mantissa == 24'hFFFFFF) begin
                        // Mantissa overflow, shift right and increment exponent
                        z_mantissa <= (z_mantissa + 1) >> 1;
                        normalized_exp <= normalized_exp + 1;
                    end
                end

                counter <= counter + 1;
            end

            3'd5: begin
                // Check overflow/underflow after rounding

                if (normalized_exp >= 255) begin
                    // Overflow -> infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (normalized_exp <= 0) begin
                    // Underflow -> zero or denormals (not handling gradual underflow in detail here)
                    // Set zero for simplicity
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal case output
                    z <= {z_sign, normalized_exp[7:0], z_mantissa[22:0]};
                end

                counter <= 0;
            end

            default: begin
                counter <= 0;
            end

            endcase
        end
    end

endmodule