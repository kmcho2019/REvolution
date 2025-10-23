module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // State machine states
    typedef enum reg [1:0] {IDLE=2'd0, CALC=2'd1, DONE=2'd2} state_t;
    reg [1:0] state, next_state;

    // Stage 1 registers: input extraction and special flags
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    reg a_zero_r, b_zero_r;
    reg a_inf_r, b_inf_r;
    reg a_nan_r, b_nan_r;

    reg [23:0] a_mant_r, b_mant_r; // mantissa with implicit bit

    // Stage 2 registers: multiplication results
    reg [47:0] product_r;
    reg [9:0] exp_sum_r;
    reg sign_r;

    // Stage 3 combinational signals
    reg special_nan_c, special_nan_out_c, special_inf_c, special_zero_c;

    reg [47:0] norm_product_c;
    reg [9:0] norm_exp_c;
    reg guard_bit_c, round_bit_c, sticky_bit_c;
    reg [23:0] mantissa_c;

    reg round_inc_c;
    reg [24:0] mantissa_rounded_c;
    reg [23:0] mantissa_rounded_final_c;
    reg [9:0] exp_rounded_c;

    // Helpers: special case detection functions
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Sequential: FSM and registers for pipelining
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear stage 1 regs
            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0; b_inf_r <= 1'b0;
            a_nan_r <= 1'b0; b_nan_r <= 1'b0;

            a_mant_r <= 24'd0; b_mant_r <= 24'd0;

            // Clear stage 2 regs
            product_r <= 48'd0;
            exp_sum_r <= 10'd0;
            sign_r <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Latch inputs and special flags
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

                    // Prepare mantissas with implicit leading bit if normalized
                    a_mant_r <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant_r <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                CALC: begin
                    // Multiply mantissas
                    product_r <= a_mant_r * b_mant_r;

                    // Exponent sum minus bias with wider bits for overflow detection
                    exp_sum_r <= {2'b00, a_exp_r} + {2'b00, b_exp_r} - EXP_BIAS;

                    // Sign is XOR of input signs
                    sign_r <= a_sign_r ^ b_sign_r;
                end

                DONE: begin
                    // Compose output 'z' - done in combinational block below
                    // Just register output here to synchronize
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = CALC;
            CALC:  next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for normalization, rounding, and special case detection at DONE stage
    always @(*) begin
        // Default clear special signals
        special_nan_c      = 1'b0;
        special_nan_out_c  = 1'b0;
        special_inf_c      = 1'b0;
        special_zero_c     = 1'b0;

        // Detect special cases (on registered inputs)
        special_nan_c = a_nan_r || b_nan_r;
        // Inf*0 produces NaN
        special_nan_out_c = (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
        // Infinity if inputs include Inf but no NaN or Inf*0->NaN
        special_inf_c = (a_inf_r || b_inf_r) && !special_nan_out_c && !special_nan_c;
        // Zero if any input zero and no special_nan or inf case
        special_zero_c = (a_zero_r || b_zero_r) && !special_nan_out_c && !special_nan_c && !special_inf_c;

        // Normalization: Check MSB of product (bit 47)
        if (product_r[47]) begin
            // Product already normalized, shift right by 1 (to get 24-bit mantissa)
            norm_product_c = product_r >> 1;
            norm_exp_c = exp_sum_r + 10'd1;
        end else begin
            norm_product_c = product_r;
            norm_exp_c = exp_sum_r;
        end

        // Extract mantissa: bits 46 down to 23 (24 bits: implicit leading one included)
        mantissa_c = norm_product_c[46:23];

        // Extract rounding bits for round to nearest even
        guard_bit_c = norm_product_c[23];
        round_bit_c = norm_product_c[22];
        sticky_bit_c = |norm_product_c[21:0];

        // Round increment condition:
        // Round up if guard=1 and (round=1 or sticky=1 or LSB mantissa=1)
        round_inc_c = guard_bit_c && (round_bit_c || sticky_bit_c || mantissa_c[0]);

        // Add rounding increment
        mantissa_rounded_c = {1'b0, mantissa_c} + round_inc_c;

        // If rounding causes mantissa overflow, shift right by 1 and increment exponent
        if (mantissa_rounded_c[24]) begin
            mantissa_rounded_final_c = mantissa_rounded_c[24:1];
            exp_rounded_c = norm_exp_c + 10'd1;
        end else begin
            mantissa_rounded_final_c = mantissa_rounded_c[23:0];
            exp_rounded_c = norm_exp_c;
        end
    end

    // Final output register update at DONE stage
    always @(posedge clk) begin
        if (state == DONE) begin
            if (special_nan_c)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet canonical NaN
            else if (special_nan_out_c)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from Inf*0
            else if (special_inf_c)
                z <= {sign_r, 8'hFF, 23'd0};     // Infinity with correct sign
            else if (special_zero_c)
                z <= {sign_r, 31'd0};             // Zero with correct sign
            else if (exp_rounded_c[9:8] != 2'b00)
                z <= {sign_r, 8'hFF, 23'd0};     // Exponent overflow -> Infinity
            else if (exp_rounded_c[9:0] == 0)
                z <= {sign_r, 31'd0};             // Underflow -> Zero (no subnormals)
            else
                z <= {sign_r, exp_rounded_c[7:0], mantissa_rounded_final_c[22:0]}; // Normalized result
        end
    end

endmodule