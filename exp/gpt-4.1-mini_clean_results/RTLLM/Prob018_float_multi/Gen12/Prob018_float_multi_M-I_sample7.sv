module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // States for 4-stage FSM: IDLE, CALC1, CALC2, DONE
    typedef enum reg [1:0] {IDLE=2'd0, CALC1=2'd1, CALC2=2'd2, DONE=2'd3} state_t;
    reg [1:0] state, next_state;

    // Latched input fields at IDLE
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Special flags latched at IDLE
    reg a_zero_r, b_zero_r;
    reg a_inf_r,  b_inf_r;
    reg a_nan_r,  b_nan_r;

    // Mantissas with implicit bit (24-bit) latched at IDLE
    reg [23:0] a_mant_r, b_mant_r;

    // Pipeline registers between CALC1 and CALC2
    reg sign_p2;
    reg [9:0] exp_sum_p2;
    reg [47:0] product_p2;

    // Special flags pipelined to CALC2 and DONE
    reg special_nan_p2, special_nan_out_p2, special_inf_p2, special_zero_p2;

    // Normalization and rounding outputs at CALC2 stage
    reg [9:0] exp_norm_p2;
    reg [47:0] product_norm_p2;

    // Rounded mantissa and exponent outputs to DONE
    reg [23:0] mantissa_rounded_p3;
    reg [9:0] exp_rounded_p3;
    reg sign_p3;

    // Special flags to DONE
    reg special_nan_p3, special_nan_out_p3, special_inf_p3, special_zero_p3;

    // Helper functions for special case detection
    function automatic is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function automatic is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function automatic is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // FSM sequential logic and register updates
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

            // Pipeline regs
            sign_p2 <= 1'b0;
            exp_sum_p2 <= 10'd0;
            product_p2 <= 48'd0;
            special_nan_p2 <= 1'b0; special_nan_out_p2 <= 1'b0; special_inf_p2 <= 1'b0; special_zero_p2 <= 1'b0;

            exp_norm_p2 <= 10'd0;
            product_norm_p2 <= 48'd0;

            mantissa_rounded_p3 <= 24'd0;
            exp_rounded_p3 <= 10'd0;
            sign_p3 <= 1'b0;

            special_nan_p3 <= 1'b0; special_nan_out_p3 <= 1'b0; special_inf_p3 <= 1'b0; special_zero_p3 <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Latch inputs and compute special cases
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

                    a_mant_r <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant_r <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                CALC1: begin
                    // Pipeline registers to CALC2 stage
                    sign_p2 <= a_sign_r ^ b_sign_r;
                    exp_sum_p2 <= a_exp_r + b_exp_r - EXP_BIAS;
                    product_p2 <= a_mant_r * b_mant_r;

                    special_nan_p2 <= a_nan_r || b_nan_r;
                    special_nan_out_p2 <= (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
                    special_inf_p2 <= (a_inf_r || b_inf_r) && !special_nan_out_p2;
                    special_zero_p2 <= (a_zero_r || b_zero_r) && !special_nan_out_p2 && !special_inf_p2;
                end

                CALC2: begin
                    // Normalization: shift product if MSB set and adjust exponent
                    if (product_p2[47]) begin
                        exp_norm_p2 <= exp_sum_p2 + 10'd1;
                        product_norm_p2 <= product_p2 >> 1;
                    end else begin
                        exp_norm_p2 <= exp_sum_p2;
                        product_norm_p2 <= product_p2;
                    end

                    // Pass special flags and sign
                    special_nan_p3 <= special_nan_p2;
                    special_nan_out_p3 <= special_nan_out_p2;
                    special_inf_p3 <= special_inf_p2;
                    special_zero_p3 <= special_zero_p2;
                    sign_p3 <= sign_p2;
                end

                DONE: begin
                    // Nothing to latch here except output handled combinationally below
                end

                default: ;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = CALC1;
            CALC1: next_state = CALC2;
            CALC2: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational rounding and final output mantissa/exponent calculation at DONE state
    // Use outputs from CALC2 pipeline registers
    reg guard_bit_c, round_bit_c, sticky_bit_c;
    reg round_increment_c;
    reg [24:0] mant_rounded_c;

    always @(*) begin
        // Default outputs
        mantissa_rounded_p3 = 24'd0;
        exp_rounded_p3 = 10'd0;

        // Extract mantissa bits [46:23] (24 bits including implicit 1)
        reg [23:0] mantissa_c;
        mantissa_c = product_norm_p2[46:23];

        // Extract rounding bits
        guard_bit_c = product_norm_p2[23];
        round_bit_c = product_norm_p2[22];
        sticky_bit_c = |product_norm_p2[21:0];

        // Round to nearest even logic
        round_increment_c = guard_bit_c && (round_bit_c || sticky_bit_c || mantissa_c[0]);

        // Add rounding increment
        mant_rounded_c = {1'b0, mantissa_c} + round_increment_c;

        // Check if mantissa overflowed (bit 24 set)
        if (mant_rounded_c[24]) begin
            mantissa_rounded_p3 = mant_rounded_c[24:1];
            exp_rounded_p3 = exp_norm_p2 + 10'd1;
        end else begin
            mantissa_rounded_p3 = mant_rounded_c[23:0];
            exp_rounded_p3 = exp_norm_p2;
        end
    end

    // Output assembly at DONE state (sequential)
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
        end else if (state == DONE) begin
            if (special_nan_p3)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN canonical
            else if (special_nan_out_p3)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from Inf*0
            else if (special_inf_p3)
                z <= {sign_p3, 8'hFF, 23'd0};     // Infinity
            else if (special_zero_p3)
                z <= {sign_p3, 31'd0};            // Zero
            else if (exp_rounded_p3[9:8] != 2'b00)
                z <= {sign_p3, 8'hFF, 23'd0};     // Overflow to Inf
            else if (exp_rounded_p3[7:0] == 8'd0)
                z <= {sign_p3, 31'd0};            // Underflow to zero (no subnormals)
            else
                z <= {sign_p3, exp_rounded_p3[7:0], mantissa_rounded_p3[22:0]}; // Normal result
        end
    end

endmodule