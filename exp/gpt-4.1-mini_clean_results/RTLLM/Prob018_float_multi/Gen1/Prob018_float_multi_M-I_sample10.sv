module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Constants
    localparam EXP_BIAS = 127;

    // FSM counter: 
    // 0 - load operands and preprocess
    // 1..24 - iterative multiply cycles
    // 25 - normalize, round, special case handling and output
    reg [4:0] counter;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [23:0] a_mantissa, b_mantissa; // 24 bits including leading 1 (or zero for denormals)

    // Intermediate signals
    reg [47:0] product; // 24-bit x 24-bit multiplication product accumulator (48 bits)
    reg [23:0] multiplicand;
    reg [23:0] multiplier;

    // Exponent and sign for result
    reg [9:0] exponent_sum; // 10-bit to allow overflow detection
    reg z_sign;

    // Normalization
    reg [47:0] normalized_product;
    reg [9:0] normalized_exponent;
    reg normalization_shifted;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Flags for special cases
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Sticky bit accumulator for multiply lower bits shifted out
    reg sticky_accum;

    // Temporary mantissa and exponent for final output
    reg [23:0] final_mantissa; // 24 bits including leading 1 explicit
    reg [9:0] final_exponent;
    reg final_sign;

    // --- Input fields extraction wires ---
    wire [7:0] a_exp = a[30:23];
    wire [22:0] a_frac = a[22:0];
    wire a_s = a[31];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] b_frac = b[22:0];
    wire b_s = b[31];

    // Detect special cases combinationally for inputs
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // --- Iterative multiplier implementation ---
    // product[47:0] accumulates partial sum
    // multiplicand: multiplicand (a_mantissa)
    // multiplier: multiplier (b_mantissa)
    // We'll multiply multiplicand * multiplier by testing LSB of multiplier in each cycle,
    // add multiplicand shifted accordingly to product, and shift multiplier right each cycle.

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            product <= 0;
            multiplicand <= 0;
            multiplier <= 0;
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            exponent_sum <= 0;
            z_sign <= 0;
            sticky_accum <= 0;

            // Output reset
            z <= 32'd0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            final_mantissa <= 24'd0;
            final_exponent <= 10'd0;
            final_sign <= 1'b0;

            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;
        end else begin
            case(counter)
            5'd0: begin
                // Cycle 0: Extract inputs, special case detect, prepare mantissa and exponent

                a_sign <= a_s;
                b_sign <= b_s;
                a_exponent <= a_exp;
                b_exponent <= b_exp;

                a_zero <= a_is_zero;
                b_zero <= b_is_zero;
                a_inf <= a_is_inf;
                b_inf <= b_is_inf;
                a_nan <= a_is_nan;
                b_nan <= b_is_nan;

                // Prepare mantissas: implicit leading 1 for normal numbers; zero for denormals
                a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // Prepare sign and exponent
                z_sign <= a_s ^ b_s;
                exponent_sum <= a_exp + b_exp - EXP_BIAS;

                // Initialize iterative multiplication registers
                product <= 48'd0;
                multiplicand <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                multiplier <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                sticky_accum <= 1'b0;

                counter <= counter + 1'b1;
            end

            5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6,
            5'd7, 5'd8, 5'd9, 5'd10,5'd11,5'd12,
            5'd13,5'd14,5'd15,5'd16,5'd17,5'd18,
            5'd19,5'd20,5'd21,5'd22,5'd23,5'd24: begin
                // Cycles 1-24: Iterative multiply, 24 cycles

                if (multiplier[0] == 1'b1) begin
                    // Add multiplicand shifted by current bit position (LSB first)
                    product <= product + {24'd0, multiplicand};
                end

                // Accumulate sticky bit for bits shifted out
                sticky_accum <= sticky_accum | multiplier[0];

                // Shift multiplicand left by 1 for next cycle is unnecessary since multiplicand fixed, multiplier shifts right
                // Instead, we shift multiplier right to process next bit
                multiplier <= multiplier >> 1;

                // Shift multiplicand not shifted here; multiplicand fixed
                multiplicand <= multiplicand;

                counter <= counter + 1'b1;
            end

            5'd25: begin
                // Cycle 25: Normalization, rounding, special case handling, output generation

                // At this point, product contains 48-bit product

                // Normalize product: check bit 47 (MSB)
                normalized_exponent = exponent_sum;
                normalized_product = product;

                if (normalized_product[47] == 1'b1) begin
                    // Shift right by 1, increment exponent
                    normalized_product = normalized_product >> 1;
                    normalized_exponent = normalized_exponent + 10'd1;
                    normalization_shifted = 1'b1;
                end else begin
                    normalization_shifted = 1'b0;
                end

                // Extract mantissa bits: 24 bits starting from bit 46 down to 23 (leading 1 explicit)
                final_mantissa = normalized_product[46:23];

                // Extract rounding bits:
                // guard: bit 23
                // round: bit 22
                // sticky: OR of bits 21 down to 0
                guard_bit <= normalized_product[23];
                round_bit <= normalized_product[22];
                sticky_bit <= |normalized_product[21:0] | sticky_accum;

                // Perform rounding to nearest even:
                // Round up if guard=1 and (round=1 or sticky=1 or LSB mantissa=1)
                reg round_increment;
                round_increment = 1'b0;
                if (guard_bit) begin
                    if (round_bit || sticky_bit || (final_mantissa[0])) begin
                        round_increment = 1'b1;
                    end
                end

                // Apply rounding increment
                if (round_increment) begin
                    reg [24:0] rounded_mantissa;
                    rounded_mantissa = {1'b0, final_mantissa} + 25'd1;
                    if (rounded_mantissa[24] == 1'b1) begin
                        // Mantissa overflowed, shift right and increment exponent
                        final_mantissa = rounded_mantissa[24:1];
                        normalized_exponent = normalized_exponent + 10'd1;
                    end else begin
                        final_mantissa = rounded_mantissa[23:0];
                    end
                end

                final_exponent = normalized_exponent;
                final_sign = z_sign;

                // Handle special cases:

                // NaN input propagates NaN
                if (a_nan || b_nan) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                    // Inf*0 = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (a_inf || b_inf) begin
                    // Inf * non-zero = Inf
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (a_zero || b_zero) begin
                    // zero * anything = zero
                    z <= {final_sign, 31'd0};
                end else begin
                    // Normal and subnormal numbers

                    // Handle exponent overflow
                    if (final_exponent >= 10'd255) begin
                        // Overflow -> Infinity
                        z <= {final_sign, 8'hFF, 23'd0};
                    end
                    // Underflow handling:
                    else if (final_exponent <= 0) begin
                        // Underflow to zero (no denormals handled here)
                        z <= {final_sign, 31'd0};
                    end else begin
                        // Normal number: assemble output IEEE754
                        // Exponent 8 bits, mantissa 23 bits (drop leading 1)
                        z <= {final_sign, final_exponent[7:0], final_mantissa[22:0]};
                    end
                end

                counter <= 5'd0;
            end

            default: begin
                // Default reset state if illegal counter value
                counter <= 5'd0;
                product <= 0;
                multiplicand <= 0;
                multiplier <= 0;
                z <= 32'd0;
            end
            endcase
        end
    end

endmodule