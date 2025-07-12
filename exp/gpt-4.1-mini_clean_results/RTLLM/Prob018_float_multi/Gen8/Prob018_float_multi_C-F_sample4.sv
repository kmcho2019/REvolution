module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // States for simple 3-stage pipeline FSM
    typedef enum reg [1:0] {IDLE=2'd0, CALC=2'd1, DONE=2'd2} state_t;
    reg [1:0] state, next_state;

    // Registered input fields
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Special flags latched
    reg a_zero_r, b_zero_r;
    reg a_inf_r,  b_inf_r;
    reg a_nan_r,  b_nan_r;

    // Mantissas with implicit bit (24-bit)
    reg [23:0] a_mant_r, b_mant_r;

    // Combinational outputs at CALC stage
    reg [47:0] product_c;
    reg [9:0]  exp_sum_c; // extended to 10 bits for overflow detection
    reg        sign_c;

    // Special cases combinational
    reg special_nan_c, special_nan_out_c, special_inf_c, special_zero_c;

    // Normalization and rounding signals (combinational)
    reg [47:0] norm_product_c;
    reg [9:0] norm_exp_c;
    reg guard_bit_c, round_bit_c, sticky_bit_c;
    reg [23:0] mantissa_c;

    reg round_increment_c;
    reg [24:0] mant_rounded_c;
    reg [23:0] mant_rounded_final_c;
    reg [9:0]  exp_rounded_c;

    // Helper functions for special case detection
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // State Machine and Registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0; b_inf_r <= 1'b0;
            a_nan_r <= 1'b0; b_nan_r <= 1'b0;

            a_mant_r <= 24'd0; b_mant_r <= 24'd0;
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

                // Prepare mantissas with implicit 1 for normalized, else 0 leading for denormals
                a_mant_r <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant_r <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            end

            if (state == DONE) begin
                // Output assembly based on special cases and rounded result
                if (special_nan_c)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN canonical
                else if (special_nan_out_c)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from Inf*0
                else if (special_inf_c)
                    z <= {sign_c, 8'hFF, 23'd0};     // Infinity
                else if (special_zero_c)
                    z <= {sign_c, 31'd0};             // Zero
                else if (exp_rounded_c[9:8] != 2'b00)
                    z <= {sign_c, 8'hFF, 23'd0};     // Overflow to Inf
                else if (exp_rounded_c[9:0] == 0)
                    z <= {sign_c, 31'd0};             // Underflow to zero (no subnormals)
                else
                    z <= {sign_c, exp_rounded_c[7:0], mant_rounded_final_c[22:0]}; // Normal result
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

    // Combinational logic for multiplication, normalization, rounding
    always @(*) begin
        // Multiply mantissas 24x24 = 48 bits
        product_c = a_mant_r * b_mant_r;

        // Sum exponents with bias subtraction, extend width to 10 bits for overflow detection
        exp_sum_c = a_exp_r + b_exp_r - EXP_BIAS;

        // Result sign is XOR of input signs
        sign_c = a_sign_r ^ b_sign_r;

        // Detect special cases for output
        special_nan_c = a_nan_r || b_nan_r;
        special_nan_out_c = (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
        special_inf_c = (a_inf_r || b_inf_r) && !special_nan_out_c;
        special_zero_c = (a_zero_r || b_zero_r) && !special_nan_out_c && !special_inf_c;

        // Normalization:
        // If product MSB (bit 47) == 1, shift right 1 and increase exponent by 1
        if (product_c[47]) begin
            norm_product_c = product_c >> 1;
            norm_exp_c = exp_sum_c + 10'd1;
        end else begin
            norm_product_c = product_c;
            norm_exp_c = exp_sum_c;
        end

        // Extract mantissa bits [46:23] = 24 bits (leading 1 implicit)
        mantissa_c = norm_product_c[46:23];

        // Extract rounding bits for round to nearest even
        guard_bit_c = norm_product_c[23];
        round_bit_c = norm_product_c[22];
        sticky_bit_c = |norm_product_c[21:0];

        // Determine if rounding increment needed (guard=1 and (round=1 or sticky=1 or LSB of mantissa=1))
        round_increment_c = guard_bit_c && (round_bit_c || sticky_bit_c || mantissa_c[0]);

        // Add rounding increment to mantissa
        mant_rounded_c = {1'b0, mantissa_c} + round_increment_c;

        // If rounding caused mantissa overflow (bit 24 set), shift right and increase exponent
        if (mant_rounded_c[24]) begin
            mant_rounded_final_c = mant_rounded_c[24:1];
            exp_rounded_c = norm_exp_c + 10'd1;
        end else begin
            mant_rounded_final_c = mant_rounded_c[23:0];
            exp_rounded_c = norm_exp_c;
        end
    end

endmodule