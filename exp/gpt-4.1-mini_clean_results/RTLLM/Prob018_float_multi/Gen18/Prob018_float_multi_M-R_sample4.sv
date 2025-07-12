module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // FSM States
    localparam S_IDLE       = 2'd0;
    localparam S_MULTIPLY   = 2'd1;
    localparam S_NORMALIZE  = 2'd2;
    localparam S_ROUND      = 2'd3;

    reg [1:0] state, next_state;

    // Stage registers for inputs and extracted fields
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Special flags registered
    reg a_zero_r, b_zero_r;
    reg a_inf_r, b_inf_r;
    reg a_nan_r, b_nan_r;

    // Mantissas with implicit bit registered
    reg [23:0] a_mant_r, b_mant_r;

    // Product and exponent sum registers
    reg [47:0] product_r;    // 24x24=48 bits
    reg [9:0] exp_sum_r;     // exponent sum with extra bits to hold overflow

    reg sign_res_r;

    // Normalized mantissa and exponent registers
    reg [23:0] norm_mant_r;
    reg [9:0] norm_exp_r;

    // Rounding bits registers
    reg guard_r, round_r, sticky_r;

    // Rounding result registers
    reg [24:0] mantissa_rounded_r;
    reg [9:0] exponent_rounded_r;

    // --- Combinational signals for extraction and special cases (cycle 0) ---
    wire a_sign = a[31];
    wire b_sign = b[31];

    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];

    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 for normalized, 0 for denormals
    wire [23:0] a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Sign of result (XOR)
    wire sign_res = a_sign ^ b_sign;

    // --- Cycle 1 combinational: mantissa multiply and exponent add ---
    wire [47:0] product = a_mant_r * b_mant_r;
    wire [9:0] exp_sum = a_exp_r + b_exp_r - EXP_BIAS;

    // --- Cycle 2 combinational: normalization and extraction of rounding bits ---
    // Normalize product: check top bit
    wire product_top_bit = product_r[47];

    wire [23:0] norm_mantissa = product_top_bit ? product_r[47:24] : product_r[46:23];
    wire [9:0] norm_exponent = product_top_bit ? (exp_sum_r + 10'd1) : exp_sum_r;

    // Guard, round, sticky bits for rounding (depending on normalization shift)
    wire guard_bit = product_top_bit ? product_r[23] : product_r[22];
    wire round_bit = product_top_bit ? product_r[22] : product_r[21];
    wire sticky_bit = product_top_bit ? |product_r[21:0] : |product_r[20:0];

    // --- Cycle 3 combinational: rounding and special cases ---

    // Round increment logic: Round to nearest even
    wire round_increment = guard_r && (round_r | sticky_r | norm_mant_r[0]);

    wire [24:0] mantissa_plus = {1'b0, norm_mant_r} + (round_increment ? 25'd1 : 25'd0);

    // Handle mantissa overflow after rounding
    wire mantissa_overflow = mantissa_plus[24];

    wire [9:0] exponent_after_round = mantissa_overflow ? norm_exp_r + 10'd1 : norm_exp_r;

    // Final exponent clipping
    wire exponent_max = (exponent_after_round >= 10'd255);
    wire exponent_underflow = (exponent_after_round <= 0);

    // Final exponent and mantissa for output (consider overflow/underflow)
    wire [7:0] final_exp = exponent_max ? 8'hFF :
                          (exponent_underflow ? 8'd0 : exponent_after_round[7:0]);

    wire [22:0] final_frac = exponent_max ? 23'd0 :
                            mantissa_overflow ? mantissa_plus[23:1] : mantissa_plus[22:0];

    // Prepare special case outputs
    wire [31:0] qnan = {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN

    wire special_nan = a_nan_r | b_nan_r;
    wire special_inf_zero = (a_inf_r & b_zero_r) | (b_inf_r & a_zero_r);
    wire special_inf = a_inf_r | b_inf_r;
    wire special_zero = a_zero_r | b_zero_r;

    // Final output mux combinational
    wire [31:0] final_result = special_nan      ? qnan :
                              special_inf_zero  ? qnan :
                              special_inf       ? {sign_res_r, 8'hFF, 23'd0} :
                              special_zero      ? {sign_res_r, 31'd0} :
                              exponent_max      ? {sign_res_r, 8'hFF, 23'd0} : // overflow to inf
                              exponent_underflow? {sign_res_r, 31'd0} :       // underflow to zero
                              {sign_res_r, final_exp, final_frac};

    // Sequential FSM and register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            z <= 32'd0;

            // Clear stage registers
            a_sign_r <= 0; b_sign_r <= 0;
            a_exp_r <= 0; b_exp_r <= 0;
            a_frac_r <= 0; b_frac_r <= 0;

            a_zero_r <= 0; b_zero_r <= 0;
            a_inf_r <= 0; b_inf_r <= 0;
            a_nan_r <= 0; b_nan_r <= 0;

            a_mant_r <= 0; b_mant_r <= 0;

            product_r <= 0;
            exp_sum_r <= 0;
            sign_res_r <= 0;

            norm_mant_r <= 0;
            norm_exp_r <= 0;

            guard_r <= 0; round_r <= 0; sticky_r <= 0;

            mantissa_rounded_r <= 0;
            exponent_rounded_r <= 0;
        end else begin
            state <= next_state;
            case(state)
                S_IDLE: begin
                    // Latch inputs and extract fields
                    a_sign_r <= a_sign;
                    b_sign_r <= b_sign;
                    a_exp_r <= a_exp;
                    b_exp_r <= b_exp;
                    a_frac_r <= a_frac;
                    b_frac_r <= b_frac;
                    a_zero_r <= a_zero;
                    b_zero_r <= b_zero;
                    a_inf_r <= a_inf;
                    b_inf_r <= b_inf;
                    a_nan_r <= a_nan;
                    b_nan_r <= b_nan;
                    a_mant_r <= a_mant;
                    b_mant_r <= b_mant;
                    sign_res_r <= sign_res;
                end

                S_MULTIPLY: begin
                    product_r <= product;
                    exp_sum_r <= exp_sum;
                end

                S_NORMALIZE: begin
                    norm_mant_r <= norm_mantissa;
                    norm_exp_r <= norm_exponent;
                    guard_r <= guard_bit;
                    round_r <= round_bit;
                    sticky_r <= sticky_bit;
                end

                S_ROUND: begin
                    mantissa_rounded_r <= mantissa_plus;
                    exponent_rounded_r <= exponent_after_round;
                    z <= final_result;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            S_IDLE:     next_state = S_MULTIPLY;
            S_MULTIPLY: next_state = S_NORMALIZE;
            S_NORMALIZE:next_state = S_ROUND;
            S_ROUND:    next_state = S_IDLE;
            default:    next_state = S_IDLE;
        endcase
    end

endmodule