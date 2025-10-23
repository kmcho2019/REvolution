module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    typedef enum reg [1:0] {IDLE=2'd0, MUL=2'd1, NORM=2'd2, DONE=2'd3} state_t;
    reg [1:0] state, next_state;

    // Stage 0 registers: input latching
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    reg a_zero_r, b_zero_r;
    reg a_inf_r,  b_inf_r;
    reg a_nan_r,  b_nan_r;

    // Mantissas with implicit leading bit
    reg [23:0] a_mant_r, b_mant_r;

    // Stage 1 registers: multiplication results
    reg [47:0] product_r;
    reg [9:0] exp_sum_r;
    reg sign_r;

    reg special_nan_r, special_nan_out_r, special_inf_r, special_zero_r;

    // Stage 2 registers: normalization and rounding inputs and outputs
    reg [47:0] norm_product_r;
    reg [9:0] norm_exp_r;
    reg guard_bit_r, round_bit_r, sticky_bit_r;
    reg [23:0] mantissa_r;

    reg round_increment_r;
    reg [24:0] mant_rounded_r;
    reg [23:0] mant_rounded_final_r;
    reg [9:0] exp_rounded_r;

    // Functions for special case detection
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // State machine next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = MUL;
            MUL:   next_state = NORM;
            NORM:  next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Stage 0: Input latching and special case detection
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

            a_mant_r <= 0; b_mant_r <= 0;

            product_r <= 0;
            exp_sum_r <= 0;
            sign_r <= 0;

            special_nan_r <= 0; special_nan_out_r <= 0;
            special_inf_r <= 0; special_zero_r <= 0;

            norm_product_r <= 0;
            norm_exp_r <= 0;

            guard_bit_r <= 0; round_bit_r <= 0; sticky_bit_r <= 0;
            mantissa_r <= 0;

            round_increment_r <= 0;
            mant_rounded_r <= 0;
            mant_rounded_final_r <= 0;
            exp_rounded_r <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
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

                    // Mantissas with implicit leading bit, for normalized inputs
                    a_mant_r <= (a_exp_r == 8'd0) ? {1'b0, a_frac_r} : {1'b1, a_frac_r};
                    b_mant_r <= (b_exp_r == 8'd0) ? {1'b0, b_frac_r} : {1'b1, b_frac_r};

                    // Clear stage 1 and 2 regs
                    product_r <= 0;
                    exp_sum_r <= 0;
                    sign_r <= 0;

                    special_nan_r <= 0; special_nan_out_r <= 0;
                    special_inf_r <= 0; special_zero_r <= 0;

                    norm_product_r <= 0;
                    norm_exp_r <= 0;

                    guard_bit_r <= 0; round_bit_r <= 0; sticky_bit_r <= 0;
                    mantissa_r <= 0;

                    round_increment_r <= 0;
                    mant_rounded_r <= 0;
                    mant_rounded_final_r <= 0;
                    exp_rounded_r <= 0;
                end

                MUL: begin
                    // Special cases detection
                    special_nan_r <= a_nan_r || b_nan_r;
                    special_nan_out_r <= ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r));
                    special_inf_r <= (a_inf_r || b_inf_r) && !special_nan_out_r;
                    special_zero_r <= (a_zero_r || b_zero_r) && !special_nan_out_r && !special_inf_r;

                    sign_r <= a_sign_r ^ b_sign_r;

                    // Only do multiplication if not special case (early bypass)
                    if (!special_nan_r && !special_nan_out_r && !special_inf_r && !special_zero_r) begin
                        product_r <= a_mant_r * b_mant_r;
                        exp_sum_r <= a_exp_r + b_exp_r - EXP_BIAS;
                    end else begin
                        product_r <= 0;
                        exp_sum_r <= 0;
                    end
                end

                NORM: begin
                    // Normalization
                    if (special_nan_r || special_nan_out_r || special_inf_r || special_zero_r) begin
                        // No normalization or rounding for special cases
                        norm_product_r <= 0;
                        norm_exp_r <= 0;
                        guard_bit_r <= 0;
                        round_bit_r <= 0;
                        sticky_bit_r <= 0;
                        mantissa_r <= 0;
                        round_increment_r <= 0;
                        mant_rounded_r <= 0;
                        mant_rounded_final_r <= 0;
                        exp_rounded_r <= 0;
                    end else begin
                        // Normalize product if leading bit set
                        if (product_r[47]) begin
                            norm_product_r <= product_r >> 1;
                            norm_exp_r <= exp_sum_r + 1;
                        end else begin
                            norm_product_r <= product_r;
                            norm_exp_r <= exp_sum_r;
                        end

                        // Extract mantissa and rounding bits
                        mantissa_r <= norm_product_r[46:23];
                        guard_bit_r <= norm_product_r[23];
                        round_bit_r <= norm_product_r[22];
                        sticky_bit_r <= |norm_product_r[21:0];

                        // Round to nearest even
                        round_increment_r <= guard_bit_r && (round_bit_r || sticky_bit_r || mantissa_r[0]);

                        mant_rounded_r <= {1'b0, mantissa_r} + round_increment_r;

                        if (mant_rounded_r[24]) begin
                            mant_rounded_final_r <= mant_rounded_r[24:1];
                            exp_rounded_r <= norm_exp_r + 1;
                        end else begin
                            mant_rounded_final_r <= mant_rounded_r[23:0];
                            exp_rounded_r <= norm_exp_r;
                        end
                    end
                end

                DONE: begin
                    // Output generation handled in next always block
                end

            endcase
        end
    end

    // Output register update in DONE state
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
        end else if (state == DONE) begin
            if (special_nan_r)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
            else if (special_nan_out_r)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from inf*zero
            else if (special_inf_r)
                z <= {sign_r, 8'hFF, 23'd0};     // infinity
            else if (special_zero_r)
                z <= {sign_r, 31'd0};             // zero
            else if (exp_rounded_r[9] || exp_rounded_r[8]) // Exponent overflow (10 bits, overflow if MSB set)
                z <= {sign_r, 8'hFF, 23'd0};     // overflow to infinity
            else if ($signed(exp_rounded_r) <= 0)
                z <= {sign_r, 31'd0};             // underflow to zero (no subnormals)
            else
                z <= {sign_r, exp_rounded_r[7:0], mant_rounded_final_r[22:0]}; // normalized result
        end
    end

endmodule