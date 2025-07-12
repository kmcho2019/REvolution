module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        CAPTURE    = 3'd1,
        SPECIAL    = 3'd2,
        MUL_NORM   = 3'd3,
        ROUND      = 3'd4,
        PACK       = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Input decoded fields (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special input flags
    wire a_is_nan  = (a_exp == EXP_MAX) && (a_frac != 0);
    wire b_is_nan  = (b_exp == EXP_MAX) && (b_frac != 0);
    wire a_is_inf  = (a_exp == EXP_MAX) && (a_frac == 0);
    wire b_is_inf  = (b_exp == EXP_MAX) && (b_frac == 0);
    wire a_is_zero = (a_exp == 0) && (a_frac == 0);
    wire b_is_zero = (b_exp == 0) && (b_frac == 0);

    // Registered inputs latched at CAPTURE stage
    reg reg_a_sign, reg_b_sign, reg_z_sign;
    reg [7:0] reg_a_exp, reg_b_exp;
    reg [22:0] reg_a_frac, reg_b_frac;
    reg reg_a_is_nan, reg_b_is_nan;
    reg reg_a_is_inf, reg_b_is_inf;
    reg reg_a_is_zero, reg_b_is_zero;

    // Mantissas with implicit leading bits
    reg [23:0] reg_a_mant, reg_b_mant;

    // Mantissa multiplication result 48 bits (24x24)
    reg [47:0] mant_product;

    // Sum of exponents minus bias, 9-bit to allow overflow
    reg [8:0] exp_sum;

    // Normalization flags and signals
    reg norm_shift;       // 1 if normalized product MSB at bit 47
    reg [47:0] norm_mant;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [24:0] round_sum; // 25 bits to detect overflow after rounding
    reg [8:0] rounded_exp;

    // Special result signals to propagate to PACK stage
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE:     next_state = CAPTURE;
            CAPTURE:  next_state = SPECIAL;
            SPECIAL:  if (special_nan || special_inf || special_zero) next_state = PACK;
                      else next_state = MUL_NORM;
            MUL_NORM: next_state = ROUND;
            ROUND:    next_state = PACK;
            PACK:     next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

    // FSM sequential logic and pipeline registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'b0;

            // Clear registers
            reg_a_sign <= 1'b0; reg_b_sign <= 1'b0; reg_z_sign <= 1'b0;
            reg_a_exp <= 8'd0; reg_b_exp <= 8'd0;
            reg_a_frac <= 23'd0; reg_b_frac <= 23'd0;

            reg_a_is_nan <= 1'b0; reg_b_is_nan <= 1'b0;
            reg_a_is_inf <= 1'b0; reg_b_is_inf <= 1'b0;
            reg_a_is_zero <= 1'b0; reg_b_is_zero <= 1'b0;

            reg_a_mant <= 24'd0;
            reg_b_mant <= 24'd0;

            mant_product <= 48'd0;
            exp_sum <= 9'd0;

            norm_shift <= 1'b0;
            norm_mant <= 48'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;

            round_sum <= 25'd0;
            rounded_exp <= 9'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;

        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Nothing to do
                end
                CAPTURE: begin
                    // Latch inputs
                    reg_a_sign <= a_sign;
                    reg_b_sign <= b_sign;
                    reg_z_sign <= a_sign ^ b_sign;

                    reg_a_exp <= a_exp;
                    reg_b_exp <= b_exp;

                    reg_a_frac <= a_frac;
                    reg_b_frac <= b_frac;

                    reg_a_is_nan <= a_is_nan;
                    reg_b_is_nan <= b_is_nan;
                    reg_a_is_inf <= a_is_inf;
                    reg_b_is_inf <= b_is_inf;
                    reg_a_is_zero <= a_is_zero;
                    reg_b_is_zero <= b_is_zero;

                    // Prepare mantissas with implicit leading bit:
                    // if exponent != 0, leading 1, else 0 (denormals)
                    reg_a_mant <= (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
                    reg_b_mant <= (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

                    // Clear special flags for next stage
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                end
                SPECIAL: begin
                    // Handle special cases and flags
                    if (reg_a_is_nan || reg_b_is_nan) begin
                        // If either input is NaN, output quiet NaN
                        special_nan <= 1'b1;
                    end else if ((reg_a_is_inf && reg_b_is_zero) || (reg_b_is_inf && reg_a_is_zero)) begin
                        // inf * 0 = NaN
                        special_nan <= 1'b1;
                    end else if (reg_a_is_inf || reg_b_is_inf) begin
                        // Infinity times non-zero, non-NaN => infinity with correct sign
                        special_inf <= 1'b1;
                    end else if (reg_a_is_zero || reg_b_is_zero) begin
                        // Zero times non-infinity, non-NaN => zero with correct sign
                        special_zero <= 1'b1;
                    end else begin
                        // No special cases
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;

                        // Multiply mantissas 24x24 -> 48 bits
                        mant_product <= reg_a_mant * reg_b_mant;

                        // Sum exponents, subtract bias
                        // For zero/denormals exponent is zero, this is correct
                        exp_sum <= reg_a_exp + reg_b_exp - EXP_BIAS;
                    end
                end
                MUL_NORM: begin
                    // Normalize mantissa product and adjust exponent

                    if (mant_product[47]) begin
                        // MSB at bit 47, normalized, exponent increased by 1
                        norm_shift <= 1'b1;
                        norm_mant <= mant_product;
                        rounded_exp <= exp_sum + 1;
                    end else begin
                        // MSB at bit 46, shift left 1 to normalize, exponent stays
                        norm_shift <= 1'b0;
                        norm_mant <= mant_product << 1;
                        rounded_exp <= exp_sum;
                    end
                end
                ROUND: begin
                    // Extract bits for rounding according to IEEE 754 round to nearest even

                    if (norm_shift) begin
                        // Leading one at bit 47
                        // Mantissa bits: bits 46 down to 23 (24 bits including implicit leading 1)
                        // Guard bit: 22
                        // Round bit: 21
                        // Sticky: OR of bits 20 downto 0
                        guard_bit <= norm_mant[22];
                        round_bit <= norm_mant[21];
                        sticky_bit <= |norm_mant[20:0];

                        // Combine mantissa bits to 24 bits
                        // Concatenate leading 1 implicitly, but stored as bits [46:23]
                        // This forms the 24-bit mantissa (1 implicit + 23 fraction bits)
                        round_sum[24:1] <= norm_mant[46:23];
                        round_sum[0] <= 1'b0; // zero LSB for rounding adjustment

                    end else begin
                        // Leading one at bit 46 after left shift normalization
                        // Mantissa bits: bits 45 down to 22
                        // Guard bit: 21
                        // Round bit: 20
                        // Sticky: OR bits 19 downto 0
                        guard_bit <= norm_mant[21];
                        round_bit <= norm_mant[20];
                        sticky_bit <= |norm_mant[19:0];

                        round_sum[24:1] <= norm_mant[45:22];
                        round_sum[0] <= 1'b0;
                    end

                    // Perform rounding: round-to-nearest-even
                    // Round up if guard=1 and (round=1 or sticky=1 or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || round_sum[1])) begin
                        round_sum <= {1'b0, round_sum[24:1]} + 1'b1;
                    end else begin
                        round_sum <= {1'b0, round_sum[24:1]};
                    end

                    // If mantissa overflows beyond 24 bits, shift right and increment exponent
                    if (round_sum[24]) begin
                        round_sum <= round_sum >> 1;
                        rounded_exp <= rounded_exp + 1;
                    end
                end
                PACK: begin
                    // Pack output based on special flags or normal result

                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=all ones, MSB of fraction=1 to indicate quiet NaN, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity with correct sign
                        z <= {reg_z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with correct sign
                        z <= {reg_z_sign, 31'd0};
                    end else begin
                        // Normal numbers: check exponent overflow/underflow

                        if (rounded_exp >= EXP_MAX) begin
                            // Overflow exponent => infinity
                            z <= {reg_z_sign, 8'hFF, 23'd0};
                        end else if (rounded_exp <= 0) begin
                            // Underflow, output zero (no subnormal support)
                            z <= {reg_z_sign, 31'd0};
                        end else begin
                            // Normalized output
                            // fraction is bottom 23 bits of round_sum
                            z <= {reg_z_sign, rounded_exp[7:0], round_sum[22:0]};
                        end
                    end
                end
                default: begin
                    // Default no operation
                end
            endcase
        end
    end

endmodule