module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State machine encoding
    localparam STATE_IDLE           = 3'd0;
    localparam STATE_SPECIAL_CHECK  = 3'd1;
    localparam STATE_MULTIPLY       = 3'd2;
    localparam STATE_NORMALIZE_ROUND= 3'd3;
    localparam STATE_OUTPUT         = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    // Input decomposition registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // mantissa with implicit leading bit
    reg a_exp_is_zero, b_exp_is_zero;
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Intermediate signals
    reg product_sign;
    reg [9:0] product_exponent;  // 10-bit to hold sum exponent - bias
    reg [47:0] product_mantissa; // 24x24 multiplication = up to 48 bits product

    // Normalized mantissa and exponent
    reg [47:0] normalized_product;
    reg [7:0] normalized_exp;
    reg normalization_shifted; // flag to indicate if we shifted product to normalize
    reg [23:0] mantissa_rounded;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;
    reg round_up;

    // Special case flags
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Shift amount for denormals or underflow handling
    reg [5:0] shift_amount;

    // Temporary mantissa for underflow/denormal
    reg [47:0] mantissa_with_hidden;
    reg [47:0] shifted_mantissa;
    reg [22:0] denorm_mantissa;
    reg denorm_guard, denorm_round, denorm_sticky;

    // Round-up temporary flag for denormals
    reg roundup_denorm;

    // Temporary variables declared at module scope (fix for illegal declarations)
    reg [24:0] mantissa_with_round;
    reg [8:0] exp_with_round;
    reg [22:0] final_mantissa;

    // Parameters
    localparam BIAS = 127;

    // Wires for inputs special cases (combinational)
    wire input_a_zero = (a[30:0] == 31'b0);
    wire input_b_zero = (b[30:0] == 31'b0);
    wire input_a_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 0);
    wire input_b_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 0);
    wire input_a_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 0);
    wire input_b_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 0);

    // State transition logic
    always @(*) begin
        case(state)
            STATE_IDLE: begin
                // Always proceed to special check immediately on input clock
                next_state = STATE_SPECIAL_CHECK;
            end
            STATE_SPECIAL_CHECK: begin
                next_state = STATE_MULTIPLY;
            end
            STATE_MULTIPLY: begin
                next_state = STATE_NORMALIZE_ROUND;
            end
            STATE_NORMALIZE_ROUND: begin
                next_state = STATE_OUTPUT;
            end
            STATE_OUTPUT: begin
                next_state = STATE_IDLE;
            end
            default: begin
                next_state = STATE_IDLE;
            end
        endcase
    end

    // Main sequential block - state machine and registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;

            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_mantissa <= 0; b_mantissa <= 0;

            a_exp_is_zero <= 0; b_exp_is_zero <= 0;

            a_is_nan <= 0; b_is_nan <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_zero <= 0; b_is_zero <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;

            product_sign <= 0;
            product_exponent <= 0;
            product_mantissa <= 0;

            normalized_product <= 0;
            normalized_exp <= 0;
            normalization_shifted <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            round_up <= 0;
            mantissa_rounded <= 0;

            shift_amount <= 0;

            mantissa_with_hidden <= 0;
            shifted_mantissa <= 0;

            denorm_mantissa <= 0;
            denorm_guard <= 0;
            denorm_round <= 0;
            denorm_sticky <= 0;

            roundup_denorm <= 0;

            mantissa_with_round <= 0;
            exp_with_round <= 0;
            final_mantissa <= 0;

            z <= 0;

        end else begin
            state <= next_state;
            case(state)
                STATE_IDLE: begin
                    // Decompose inputs
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

                    a_exp_is_zero <= (a[30:23] == 0);
                    b_exp_is_zero <= (b[30:23] == 0);

                    a_is_nan <= input_a_nan;
                    b_is_nan <= input_b_nan;

                    a_is_inf <= input_a_inf;
                    b_is_inf <= input_b_inf;

                    a_is_zero <= input_a_zero;
                    b_is_zero <= input_b_zero;

                    // Assign mantissa with implicit leading 1 if normalized, else leading 0 for denormals
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Clear output
                    z <= 0;

                    // Clear special flags for next stages
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;
                end

                STATE_SPECIAL_CHECK: begin
                    // Detect special conditions
                    if (a_is_nan || b_is_nan) begin
                        special_nan <= 1'b1;
                    end else if (a_is_inf || b_is_inf) begin
                        // Infinity * Zero = NaN
                        if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                            special_nan <= 1'b1;
                        end else begin
                            special_inf <= 1'b1;
                        end
                    end else if (a_is_zero || b_is_zero) begin
                        special_zero <= 1'b1;
                    end else begin
                        // Normal case, no special
                        special_nan <= 0;
                        special_inf <= 0;
                        special_zero <= 0;
                    end
                end

                STATE_MULTIPLY: begin
                    // Compute sign of product
                    product_sign <= a_sign ^ b_sign;

                    // Adjust exponents: for denormals, exponent is treated as 1 instead of 0 for calculation
                    // This is consistent with IEEE-754 standard for denormals
                    product_exponent <= ((a_exp == 0) ? 10'd1 : a_exp) + ((b_exp == 0) ? 10'd1 : b_exp) - BIAS;

                    // Multiply mantissas 24-bit * 24-bit = 48-bit product
                    product_mantissa <= a_mantissa * b_mantissa;
                end

                STATE_NORMALIZE_ROUND: begin
                    // Normalize product mantissa:
                    // If bit 47 is 1, product is normalized and exponent increments by 1
                    // Else shift left by 1 to normalize

                    if (product_mantissa[47] == 1'b1) begin
                        normalized_product <= product_mantissa;
                        normalized_exp <= product_exponent + 1;
                        normalization_shifted <= 0;
                    end else begin
                        normalized_product <= product_mantissa << 1;
                        normalized_exp <= product_exponent;
                        normalization_shifted <= 1;
                    end

                    // Extract rounding bits from normalized_product:
                    // mantissa bits: [46:23] (24 bits)
                    // guard bit: bit 22
                    // round bit: bit 21
                    // sticky bit: OR of bits [20:0]

                    guard_bit <= normalized_product[22];
                    round_bit <= normalized_product[21];
                    sticky_bit <= |normalized_product[20:0];
                end

                STATE_OUTPUT: begin
                    // Extract mantissa (24 bits, including implicit leading one)
                    mantissa_rounded <= normalized_product[46:23];

                    // Round to nearest even
                    round_up <= (guard_bit && (round_bit || sticky_bit)) || (guard_bit && !round_bit && !sticky_bit && mantissa_rounded[0]);

                    // Prepare rounded mantissa and exponent registers
                    mantissa_with_round = {1'b0, mantissa_rounded} + (round_up ? 25'd1 : 25'd0);
                    exp_with_round = {1'b0, normalized_exp};

                    // Handle mantissa overflow after rounding
                    if (mantissa_with_round[24] == 1'b1) begin
                        // Mantissa overflowed (25 bits), shift right by 1 and increment exponent
                        mantissa_with_round = mantissa_with_round >> 1;
                        exp_with_round = exp_with_round + 1;
                    end

                    // Final mantissa without implicit leading bit (23 bits)
                    final_mantissa = mantissa_with_round[22:0];

                    // Check special cases and assemble output
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exponent=all 1s, MSB mantissa=1 (quiet bit), rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                    end else if (special_inf) begin
                        // Infinity with product sign
                        z <= {product_sign, 8'hFF, 23'b0};
                    end else if (special_zero) begin
                        // Zero with product sign
                        z <= {product_sign, 31'b0};
                    end else begin
                        // Normal number or underflow/overflow handling
                        if (exp_with_round >= 255) begin
                            // Overflow to infinity
                            z <= {product_sign, 8'hFF, 23'b0};
                        end else if (exp_with_round <= 0) begin
                            // Underflow -> denormal or zero

                            // Calculate shift amount to right shift mantissa
                            // shift_amount = 1 - exponent (positive)
                            shift_amount = 1 - exp_with_round;

                            // Prepare mantissa with implicit leading 1, 24 bits, shifted for extra precision (24 bits left shift)
                            mantissa_with_hidden = {1'b1, mantissa_with_round[22:0], 24'b0}; // 48 bits

                            if (shift_amount < 48)
                                shifted_mantissa = mantissa_with_hidden >> shift_amount;
                            else
                                shifted_mantissa = 48'b0;

                            // Extract denormal mantissa (23 bits), guard, round and sticky bits
                            denorm_mantissa = shifted_mantissa[46:24];
                            denorm_guard = shifted_mantissa[23];
                            denorm_round = shifted_mantissa[22];
                            denorm_sticky = |shifted_mantissa[21:0];

                            // Rounding for denormals
                            roundup_denorm = (denorm_guard && (denorm_round || denorm_sticky)) ||
                                            (denorm_guard && !denorm_round && !denorm_sticky && denorm_mantissa[0]);

                            if (roundup_denorm)
                                denorm_mantissa = denorm_mantissa + 1;

                            if (denorm_mantissa == 0) begin
                                // Underflow to zero
                                z <= {product_sign, 31'b0};
                            end else begin
                                // Output denormal number with zero exponent
                                z <= {product_sign, 8'b0, denorm_mantissa};
                            end
                        end else begin
                            // Normal output
                            z <= {product_sign, exp_with_round[7:0], final_mantissa};
                        end
                    end
                end

                default: begin
                    // safety fallback
                    state <= STATE_IDLE;
                end
            endcase
        end
    end

endmodule