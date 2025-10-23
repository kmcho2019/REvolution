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
    localparam MANT_WIDTH = 24; // including implicit bit

    // FSM states
    typedef enum reg [2:0] {
        S_IDLE        = 3'd0,
        S_LOAD        = 3'd1,
        S_CHECK_SPEC  = 3'd2,
        S_MUL         = 3'd3,
        S_NORMALIZE   = 3'd4,
        S_ROUND       = 3'd5,
        S_PACK        = 3'd6
    } state_t;

    reg [2:0] state, next_state;

    // Input decoded wires
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_is_nan  = (a_exp == EXP_MAX) && (a_frac != 0);
    wire b_is_nan  = (b_exp == EXP_MAX) && (b_frac != 0);
    wire a_is_inf  = (a_exp == EXP_MAX) && (a_frac == 0);
    wire b_is_inf  = (b_exp == EXP_MAX) && (b_frac == 0);
    wire a_is_zero = (a_exp == 0) && (a_frac == 0);
    wire b_is_zero = (b_exp == 0) && (b_frac == 0);

    // Registered inputs & flags
    reg reg_a_sign, reg_b_sign, reg_z_sign;
    reg [7:0] reg_a_exp, reg_b_exp;
    reg [22:0] reg_a_frac, reg_b_frac;
    reg reg_a_is_nan, reg_b_is_nan;
    reg reg_a_is_inf, reg_b_is_inf;
    reg reg_a_is_zero, reg_b_is_zero;

    reg [MANT_WIDTH-1:0] reg_a_mant, reg_b_mant;

    // Multiply product 48 bits (24x24)
    reg [47:0] mant_product;

    // Exponent calculation - 10 bits signed for possible overflows
    reg signed [9:0] exp_sum;

    // Normalization stage outputs
    reg [47:0] norm_mant;
    reg signed [9:0] norm_exp;

    // Count how many left shifts done (0..2)
    reg [1:0] norm_shifts;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [24:0] round_mant; // 25 bits to detect overflow after rounding
    reg signed [9:0] round_exp;

    // Special flags for NaN, Inf, Zero
    reg special_nan, special_inf, special_zero;

    // Temporary variables for PACK state
    reg [24:0] mant_rounded;
    reg signed [9:0] exp_rounded;
    reg       round_increment;

    // Sticky bit for subnormal rounding
    reg sticky_subnormal;

    // FSM next state logic
    always @(*) begin
        case(state)
            S_IDLE:         next_state = S_LOAD;
            S_LOAD:         next_state = S_CHECK_SPEC;
            S_CHECK_SPEC:   if (special_nan || special_inf || special_zero) next_state = S_PACK; else next_state = S_MUL;
            S_MUL:          next_state = S_NORMALIZE;
            S_NORMALIZE:    next_state = S_ROUND;
            S_ROUND:        next_state = S_PACK;
            S_PACK:         next_state = S_IDLE;
            default:        next_state = S_IDLE;
        endcase
    end

    // Helper: count leading zeros in 48-bit mantissa for normalization (only for lower bits)
    // We only shift max 2 bits left here, so no complex clz needed

    // Combinational normalization:
    // - If product[47] == 1, normalized, exp +1
    // - else if product[46] == 1, shift left 1, exp unchanged
    // - else shift left 2, exp -1

    // Combinational rounding and sticky bit extraction per round count (0..2)

    // Calculate sticky bit from shifted out bits safely using bitwise OR loop.

    // For subnormal handling in PACK state, avoid variable part-selects by using a for loop.

    integer i;

    // Clear on reset and registers update FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            z <= 32'd0;

            reg_a_sign <= 0; reg_b_sign <= 0; reg_z_sign <= 0;
            reg_a_exp <= 0; reg_b_exp <= 0;
            reg_a_frac <= 0; reg_b_frac <= 0;

            reg_a_is_nan <= 0; reg_b_is_nan <= 0;
            reg_a_is_inf <= 0; reg_b_is_inf <= 0;
            reg_a_is_zero <= 0; reg_b_is_zero <= 0;

            reg_a_mant <= 0; reg_b_mant <= 0;

            mant_product <= 0;
            exp_sum <= 0;

            norm_mant <= 0;
            norm_exp <= 0;
            norm_shifts <= 0;

            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;

            round_mant <= 0;
            round_exp <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;

            mant_rounded <= 0;
            exp_rounded <= 0;
            round_increment <= 0;

            sticky_subnormal <= 0;
        end else begin
            state <= next_state;

            case(state)
                S_IDLE: begin
                    // Wait for inputs
                end
                S_LOAD: begin
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

                    // Mantissa with implicit leading 1 if exponent != 0, else zero for denormals
                    reg_a_mant <= (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
                    reg_b_mant <= (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;
                end
                S_CHECK_SPEC: begin
                    // Special cases according to IEEE 754

                    if (reg_a_is_nan || reg_b_is_nan) begin
                        special_nan <= 1;
                    end else if ((reg_a_is_inf && reg_b_is_zero) || (reg_b_is_inf && reg_a_is_zero)) begin
                        // Inf * 0 = NaN
                        special_nan <= 1;
                    end else if (reg_a_is_inf || reg_b_is_inf) begin
                        special_inf <= 1;
                    end else if (reg_a_is_zero || reg_b_is_zero) begin
                        special_zero <= 1;
                    end else begin
                        special_nan <= 0;
                        special_inf <= 0;
                        special_zero <= 0;
                    end
                end
                S_MUL: begin
                    // Multiply mantissas (24x24=48 bits)
                    mant_product <= reg_a_mant * reg_b_mant;

                    // Sum exponents minus bias (cast to signed 10 bits)
                    exp_sum <= $signed({2'b00, reg_a_exp}) + $signed({2'b00, reg_b_exp}) - EXP_BIAS;
                end
                S_NORMALIZE: begin
                    // Normalize mantissa product and adjust exponent
                    if (mant_product[47]) begin
                        norm_mant <= mant_product;
                        norm_exp <= exp_sum + 10'sd1;
                        norm_shifts <= 2'd0;
                    end else if (mant_product[46]) begin
                        norm_mant <= mant_product << 1;
                        norm_exp <= exp_sum;
                        norm_shifts <= 2'd1;
                    end else begin
                        norm_mant <= mant_product << 2;
                        norm_exp <= exp_sum - 10'sd1;
                        norm_shifts <= 2'd2;
                    end
                end
                S_ROUND: begin
                    // Extract mantissa and rounding bits according to norm_shifts
                    reg [23:0] mantissa_24;
                    reg gb, rb;
                    reg [20:0] sticky_range;

                    case(norm_shifts)
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

                    guard_bit <= gb;
                    round_bit <= rb;
                    sticky_bit <= (|sticky_range);

                    round_exp <= norm_exp;

                    // Compose 25-bit mantissa for rounding (add LSB 0 for round tie)
                    round_mant[24:1] <= mantissa_24;
                    round_mant[0] <= 1'b0;
                end
                S_PACK: begin
                    // Compute round increment per round-to-nearest-even
                    round_increment <= guard_bit && (round_bit || sticky_bit || round_mant[1]);
                    mant_rounded <= round_mant + (round_increment ? 25'd1 : 25'd0);
                    exp_rounded <= round_exp;

                    // Handle mantissa overflow after rounding
                    if (round_increment) begin
                        if (mant_rounded[24]) begin
                            mant_rounded <= mant_rounded >> 1;
                            exp_rounded <= exp_rounded + 10'sd1;
                        end
                    end

                    // Assign outputs based on special cases or normal path
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=255, MSB fraction=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity output with sign
                        z <= {reg_z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero output with sign
                        z <= {reg_z_sign, 31'd0};
                    end else begin
                        // Normal number handling

                        if (exp_rounded >= EXP_MAX) begin
                            // Overflow to infinity
                            z <= {reg_z_sign, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 0) begin
                            // Underflow: subnormal or zero
                            // Shift mantissa right by 1 - exp_rounded (positive)
                            integer shift_amt;
                            reg [24:0] shifted_mant;
                            reg sticky_tmp;

                            shift_amt = 1 - exp_rounded;

                            // Shift mantissa with sticky bit calculation
                            shifted_mant = mant_rounded;
                            sticky_tmp = 1'b0;

                            // Perform shift in a loop (shift by shift_amt), accumulate sticky bits
                            for (i = 0; i < shift_amt; i = i + 1) begin
                                // sticky_tmp |= LSB before shift
                                sticky_tmp = sticky_tmp | shifted_mant[0];
                                shifted_mant = shifted_mant >> 1;
                            end

                            // After shifting, if sticky_tmp set, set LSB sticky bit in mantissa
                            if (sticky_tmp)
                                shifted_mant[0] = 1'b1;

                            // Compose subnormal number: exponent=0
                            // mantissa is low 23 bits of shifted mantissa
                            if (shift_amt > 24) begin
                                // Too small, flush to zero
                                z <= {reg_z_sign, 31'd0};
                            end else begin
                                z <= {reg_z_sign, 8'd0, shifted_mant[22:0]};
                            end

                        end else begin
                            // Normalized number: exponent in range [1..254]
                            z <= {reg_z_sign, exp_rounded[7:0], mant_rounded[22:0]};
                        end
                    end

                    // Clear special flags for next operation
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;
                end
            endcase
        end
    end

endmodule