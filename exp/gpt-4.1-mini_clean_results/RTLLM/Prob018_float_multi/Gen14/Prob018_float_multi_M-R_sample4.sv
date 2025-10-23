module float_multi (
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // State machine states
    typedef enum reg [2:0] {
        IDLE        = 3'd0,
        DECODE      = 3'd1,
        MULTIPLY    = 3'd2,
        NORMALIZE   = 3'd3,
        ROUND       = 3'd4,
        WRITEBACK   = 3'd5
    } state_t;

    state_t state, next_state;

    // Input registers
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Decoded mantissas with hidden bit (24 bits)
    reg [23:0]  a_mantissa, b_mantissa;

    // Flags for special cases
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Product of mantissas (48 bits)
    reg [47:0]  product;

    // Exponent sum (extended to 9 bits to avoid overflow in calculations)
    reg [8:0]   exponent_sum;

    // Result sign
    reg         result_sign;

    // Normalization outputs
    reg [23:0]  norm_mantissa;
    reg [7:0]   norm_exp;
    reg         guard_bit, round_bit, sticky_bit;

    // Rounding signals
    reg round_increment;
    reg [24:0] rounded_mantissa; // 25 bits to detect overflow after rounding

    // Internal signals for combinational logic
    wire sticky_calc;

    // Sticky bit calculation as OR of relevant bits
    assign sticky_calc = |(state == NORMALIZE ? 
                           (product[21:0]) : 
                           22'd0);

    // State machine sequential logic
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear all internal registers
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_frac <= 23'd0;
            b_frac <= 23'd0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;

            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;

            product <= 48'd0;
            exponent_sum <= 9'd0;
            result_sign <= 1'b0;

            norm_mantissa <= 24'd0;
            norm_exp <= 8'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            round_increment <= 1'b0;
            rounded_mantissa <= 25'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    z <= 32'd0;
                end

                DECODE: begin
                    // Capture inputs and decode special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Set mantissa with hidden bit (1 if normalized, 0 if denormalized)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Result sign calculation
                    result_sign <= a[31] ^ b[31];
                end

                MULTIPLY: begin
                    // Multiply mantissas and add exponents
                    product <= a_mantissa * b_mantissa; // 24x24=48 bits product
                    // Sum of exponents minus bias
                    exponent_sum <= {1'b0, a_exp} + {1'b0, b_exp} - EXP_BIAS;
                end

                NORMALIZE: begin
                    // Normalize product mantissa and adjust exponent

                    if (product[47]) begin
                        // MSB set: shift not needed, increment exponent
                        norm_exp <= exponent_sum[7:0] + 1;
                        norm_mantissa <= product[47:24];
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB not set: shift mantissa left by 1 (take bits 46:23)
                        norm_exp <= exponent_sum[7:0];
                        norm_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                ROUND: begin
                    // Calculate round increment for round-to-nearest-even
                    round_increment <= guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);

                    // Add rounding increment
                    rounded_mantissa <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check for mantissa overflow from rounding
                    if (rounded_mantissa[24]) begin
                        // Overflow: shift right mantissa and increment exponent
                        norm_exp <= norm_exp + 1;
                        norm_mantissa <= rounded_mantissa[24:1];
                    end else begin
                        norm_mantissa <= rounded_mantissa[23:0];
                    end
                end

                WRITEBACK: begin
                    // Handle special cases and final output formatting
                    if (a_nan || b_nan) begin
                        // Quiet NaN: sign=0, exp=all 1's, MSB mantissa=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity times nonzero = infinity
                        z <= {result_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero times anything = zero
                        z <= {result_sign, 31'd0};
                    end else begin
                        // Check exponent overflow/underflow
                        if (norm_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {result_sign, 8'hFF, 23'd0};
                        end else if (norm_exp == 8'd0) begin
                            // Underflow to zero (flush)
                            z <= {result_sign, 31'd0};
                        end else begin
                            // Normal case
                            z <= {result_sign, norm_exp, norm_mantissa[22:0]};
                        end
                    end
                end

                default: begin
                    // Default state does nothing
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:       next_state = DECODE;
            DECODE: begin
                // If inputs are special cases that can produce early output, skip MULTIPLY
                if (a_nan || b_nan ||
                    (a_inf && b_zero) || (b_inf && a_zero) ||
                    a_inf || b_inf ||
                    a_zero || b_zero) begin
                    // Go directly to WRITEBACK to produce immediate output
                    next_state = WRITEBACK;
                end else begin
                    next_state = MULTIPLY;
                end
            end

            MULTIPLY:   next_state = NORMALIZE;
            NORMALIZE:  next_state = ROUND;
            ROUND:      next_state = WRITEBACK;
            WRITEBACK:  next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

endmodule