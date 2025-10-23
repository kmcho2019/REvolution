module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE-754 parameters
    localparam EXP_BIAS = 127;

    // One-hot encoded FSM states
    localparam [5:0]
        S_IDLE      = 6'b000001,
        S_DECODE    = 6'b000010,
        S_MULTIPLY  = 6'b000100,
        S_NORMALIZE = 6'b001000,
        S_ROUND     = 6'b010000,
        S_PACK      = 6'b100000;

    reg [5:0] state, next_state;

    // Input extracted fields (registered)
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special flags (registered)
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Mantissas with implicit leading 1 or 0 (registered)
    reg [23:0] a_mant, b_mant;

    // Result sign (registered)
    reg z_sign;

    // Exponent calculation (signed 10-bit to hold overflow)
    reg signed [9:0] exp_sum;

    // Mantissa multiplication product 48-bit (registered)
    reg [47:0] product;

    // Normalized mantissa and exponent (registered)
    reg [23:0] norm_mant;
    reg signed [9:0] norm_exp;

    // Rounding bits (registered)
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa (25 bits: 24 mantissa + possible carry)
    reg [24:0] mant_rounded;

    // Final exponent and mantissa registers
    reg [7:0] final_exp;
    reg [22:0] final_mant;

    // Special flags for output (registered)
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Temporary combinational signals for sticky computation
    wire sticky_comb;

    // ======================
    // Combinational input extraction and special case detection
    // ======================
    always @(*) begin
        // Decode inputs (combinational)
        a_sign = a[31];
        b_sign = b[31];
        a_exp  = a[30:23];
        b_exp  = b[30:23];
        a_frac = a[22:0];
        b_frac = b[22:0];

        a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
        b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

        a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
        b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);

        a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
        b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

        // Prepare mantissas with implicit leading 1 for normalized, else 0
        a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
        b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

        z_sign = a_sign ^ b_sign;
    end

    // ======================
    // Sticky bit combinational calculation helper
    // ======================
    assign sticky_comb = |product[21:0];

    // ======================
    // FSM state transition logic
    // ======================
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S_IDLE:      next_state = S_DECODE;
            S_DECODE:    next_state = S_MULTIPLY;
            S_MULTIPLY:  next_state = S_NORMALIZE;
            S_NORMALIZE: next_state = S_ROUND;
            S_ROUND:     next_state = S_PACK;
            S_PACK:      next_state = S_IDLE;
            default:     next_state = S_IDLE;
        endcase
    end

    // ======================
    // Sequential registers and computations per state
    // ======================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear all registers and output
            z <= 32'd0;

            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_mant <= 0; b_mant <= 0;

            z_sign <= 0;
            exp_sum <= 0;
            product <= 0;
            norm_mant <= 0;
            norm_exp <= 0;

            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            mant_rounded <= 0;

            final_exp <= 0;
            final_mant <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;
        end else begin
            case (state)
                S_DECODE: begin
                    // Register decoded inputs and special cases from combinational
                    a_sign <= a_sign;
                    b_sign <= b_sign;
                    a_exp <= a_exp;
                    b_exp <= b_exp;
                    a_frac <= a_frac;
                    b_frac <= b_frac;

                    a_is_zero <= a_is_zero;
                    b_is_zero <= b_is_zero;
                    a_is_inf <= a_is_inf;
                    b_is_inf <= b_is_inf;
                    a_is_nan <= a_is_nan;
                    b_is_nan <= b_is_nan;

                    a_mant <= a_mant;
                    b_mant <= b_mant;

                    z_sign <= z_sign;
                end

                S_MULTIPLY: begin
                    // Multiply mantissas
                    product <= a_mant * b_mant;

                    // Exponent sum with bias subtraction
                    exp_sum <= $signed({1'b0, a_exp}) + $signed({1'b0, b_exp}) - EXP_BIAS;

                    // Determine special output cases
                    special_nan  <= a_is_nan || b_is_nan;
                    special_inf  <= (a_is_inf || b_is_inf) && !(a_is_zero || b_is_zero);
                    special_zero <= a_is_zero || b_is_zero;
                end

                S_NORMALIZE: begin
                    if (product[47]) begin
                        // MSB set, product is already normalized, shift right by 24
                        norm_mant <= product[47:24];
                        norm_exp <= exp_sum + 1; // increment exponent due to normalization

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= sticky_comb;
                    end else begin
                        // Shift right 23 bits, product MSB in bit 46
                        norm_mant <= product[46:23];
                        norm_exp <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                S_ROUND: begin
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky_bit || norm_mant[0]))
                        mant_rounded <= {1'b0, norm_mant} + 25'd1;
                    else
                        mant_rounded <= {1'b0, norm_mant};
                end

                S_PACK: begin
                    // Handle mantissa overflow after rounding
                    if (mant_rounded[24]) begin
                        final_exp <= norm_exp + 1;
                        final_mant <= mant_rounded[24:2]; // shifted right 1 bit (discard LSB)
                    end else begin
                        final_exp <= norm_exp[7:0];
                        final_mant <= mant_rounded[22:0];
                    end

                    // Assemble the output z with special cases considered
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=255, mantissa MSB=1 and rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf && (a_is_zero || b_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Inf * non-zero = Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero result with sign
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal case with overflow and underflow checks
                        if (final_exp >= 8'hFF) begin
                            // Overflow to Infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (final_exp <= 0) begin
                            // Underflow flushed to zero (denormals not supported here)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal float
                            z <= {z_sign, final_exp, final_mant};
                        end
                    end
                end

                default: ;
            endcase
        end
    end

endmodule