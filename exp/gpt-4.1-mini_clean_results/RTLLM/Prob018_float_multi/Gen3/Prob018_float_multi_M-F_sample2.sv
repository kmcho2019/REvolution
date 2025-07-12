module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE        = 3'd0,
        CHECK_SPECIALS = 3'd1,
        MULTIPLY    = 3'd2,
        NORMALIZE   = 3'd3,
        ROUND       = 3'd4,
        ROUND_ADJUST= 3'd5,
        OUTPUT      = 3'd6
    } state_t;

    reg [2:0] state, next_state;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Mantissas with implicit leading bit or 0 for denormals
    reg [23:0] a_mant, b_mant;

    // Special cases flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Result sign and exponent (wide for intermediate calc)
    reg res_sign;
    reg [9:0] res_exp;

    // 48-bit product for 24x24 multiplication result
    reg [47:0] product;

    // Sequential multiplication registers
    reg [23:0] mult_multiplicand; // a_mant
    reg [23:0] mult_multiplier;   // b_mant, shifted right each cycle
    reg [47:0] mult_accumulator;
    reg [4:0] mult_count;         // counts 0..23

    // Normalization registers
    reg [47:0] normalized_product;
    reg [9:0] normalized_exp;
    reg [23:0] normalized_mant;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding increment flag
    reg round_inc;

    // Flag indicating mantissa overflow after rounding increment
    reg round_carry;

    // Output fields
    reg [7:0] out_exp;
    reg [22:0] out_mant;

    // Sticky bit calculation helper
    reg sticky_calc;

    // Extract inputs for easy usage
    wire [7:0] input_a_exp = a[30:23];
    wire [7:0] input_b_exp = b[30:23];
    wire [22:0] input_a_frac = a[22:0];
    wire [22:0] input_b_frac = b[22:0];
    wire input_a_sign = a[31];
    wire input_b_sign = b[31];

    localparam EXP_BIAS = 127;

    // Constants for special values
    localparam [31:0] QUIET_NAN = {1'b0, 8'hFF, 1'b1, 22'd0};
    localparam [31:0] POS_INF = {1'b0, 8'hFF, 23'd0};
    localparam [31:0] NEG_INF = {1'b1, 8'hFF, 23'd0};
    localparam [31:0] ZERO = 32'd0;

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = CHECK_SPECIALS;
            CHECK_SPECIALS: begin
                // If special cases require immediate output
                if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero))
                    next_state = OUTPUT;
                else if (a_inf || b_inf || a_zero || b_zero)
                    next_state = OUTPUT;
                else
                    next_state = MULTIPLY;
            end
            MULTIPLY: begin
                if (mult_count == 5'd24)
                    next_state = NORMALIZE;
                else
                    next_state = MULTIPLY;
            end
            NORMALIZE: next_state = ROUND;
            ROUND: next_state = round_inc ? ROUND_ADJUST : OUTPUT;
            ROUND_ADJUST: next_state = OUTPUT;
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential FSM and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear all registers
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mant <= 0; b_mant <= 0;

            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;

            res_sign <= 0;
            res_exp <= 0;
            product <= 0;

            mult_multiplicand <= 0;
            mult_multiplier <= 0;
            mult_accumulator <= 0;
            mult_count <= 0;

            normalized_product <= 0;
            normalized_exp <= 0;
            normalized_mant <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            round_inc <= 0;
            round_carry <= 0;

            out_exp <= 0;
            out_mant <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Capture inputs and special cases
                    a_sign <= input_a_sign;
                    b_sign <= input_b_sign;
                    a_exp <= input_a_exp;
                    b_exp <= input_b_exp;
                    a_frac <= input_a_frac;
                    b_frac <= input_b_frac;

                    a_zero <= (input_a_exp == 8'd0) && (input_a_frac == 23'd0);
                    b_zero <= (input_b_exp == 8'd0) && (input_b_frac == 23'd0);

                    a_inf <= (input_a_exp == 8'hFF) && (input_a_frac == 23'd0);
                    b_inf <= (input_b_exp == 8'hFF) && (input_b_frac == 23'd0);

                    a_nan <= (input_a_exp == 8'hFF) && (input_a_frac != 23'd0);
                    b_nan <= (input_b_exp == 8'hFF) && (input_b_frac != 23'd0);

                    // Clear output
                    z <= 32'd0;
                end

                CHECK_SPECIALS: begin
                    res_sign <= a_sign ^ b_sign;

                    if (a_nan || b_nan) begin
                        // NaN priority
                        z <= QUIET_NAN;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf*0 => NaN
                        z <= QUIET_NAN;
                    end else if (a_inf || b_inf) begin
                        // Inf * finite or Inf * Inf
                        if (res_sign)
                            z <= NEG_INF;
                        else
                            z <= POS_INF;
                    end else if (a_zero || b_zero) begin
                        // Zero times anything => zero
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Prepare mantissas with implicit 1 for normalized, else 0 for denormals
                        a_mant <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                        b_mant <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                        // Calculate raw exponent sum - bias
                        res_exp <= a_exp + b_exp - EXP_BIAS;

                        // Initialize sequential multiplier registers
                        mult_multiplicand <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                        mult_multiplier <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};
                        mult_accumulator <= 48'd0;
                        mult_count <= 0;

                        // Clear output for now
                        z <= 32'd0;
                    end
                end

                MULTIPLY: begin
                    // Shift-add multiply
                    if (mult_count < 24) begin
                        if (mult_multiplier[0]) begin
                            mult_accumulator <= mult_accumulator + (mult_multiplicand << mult_count);
                        end
                        mult_multiplier <= mult_multiplier >> 1;
                        mult_count <= mult_count + 1;
                    end
                    if (mult_count == 5'd24) begin
                        product <= mult_accumulator;
                    end
                end

                NORMALIZE: begin
                    // Check for leading bit at product[47]
                    if (product[47]) begin
                        normalized_product <= product >> 1;
                        normalized_exp <= res_exp + 1;
                    end else begin
                        normalized_product <= product;
                        normalized_exp <= res_exp;
                    end

                    // Extract mantissa bits [46:23]
                    normalized_mant <= (product[47]) ? (product[46:23]) : (product[46:23]);

                    // Extract rounding bits
                    guard_bit <= (product[22]);
                    round_bit <= (product[21]);
                    sticky_bit <= |product[20:0];

                    // Clear rounding flags for next stage
                    round_inc <= 1'b0;
                    round_carry <= 1'b0;
                end

                ROUND: begin
                    // Round to nearest even:
                    // round_inc if guard == 1 and (round bit or sticky bit or LSB of mantissa == 1)
                    if (guard_bit == 1'b1) begin
                        if (round_bit || sticky_bit || normalized_mant[0]) begin
                            round_inc <= 1'b1;
                        end else begin
                            round_inc <= 1'b0;
                        end
                    end else begin
                        round_inc <= 1'b0;
                    end

                    if (!round_inc) begin
                        // No rounding increment needed, pass values through
                        // Output mantissa and exponent assigned in OUTPUT
                        // Save normalized_mant and normalized_exp
                        // No carry expected, clear
                        round_carry <= 1'b0;
                    end
                end

                ROUND_ADJUST: begin
                    // Perform rounding increment and adjust if overflow
                    // Add 1 to mantissa (24 bits)
                    {round_carry, normalized_mant} <= normalized_mant + 1;

                    // If carry out (overflow), shift mantissa right by 1 and increment exponent
                    if (round_carry) begin
                        normalized_mant <= normalized_mant >> 1;
                        normalized_exp <= normalized_exp + 1;
                    end
                end

                OUTPUT: begin
                    // Handle exponent overflow and underflow
                    if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Output NaN cases (from CHECK_SPECIALS)
                        // z already assigned there, hold stable here
                        z <= z;
                    end else if (a_inf || b_inf) begin
                        // Output Inf cases (from CHECK_SPECIALS)
                        // z already assigned there, hold stable here
                        z <= z;
                    end else if (a_zero || b_zero) begin
                        // Output zero (from CHECK_SPECIALS)
                        // z already assigned there, hold stable here
                        z <= z;
                    end else begin
                        // Normal number output

                        // Clamp exponent
                        if (normalized_exp >= 10'd255) begin
                            // Overflow to infinity
                            z <= {res_sign, 8'hFF, 23'd0};
                        end else if (normalized_exp <= 10'd0) begin
                            // Underflow flush to zero
                            z <= {res_sign, 31'd0};
                        end else begin
                            // Remove implicit leading 1 bit for IEEE754 normalized mantissa
                            // Mantissa is 24 bits with leading bit implicit,
                            // we store 23 bits fraction part.
                            out_exp <= normalized_exp[7:0];
                            out_mant <= normalized_mant[22:0];
                            z <= {res_sign, out_exp, out_mant};
                        end
                    end
                end

                default: ;
            endcase
        end
    end

endmodule