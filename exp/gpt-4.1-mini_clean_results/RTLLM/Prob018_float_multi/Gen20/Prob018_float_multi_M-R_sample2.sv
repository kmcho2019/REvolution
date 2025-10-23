module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        MUL  = 2'd2,
        NORM = 2'd3
    } state_t;

    state_t state, next_state;

    // Stage 0 signals (input capture)
    reg          a_sign_r, b_sign_r;
    reg  [7:0]   a_exp_r, b_exp_r;
    reg  [22:0]  a_frac_r, b_frac_r;

    // Special input flags
    reg          a_zero_r, b_zero_r;
    reg          a_inf_r,  b_inf_r;
    reg          a_nan_r,  b_nan_r;

    // Mantissas with hidden bit
    reg  [23:0]  a_mant_r, b_mant_r;

    // Stage 1 signals (multiplication)
    reg  [47:0]  product_r;
    reg  [8:0]   exp_sum_r;   // 9 bits to allow overflow
    reg          sign_r;
    reg  [1:0]   special_case_r; 
    // Encoded special cases:
    // 00 = none, 01 = NaN, 10 = Inf, 11 = zero with inf*zero NaN output

    // Stage 2 signals (normalization and rounding)
    reg  [8:0]   exp_norm_r;
    reg  [23:0]  mantissa_norm_r;
    reg          sign_norm_r;
    reg  [1:0]   special_case_norm_r;

    // Combinational special case detection (stage 0)
    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

    wire a_is_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    wire [23:0] a_mantissa_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Exponent sum wire for multiplication stage
    wire [9:0] exp_sum_w_10b = {1'b0, a_exp_r} + {1'b0, b_exp_r} - EXP_BIAS;
    wire [8:0] exp_sum_w = exp_sum_w_10b[8:0];

    // Sign XOR
    wire sign_w = a_sign_r ^ b_sign_r;

    // Special case determinations (after LOAD)
    wire special_nan_w = a_nan_r || b_nan_r;
    wire special_nan_out_w = (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
    wire special_inf_w = (a_inf_r || b_inf_r) && !special_nan_out_w && !special_nan_w;
    wire special_zero_w = (a_zero_r || b_zero_r) && !special_nan_out_w && !special_inf_w && !special_nan_w;

    // Product wire for multiplication stage
    wire [47:0] product_w = a_mant_r * b_mant_r;

    // ----- Normalization, rounding, and final packing combinational -----
    // Normalization depends on product_r and exp_sum_r at NORM stage

    wire norm_shift = product_r[47];
    wire [8:0] exp_norm_pre = exp_sum_r + (norm_shift ? 9'd1 : 9'd0);
    wire [47:0] product_norm = norm_shift ? (product_r >> 1) : product_r;

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

    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf_result = {sign_norm_r, 8'hFF, 23'd0};
    wire [31:0] zero_result = {sign_norm_r, 31'd0};
    wire [31:0] normal_result = {sign_norm_r, exp_final[7:0], mantissa_final[22:0]};

    // ----- State Machine -----
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            // Reset outputs
            z <= 32'd0;

            // Reset internal registers
            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;
            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0; b_inf_r <= 1'b0;
            a_nan_r <= 1'b0; b_nan_r <= 1'b0;
            a_mant_r <= 24'd0; b_mant_r <= 24'd0;

            product_r <= 48'd0;
            exp_sum_r <= 9'd0;
            sign_r <= 1'b0;
            special_case_r <= 2'b00;

            exp_norm_r <= 9'd0;
            mantissa_norm_r <= 24'd0;
            sign_norm_r <= 1'b0;
            special_case_norm_r <= 2'b00;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    z <= 32'd0;
                end
                LOAD: begin
                    // Capture inputs and special case flags
                    a_sign_r <= a[31];
                    b_sign_r <= b[31];
                    a_exp_r <= a[30:23];
                    b_exp_r <= b[30:23];
                    a_frac_r <= a[22:0];
                    b_frac_r <= b[22:0];
                    a_zero_r <= a_is_zero;
                    b_zero_r <= b_is_zero;
                    a_inf_r <= a_is_inf;
                    b_inf_r <= b_is_inf;
                    a_nan_r <= a_is_nan;
                    b_nan_r <= b_is_nan;
                    a_mant_r <= a_mantissa_w;
                    b_mant_r <= b_mantissa_w;
                end
                MUL: begin
                    // Perform multiplication and exponent addition
                    product_r <= product_w;
                    exp_sum_r <= exp_sum_w;
                    sign_r <= sign_w;

                    // Determine special cases
                    special_case_r <=
                        (special_nan_w)   ? 2'b01 : // NaN
                        (special_nan_out_w) ? 2'b11 : // inf*zero NaN
                        (special_inf_w)   ? 2'b10 : // Inf
                        (special_zero_w)  ? 2'b11 : // zero with inf*zero NaN output reused
                        2'b00;
                end
                NORM: begin
                    // Save normalized and rounded outputs for output generation
                    exp_norm_r <= exp_final;
                    mantissa_norm_r <= mantissa_final;
                    sign_norm_r <= sign_r;
                    special_case_norm_r <= special_case_r;

                    // Output mux based on special case and overflow/underflow
                    case(special_case_r)
                        2'b01: z <= nan_result; // NaN
                        2'b11: z <= nan_result; // inf*zero NaN output
                        2'b10: z <= inf_result; // Infinity
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
            endcase
        end
    end

    // ----- Next State Logic -----
    always @(*) begin
        case(state)
            IDLE: next_state = LOAD;
            LOAD: next_state = MUL;
            MUL:  next_state = NORM;
            NORM: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule