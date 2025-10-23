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

    // Mantissas with implicit leading bits (24 bits)
    reg [23:0] reg_a_mant, reg_b_mant;

    // Mantissa multiplication result 48 bits (24x24)
    reg [47:0] mant_product;

    // Sum of exponents minus bias, 10-bit to allow overflow per problem description
    reg signed [9:0] exp_sum;

    // Normalized mantissa and exponent after normalization
    reg [47:0] norm_mant;
    reg signed [9:0] norm_exp;

    // Number of left shifts done during normalization (up to 2)
    reg [1:0] norm_shift_count;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [24:0] round_mant; // 25 bits to detect overflow after rounding
    reg signed [9:0] round_exp;

    // Special result signals to propagate to PACK stage
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Sticky bit calculation helper
    wire sticky_any;

    // FSM next-state combinational logic
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

            reg_a_sign <= 1'b0; reg_b_sign <= 1'b0; reg_z_sign <= 1'b0;
            reg_a_exp <= 8'd0; reg_b_exp <= 8'd0;
            reg_a_frac <= 23'd0; reg_b_frac <= 23'd0;

            reg_a_is_nan <= 1'b0; reg_b_is_nan <= 1'b0;
            reg_a_is_inf <= 1'b0; reg_b_is_inf <= 1'b0;
            reg_a_is_zero <= 1'b0; reg_b_is_zero <= 1'b0;

            reg_a_mant <= 24'd0;
            reg_b_mant <= 24'd0;

            mant_product <= 48'd0;
            exp_sum <= 10'sd0;

            norm_mant <= 48'd0;
            norm_exp <= 10'sd0;
            norm_shift_count <= 2'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;

            round_mant <= 25'd0;
            round_exp <= 10'sd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // No action
                end
                CAPTURE: begin
                    // Latch inputs and decode mantissas (with implicit leading bit)
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

                    // Mantissa with implicit leading 1 if exponent != 0 (normalized), else 0 for denormals
                    reg_a_mant <= (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
                    reg_b_mant <= (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

                    // Clear special flags for next stage
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                end
                SPECIAL: begin
                    // Handle special cases per IEEE 754 rules
                    if (reg_a_is_nan || reg_b_is_nan) begin
                        // If either input is NaN, output quiet NaN (propagate payload if desired - simplified here)
                        special_nan <= 1'b1;
                    end else if ((reg_a_is_inf && reg_b_is_zero) || (reg_b_is_inf && reg_a_is_zero)) begin
                        // inf * 0 = NaN
                        special_nan <= 1'b1;
                    end else if (reg_a_is_inf || reg_b_is_inf) begin
                        // Infinity times non-zero, non-NaN => infinity
                        special_inf <= 1'b1;
                    end else if (reg_a_is_zero || reg_b_is_zero) begin
                        // Zero times non-infinity, non-NaN => zero
                        special_zero <= 1'b1;
                    end else begin
                        // No special cases, proceed to multiply
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;

                        mant_product <= reg_a_mant * reg_b_mant;

                        // Sum exponents minus bias, wide signed to allow overflow/underflow checks
                        // If either input is denormal (exp=0), this is handled naturally here (exponent zero)
                        exp_sum <= $signed({2'b00, reg_a_exp}) + $signed({2'b00, reg_b_exp}) - EXP_BIAS;
                    end
                end
                MUL_NORM: begin
                    // Normalize mantissa product and adjust exponent accordingly

                    // Start with mant_product as norm_mant
                    norm_mant <= mant_product;
                    norm_exp <= exp_sum;
                    norm_shift_count <= 2'd0;

                    // We will do normalization in 2 cycles total to avoid complexity,
                    // but since FSM is single-step, we perform up to two shifts here combinationally:
                    // product is 48 bits: MSB can be at bit 47 or less
                    // The correct normalized mantissa must have leading '1' at bit 47 (bit index from 0)
                    // Check if bit 47 is set (meaning product >= 2)
                    // else if bit 46 set (product >=1) shift left 1
                    // else shift left 2 and decrement exponent twice

                    // Because always @(posedge clk), we must compute combinationally here for clarity

                    if (mant_product[47]) begin
                        // MSB at bit 47, normalized, exponent increased by 1
                        norm_mant <= mant_product;
                        norm_exp <= exp_sum + 10'sd1;
                        norm_shift_count <= 2'd0;
                    end else if (mant_product[46]) begin
                        // MSB at bit 46, shift left 1 to normalize exponent unchanged
                        norm_mant <= mant_product << 1;
                        norm_exp <= exp_sum;
                        norm_shift_count <= 2'd1;
                    end else begin
                        // MSB at bit 45 or lower, shift left 2 for normalization, exponent -1
                        norm_mant <= mant_product << 2;
                        norm_exp <= exp_sum - 10'sd1;
                        norm_shift_count <= 2'd2;
                    end
                end
                ROUND: begin
                    // Extract guard, round, sticky bits according to IEEE 754 round-to-nearest-even
                    // After normalization, the mantissa to use for rounding is bits [46:23] or [45:22] or [44:21] 
                    // depending on norm_shift_count:
                    // We fix to pick 24 bits mantissa (including implicit leading one):
                    // For norm_shift_count=0: mantissa bits = [46:23], guard=22, round=21, sticky=20:0
                    // norm_shift_count=1: mantissa bits = [45:22], guard=21, round=20, sticky=19:0
                    // norm_shift_count=2: mantissa bits = [44:21], guard=20, round=19, sticky=18:0

                    reg [23:0] mantissa_24;
                    reg gb, rb, sb;
                    reg [20:0] sticky_range;

                    case (norm_shift_count)
                        2'd0: begin
                            mantissa_24 = norm_mant[46:23];
                            gb = norm_mant[22];
                            rb = norm_mant[21];
                            sticky_range = norm_mant[20:0];
                        end
                        2'd1: begin
                            mantissa_24 = norm_mant[45:22];
                            gb = norm_mant[21];
                            rb = norm_mant[20];
                            sticky_range = norm_mant[19:0];
                        end
                        2'd2: begin
                            mantissa_24 = norm_mant[44:21];
                            gb = norm_mant[20];
                            rb = norm_mant[19];
                            sticky_range = norm_mant[18:0];
                        end
                        default: begin
                            mantissa_24 = norm_mant[46:23];
                            gb = norm_mant[22];
                            rb = norm_mant[21];
                            sticky_range = norm_mant[20:0];
                        end
                    endcase

                    sb = |sticky_range;

                    guard_bit <= gb;
                    round_bit <= rb;
                    sticky_bit <= sb;

                    // Set round_exp and round_mant
                    round_exp <= norm_exp;

                    // Compose the 25-bit mantissa with the LSB zero for rounding calculation:
                    // round_mant[24:1] is mantissa_24[23:0], round_mant[0] zero to simplify LSB checking
                    round_mant[24:1] <= mantissa_24;
                    round_mant[0] <= 1'b0;

                    // Perform rounding per round-to-nearest-even rule:
                    // Round up if guard = 1 and (round = 1 or sticky = 1 or LSB = 1)
                    // Using non-blocking assignments and sequential logic, compute increment after posedge.

                end
                PACK: begin
                    // After rounding and possible mantissa overflow adjustment, pack output
                    // Rounding increment and mantissa overflow handled here

                    // Precompute rounding increment flag
                    reg round_increment;
                    reg [24:0] mant_rounded;
                    reg signed [9:0] exp_rounded;

                    round_increment = (guard_bit && (round_bit || sticky_bit || round_mant[1]));

                    mant_rounded = round_mant + (round_increment ? 25'd1 : 25'd0);
                    exp_rounded = round_exp;

                    // Handle mantissa overflow after rounding (bit 24 is overflow)
                    if (mant_rounded[24]) begin
                        // Mantissa overflow: shift right and increment exponent
                        mant_rounded = mant_rounded >> 1;
                        exp_rounded = exp_rounded + 1;
                    end

                    // Assign outputs based on special cases and exponent range

                    if (special_nan) begin
                        // Output quiet NaN: sign=0, exp=255, MSB fraction=1, rest zero
                        // Could propagate payload but simplified here
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity with correct sign
                        z <= {reg_z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with correct sign
                        z <= {reg_z_sign, 31'd0};
                    end else begin
                        // Normal numbers

                        if (exp_rounded >= EXP_MAX) begin
                            // Overflow to infinity
                            z <= {reg_z_sign, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 0) begin
                            // Underflow, produce subnormal or zero
                            // Shift mantissa right by abs(exp_rounded)+1 to create subnormal (rounding ignored here)
                            // Since exp=0 means subnormal in IEEE 754
                            integer shift_amt;
                            reg [23:0] sub_mant;

                            shift_amt = 1 - exp_rounded; // positive value

                            if (shift_amt > 24) begin
                                // Too small, flush to zero
                                z <= {reg_z_sign, 31'd0};
                            end else begin
                                // Shift mantissa right with sticky bit
                                // mant_rounded[23:1] contains 23 bits mantissa fraction + implicit leading 1 at bit 23
                                // We consider mant_rounded[23:1] as 23 bits mantissa

                                // Create sticky bit from bits shifted out
                                reg sticky_sub;
                                reg [24:0] shifted_mant;

                                shifted_mant = mant_rounded[24:0] >> shift_amt;

                                // Sticky bit is OR of bits shifted out
                                sticky_sub = |(mant_rounded[shift_amt-1:0]);

                                sub_mant = shifted_mant[23:0];
                                if (sticky_sub)
                                    sub_mant = sub_mant | 1'b1; // sticky set

                                // Compose subnormal number (exponent = 0)
                                z <= {reg_z_sign, 8'd0, sub_mant[22:0]};
                            end
                        end else begin
                            // Normalized output exponent in [1..254]
                            // mantissa is bits 22:0 of mant_rounded
                            z <= {reg_z_sign, exp_rounded[7:0], mant_rounded[22:0]};
                        end
                    end

                    // Clear special flags for next round
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                end
            endcase
        end
    end

endmodule