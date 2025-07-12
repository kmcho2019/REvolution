module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // FSM States
    typedef enum reg [2:0] {
        IDLE          = 3'd0,
        INPUT_CAPTURE = 3'd1,
        MULTIPLY      = 3'd2,
        NORMALIZE     = 3'd3,
        OUTPUT_STAGE  = 3'd4
    } state_t;

    state_t state, next_state;

    // Registered input decomposed signals
    reg          a_sign, b_sign;
    reg  [7:0]   a_exp, b_exp;
    reg  [22:0]  a_frac, b_frac;

    // Special flags
    reg          a_zero, b_zero;
    reg          a_inf, b_inf;
    reg          a_nan, b_nan;

    // Extended mantissas for multiply (including hidden bit or zero for denormals)
    reg  [23:0]  a_mantissa, b_mantissa;

    // Multiply result and intermediate signals
    reg  [47:0]  product;

    // Sum of exponents, with one extra bit for overflow/underflow
    reg  [8:0]   exp_sum;

    // Sign of output
    reg          z_sign;

    // Special case encoding for output handling
    // 0 = none, 1 = NaN, 2 = Inf, 3 = NaN due to inf*zero
    reg  [1:0]   special_case;

    // Normalized exponent and mantissa before rounding
    reg  [8:0]   exp_norm;
    reg  [23:0]  mantissa_norm;

    // Wires for combinational calculations

    // Special case combinational detection for current inputs
    wire input_a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire input_b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire input_a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire input_b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire input_a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire input_b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    wire [23:0] a_mant_w = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant_w = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Special case combinational signals for multiplication stage
    wire spec_nan = a_nan || b_nan;
    wire spec_nan_infzero = (a_inf && b_zero) || (b_inf && a_zero);
    wire spec_inf = (a_inf || b_inf) && !spec_nan_infzero && !spec_nan;
    wire spec_zero = (a_zero || b_zero) && !spec_nan_infzero && !spec_inf && !spec_nan;

    // Product and exponent sum for multiply stage (combinational)
    wire [47:0] product_w = a_mantissa * b_mantissa;
    wire [9:0]  exp_sum_w_10b = {1'b0, a_exp} + {1'b0, b_exp} - EXP_BIAS;
    wire [8:0]  exp_sum_w = exp_sum_w_10b[8:0];

    // Sign xor
    wire sign_w = a_sign ^ b_sign;

    // Normalization & rounding combinational wires (used in NORMALIZE state)

    // Decide if normalization shift needed (if product's MSB == 1)
    wire norm_shift = product[47];

    wire [8:0] exp_norm_pre = exp_sum + (norm_shift ? 9'd1 : 9'd0);
    wire [47:0] product_norm = norm_shift ? (product >> 1) : product;

    wire [23:0] mantissa_raw = product_norm[46:23];

    wire guard_bit = product_norm[22];
    wire round_bit = product_norm[21];
    wire sticky_bit = |product_norm[20:0];

    wire round_incr = guard_bit && (round_bit || sticky_bit || mantissa_raw[0]);

    wire [24:0] mantissa_rounded = {1'b0, mantissa_raw} + round_incr;

    wire mantissa_overflow = mantissa_rounded[24];

    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [8:0]  exp_final = mantissa_overflow ? exp_norm_pre + 9'd1 : exp_norm_pre;

    wire overflow = (exp_final[8]) || (exp_final[7:0] >= 8'hFF);
    wire underflow = (!exp_final[8]) && (exp_final[7:0] == 8'd0);

    // Final assembled outputs for special cases
    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf_result = {z_sign, 8'hFF, 23'd0};
    wire [31:0] zero_result = {z_sign, 31'd0};
    wire [31:0] normal_result = {z_sign, exp_final[7:0], mantissa_final[22:0]};

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            // Reset all registers to zero
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_frac <= 23'd0;
            b_frac <= 23'd0;
            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            product <= 48'd0;
            exp_sum <= 9'd0;
            z_sign <= 1'b0;
            special_case <= 2'd0;
            exp_norm <= 9'd0;
            mantissa_norm <= 24'd0;
            z <= 32'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Nothing to do
                end

                INPUT_CAPTURE: begin
                    // Capture inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= input_a_zero;
                    b_zero <= input_b_zero;
                    a_inf <= input_a_inf;
                    b_inf <= input_b_inf;
                    a_nan <= input_a_nan;
                    b_nan <= input_b_nan;

                    a_mantissa <= a_mant_w;
                    b_mantissa <= b_mant_w;
                end

                MULTIPLY: begin
                    // Perform multiply and exponent sum
                    product <= product_w;
                    exp_sum <= exp_sum_w;
                    z_sign <= sign_w;

                    // Determine special cases for output
                    if (spec_nan)
                        special_case <= 2'b01;
                    else if (spec_nan_infzero)
                        special_case <= 2'b11;
                    else if (spec_inf)
                        special_case <= 2'b10;
                    else if (spec_zero)
                        special_case <= 2'b11; // treat zero with inf*zero as special NaN
                    else
                        special_case <= 2'b00;
                end

                NORMALIZE: begin
                    // Normalize and round
                    exp_norm <= exp_final;
                    mantissa_norm <= mantissa_final;
                end

                OUTPUT_STAGE: begin
                    // Output result based on special cases and overflow/underflow

                    case (special_case)
                        2'b01: z <= nan_result; // NaN input
                        2'b11: z <= nan_result; // inf*zero NaN
                        2'b10: z <= inf_result; // Infinity output
                        default: begin
                            if (overflow)
                                z <= inf_result;
                            else if (underflow)
                                z <= zero_result;
                            else
                                z <= normal_result;
                        end
                    endcase
                end

                default: begin
                    // Default nothing
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE:           next_state = INPUT_CAPTURE;
            INPUT_CAPTURE:  next_state = MULTIPLY;
            MULTIPLY:       next_state = NORMALIZE;
            NORMALIZE:      next_state = OUTPUT_STAGE;
            OUTPUT_STAGE:   next_state = INPUT_CAPTURE; // loop back for next multiplication
            default:        next_state = IDLE;
        endcase
    end

endmodule