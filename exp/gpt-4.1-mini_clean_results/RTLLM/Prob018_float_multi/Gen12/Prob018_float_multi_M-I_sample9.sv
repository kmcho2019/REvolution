module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // FSM states: 4-stage pipeline
    typedef enum reg [1:0] {IDLE=2'd0, MUL=2'd1, NORM=2'd2, DONE=2'd3} state_t;
    reg [1:0] state, next_state;

    // Stage 1 registers: inputs latched and special cases detected
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    reg a_zero_r, b_zero_r;
    reg a_inf_r,  b_inf_r;
    reg a_nan_r,  b_nan_r;

    reg [23:0] a_mant_r, b_mant_r; // with implicit bit if normalized

    // Stage 2 registers: multiplication results
    reg [47:0] product_r;      // 24x24 multiply result
    reg [9:0]  exp_sum_r;      // exponent sum with extended bits
    reg        sign_r;         // result sign

    // Special flags latched from stage 1
    reg special_nan_r, special_nan_out_r, special_inf_r, special_zero_r;

    // Stage 3 registers: normalization and rounding outputs
    reg [47:0] norm_product_r;
    reg [9:0]  norm_exp_r;

    reg guard_bit_r, round_bit_r, sticky_bit_r;
    reg [23:0] mantissa_r;

    reg round_increment_r;
    reg [24:0] mant_rounded_r;    // 25 bits to detect carry out after rounding

    reg [23:0] mant_rounded_final_r;
    reg [9:0]  exp_rounded_r;

    // Output stage registers: final sign
    reg sign_out_r;

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

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = MUL;
            MUL:  next_state = NORM;
            NORM: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Stage 1: Input latch and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset registers
            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r  <= 1'b0; b_inf_r  <= 1'b0;
            a_nan_r  <= 1'b0; b_nan_r  <= 1'b0;

            a_mant_r <= 24'd0; b_mant_r <= 24'd0;

            special_nan_r <= 1'b0;
            special_nan_out_r <= 1'b0;
            special_inf_r <= 1'b0;
            special_zero_r <= 1'b0;

            state <= IDLE;
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

                // Mantissa with implicit bit for normalized numbers, else 0 leading for denormals
                a_mant_r <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant_r <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Special cases
                special_nan_r <= a_nan_r || b_nan_r; // will be updated next cycle
                special_nan_out_r <= (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
                special_inf_r <= (a_inf_r || b_inf_r) && !((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r));
                special_zero_r <= (a_zero_r || b_zero_r) && !((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r)) && !special_inf_r;
            end
        end
    end

    // Stage 2: Multiplication and exponent addition
    always @(posedge clk) begin
        if (state == MUL) begin
            // Multiply mantissas 24x24 = 48 bits
            product_r <= a_mant_r * b_mant_r;

            // Sum exponents with bias subtraction, 10-bit width for overflow detection
            exp_sum_r <= a_exp_r + b_exp_r - EXP_BIAS;

            // Sign is XOR of inputs
            sign_r <= a_sign_r ^ b_sign_r;

            // Propagate special flags
            special_nan_r <= special_nan_r || a_nan_r || b_nan_r;
            special_nan_out_r <= (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
            special_inf_r <= (a_inf_r || b_inf_r) && !special_nan_out_r;
            special_zero_r <= (a_zero_r || b_zero_r) && !special_nan_out_r && !special_inf_r;
        end
    end

    // Stage 3: Normalization and rounding
    always @(posedge clk) begin
        if (state == NORM) begin
            // Normalize product:
            // If MSB product_r[47] == 1, shift right by 1 and increment exponent
            if (product_r[47]) begin
                norm_product_r <= product_r >> 1;
                norm_exp_r <= exp_sum_r + 10'd1;
            end else begin
                norm_product_r <= product_r;
                norm_exp_r <= exp_sum_r;
            end

            // Extract mantissa bits [46:23]
            mantissa_r <= norm_product_r[46:23];

            // Extract rounding bits
            guard_bit_r <= norm_product_r[23];
            round_bit_r <= norm_product_r[22];
            sticky_bit_r <= |norm_product_r[21:0];

            // Determine rounding increment per round to nearest even
            round_increment_r <= guard_bit_r && (round_bit_r || sticky_bit_r || mantissa_r[0]);

            // Add rounding increment to mantissa
            mant_rounded_r <= {1'b0, mantissa_r} + round_increment_r;

            sign_out_r <= sign_r;
        end
    end

    // Stage 4: Final rounding adjustment and output assemble
    always @(posedge clk) begin
        if (state == DONE) begin
            // If rounding overflows mantissa, shift right and increment exponent
            if (mant_rounded_r[24]) begin
                mant_rounded_final_r <= mant_rounded_r[24:1];
                exp_rounded_r <= norm_exp_r + 10'd1;
            end else begin
                mant_rounded_final_r <= mant_rounded_r[23:0];
                exp_rounded_r <= norm_exp_r;
            end
        end
    end

    // Output logic combinational (after DONE stage registers update)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else if (state == DONE) begin
            // Handle special cases first
            if (special_nan_r) begin
                // Quiet NaN: sign=0, exp=255, frac MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_r) begin
                // NaN from Inf*0 or 0*Inf
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_r) begin
                // Infinity result with correct sign
                z <= {sign_out_r, 8'hFF, 23'd0};
            end else if (special_zero_r) begin
                // Zero with correct sign
                z <= {sign_out_r, 31'd0};
            end else if (exp_rounded_r[9:8] != 2'b00) begin
                // Overflow -> Infinity
                z <= {sign_out_r, 8'hFF, 23'd0};
            end else if (exp_rounded_r[9:0] == 0) begin
                // Underflow -> zero (no subnormal handling)
                z <= {sign_out_r, 31'd0};
            end else begin
                // Normal output: sign, exponent, mantissa (truncate implicit 1)
                z <= {sign_out_r, exp_rounded_r[7:0], mant_rounded_final_r[22:0]};
            end
        end
    end

endmodule