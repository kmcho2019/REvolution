module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        CHECK_SPECIALS = 3'd1,
        MULTIPLY = 3'd2,
        NORMALIZE = 3'd3,
        ROUND = 3'd4,
        OUTPUT = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Registers for inputs fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg [23:0] a_mant, b_mant; // with implicit 1 or 0 leading bit

    // Flags for special cases
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Result sign, exponent, mantissa
    reg res_sign;
    reg [9:0] res_exp;    // wider to handle intermediate addition and adjustments
    reg [47:0] product;   // 24x24 bits product max 48 bits

    // Sequential multiplier registers
    reg [23:0] mult_multiplicand; // holds a_mant
    reg [23:0] mult_multiplier;   // holds b_mant, shifted right each cycle
    reg [47:0] mult_accumulator;  // accumulation of partial products
    reg [4:0] mult_count;         // counts from 0 to 23 for multiplier bits

    // Normalization and rounding signals
    reg [47:0] normalized_product;
    reg [9:0] normalized_exp;
    reg [23:0] normalized_mant;
    reg guard_bit, round_bit, sticky_bit;

    // Rounding increment flag
    reg round_inc;

    // Output mantissa and exponent registers
    reg [7:0] out_exp;
    reg [22:0] out_mant;

    // Temp signals for sticky calculation
    reg sticky_accum;

    // Inputs extraction combinational
    wire [7:0] input_a_exp = a[30:23];
    wire [7:0] input_b_exp = b[30:23];
    wire [22:0] input_a_frac = a[22:0];
    wire [22:0] input_b_frac = b[22:0];
    wire input_a_sign = a[31];
    wire input_b_sign = b[31];

    // Constants
    localparam EXP_BIAS = 127;

    // Special constant NaN and Infinity patterns
    localparam [31:0] QUIET_NAN = {1'b0, 8'hFF, 1'b1, 22'd0};
    localparam [31:0] POS_INF = {1'b0, 8'hFF, 23'd0};
    localparam [31:0] NEG_INF = {1'b1, 8'hFF, 23'd0};
    localparam [31:0] ZERO = 32'd0;

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = CHECK_SPECIALS;
            CHECK_SPECIALS: begin
                if (a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero))
                    next_state = OUTPUT; // output NaN immediately
                else if (a_inf || b_inf || a_zero || b_zero)
                    next_state = OUTPUT; // output special immediately
                else
                    next_state = MULTIPLY;
            end
            MULTIPLY:
                if (mult_count == 5'd24)
                    next_state = NORMALIZE;
                else
                    next_state = MULTIPLY;
            NORMALIZE: next_state = ROUND;
            ROUND: next_state = OUTPUT;
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM sequential control and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear internal registers
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

            out_exp <= 0;
            out_mant <= 0;
            sticky_accum <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Capture inputs
                    a_sign <= input_a_sign;
                    b_sign <= input_b_sign;
                    a_exp <= input_a_exp;
                    b_exp <= input_b_exp;
                    a_frac <= input_a_frac;
                    b_frac <= input_b_frac;

                    // Determine special cases
                    a_zero <= (input_a_exp == 8'd0) && (input_a_frac == 23'd0);
                    b_zero <= (input_b_exp == 8'd0) && (input_b_frac == 23'd0);

                    a_inf <= (input_a_exp == 8'hFF) && (input_a_frac == 23'd0);
                    b_inf <= (input_b_exp == 8'hFF) && (input_b_frac == 23'd0);

                    a_nan <= (input_a_exp == 8'hFF) && (input_a_frac != 23'd0);
                    b_nan <= (input_b_exp == 8'hFF) && (input_b_frac != 23'd0);

                    z <= 32'd0;
                end

                CHECK_SPECIALS: begin
                    // Decide result sign
                    res_sign <= a_sign ^ b_sign;

                    if (a_nan || b_nan) begin
                        // Produce quiet NaN
                        z <= QUIET_NAN;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // NaN due to Inf*0
                        z <= QUIET_NAN;
                    end else if (a_inf || b_inf) begin
                        // Inf * finite or Inf * Inf
                        if (res_sign)
                            z <= NEG_INF;
                        else
                            z <= POS_INF;
                    end else if (a_zero || b_zero) begin
                        // Zero * anything = zero
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Prepare mantissas and exponents for multiplication
                        // Normalized numbers get implicit 1, denormals don't
                        a_mant <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                        b_mant <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                        // Exponent add: ex_a + ex_b - bias
                        // Use 10 bits to avoid overflow during adjust
                        res_exp <= a_exp + b_exp - EXP_BIAS;

                        // Initialize multiplier registers
                        mult_multiplicand <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                        mult_multiplier <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};
                        mult_accumulator <= 48'd0;
                        mult_count <= 0;
                    end
                end

                MULTIPLY: begin
                    // Shift-add multiply algorithm for 24x24 bits in 24 cycles
                    if (mult_count < 24) begin
                        if (mult_multiplier[0] == 1'b1) begin
                            // Add multiplicand shifted by mult_count to accumulator
                            mult_accumulator <= mult_accumulator + (mult_multiplicand << mult_count);
                        end
                        // Shift multiplier right by 1 bit
                        mult_multiplier <= mult_multiplier >> 1;
                        mult_count <= mult_count + 1;
                    end
                    if (mult_count == 24) begin
                        product <= mult_accumulator; // Final product
                    end
                end

                NORMALIZE: begin
                    // Normalize the 48-bit product and adjust exponent
                    // Check if bit 47 is 1, if yes shift right 1 and increase exponent
                    if (product[47] == 1'b1) begin
                        normalized_product <= product >> 1;
                        normalized_exp <= res_exp + 1;
                    end else begin
                        normalized_product <= product;
                        normalized_exp <= res_exp;
                    end

                    // Extract mantissa (24 bits): bits [46:23]
                    normalized_mant <= normalized_product[46:23];

                    // Extract rounding bits
                    guard_bit <= normalized_product[22];
                    round_bit <= normalized_product[21];
                    sticky_bit <= |normalized_product[20:0];
                end

                ROUND: begin
                    // Round to nearest even
                    round_inc <= 0;
                    if (guard_bit) begin
                        if (round_bit || sticky_bit || normalized_mant[0]) begin
                            round_inc <= 1'b1;
                        end
                    end

                    if (round_inc) begin
                        // Add 1 to mantissa (24 bits)
                        {sticky_accum, normalized_mant} <= normalized_mant + 1;
                        // If mantissa overflowed (carry out in sticky_accum)
                        if (sticky_accum) begin
                            // Shift mantissa right by 1, increment exponent
                            normalized_mant <= normalized_mant >> 1;
                            normalized_exp <= normalized_exp + 1;
                        end
                    end
                end

                OUTPUT: begin
                    // Handle overflow and underflow
                    if (normalized_exp >= 10'd255) begin
                        // Overflow -> infinity
                        z <= {res_sign, 8'hFF, 23'd0};
                    end else if (normalized_exp <= 10'd0) begin
                        // Underflow -> zero (flush)
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Normalized number: remove leading 1 implicit bit in mantissa
                        out_exp <= normalized_exp[7:0];
                        out_mant <= normalized_mant[22:0];
                        z <= {res_sign, out_exp, out_mant};
                    end
                end

                default: ;
            endcase
        end
    end

endmodule