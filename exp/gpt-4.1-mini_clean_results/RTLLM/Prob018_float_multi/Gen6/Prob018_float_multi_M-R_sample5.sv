module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    typedef enum reg [1:0] {IDLE=2'd0, CALC=2'd1, DONE=2'd2} state_t;
    reg [1:0] state, next_state;

    // Registered inputs
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Special flags for inputs
    reg a_zero_r, b_zero_r;
    reg a_inf_r,  b_inf_r;
    reg a_nan_r,  b_nan_r;

    // Latched inputs with implicit leading bits (24 bits)
    reg [23:0] a_mant_r, b_mant_r;

    // Outputs of combinational calculations in CALC stage
    reg [47:0] product_c;
    reg [9:0]  exp_sum_c;
    reg        sign_c;

    reg special_nan_c, special_nan_out_c, special_inf_c, special_zero_c;

    // Normalization and rounding combinational signals
    reg [47:0] norm_product_c;
    reg [9:0] norm_exp_c;
    reg guard_bit_c, round_bit_c, sticky_bit_c;
    reg [23:0] mantissa_c;

    reg round_increment_c;
    reg [24:0] mant_rounded_c;
    reg [23:0] mant_rounded_final_c;
    reg [9:0]  exp_rounded_c;

    // Functions for detecting special cases and normalization rounding
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Input latching & state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            a_sign_r <= 0; b_sign_r <= 0;
            a_exp_r <= 0; b_exp_r <= 0;
            a_frac_r <= 0; b_frac_r <= 0;

            a_zero_r <= 0; b_zero_r <= 0;
            a_inf_r <= 0; b_inf_r <= 0;
            a_nan_r <= 0; b_nan_r <= 0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Latch inputs
                a_sign_r <= a[31];
                b_sign_r <= b[31];
                a_exp_r  <= a[30:23];
                b_exp_r  <= b[30:23];
                a_frac_r <= a[22:0];
                b_frac_r <= b[22:0];

                a_zero_r <= is_zero(a[30:23], a[22:0]);
                b_zero_r <= is_zero(b[30:23], b[22:0]);
                a_inf_r  <= is_inf(a[30:23], a[22:0]);
                b_inf_r  <= is_inf(b[30:23], b[22:0]);
                a_nan_r  <= is_nan(a[30:23], a[22:0]);
                b_nan_r  <= is_nan(b[30:23], b[22:0]);
            end

            if (state == DONE) begin
                z <= 
                    special_nan_c ? {1'b0, 8'hFF, 1'b1, 22'd0} : // quiet NaN
                    special_nan_out_c ? {1'b0, 8'hFF, 1'b1, 22'd0} : // special NaN from inf*zero
                    special_inf_c ? {sign_c, 8'hFF, 23'd0} :       // infinity
                    special_zero_c ? {sign_c, 31'd0} :             // zero
                    (exp_rounded_c[9:8] != 2'd0) ? {sign_c, 8'hFF, 23'd0} : // overflow to inf
                    (exp_rounded_c <= 0) ? {sign_c, 31'd0} :       // underflow to zero (no subnormals)
                    {sign_c, exp_rounded_c[7:0], mant_rounded_final_c[22:0]}; // normalized
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = CALC;
            CALC:  next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for calculation stage
    always @(*) begin
        // Compose mantissas with implicit leading bit (1 for normalized, 0 for denormals)
        a_mant_r = (a_exp_r == 8'd0) ? {1'b0, a_frac_r} : {1'b1, a_frac_r};
        b_mant_r = (b_exp_r == 8'd0) ? {1'b0, b_frac_r} : {1'b1, b_frac_r};

        // Multiply mantissas 24x24 = 48 bits
        product_c = a_mant_r * b_mant_r;

        // Exponent sum with bias subtraction, extended width for overflow detection
        exp_sum_c = a_exp_r + b_exp_r - EXP_BIAS;

        // Result sign
        sign_c = a_sign_r ^ b_sign_r;

        // Special cases detection
        special_nan_c = a_nan_r || b_nan_r;
        special_nan_out_c = ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r));
        special_inf_c = (a_inf_r || b_inf_r) && !special_nan_out_c;
        special_zero_c = (a_zero_r || b_zero_r) && !special_nan_out_c && !special_inf_c;

        // Normalization:
        // If MSB product_c[47] == 1 => shift right by 1 and exponent +1
        if (product_c[47]) begin
            norm_product_c = product_c >> 1;
            norm_exp_c = exp_sum_c + 1;
        end else begin
            norm_product_c = product_c;
            norm_exp_c = exp_sum_c;
        end

        // Extract mantissa bits for output, bits [46:23] correspond to mantissa + rounding bits
        mantissa_c = norm_product_c[46:23];

        // Rounding bits: guard=bit 23, round=bit 22, sticky=OR of bits [21:0]
        guard_bit_c = norm_product_c[23];
        round_bit_c = norm_product_c[22];
        sticky_bit_c = |norm_product_c[21:0];

        // Round to nearest even
        round_increment_c = guard_bit_c && (round_bit_c || sticky_bit_c || mantissa_c[0]);

        mant_rounded_c = {1'b0, mantissa_c} + round_increment_c;

        // Check if rounding caused overflow (bit 24 set)
        if (mant_rounded_c[24]) begin
            mant_rounded_final_c = mant_rounded_c[24:1];
            exp_rounded_c = norm_exp_c + 1;
        end else begin
            mant_rounded_final_c = mant_rounded_c[23:0];
            exp_rounded_c = norm_exp_c;
        end
    end

endmodule