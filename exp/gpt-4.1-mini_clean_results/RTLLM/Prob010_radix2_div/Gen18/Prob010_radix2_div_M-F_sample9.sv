module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned division
    input       [7:0]   dividend,       // Dividend input
    input       [7:0]   divisor,        // Divisor input
    input               opn_valid,      // Operation start signal (valid inputs)
    output reg          res_valid,      // Result valid output (indicates result ready)
    output reg  [15:0]  result          // Result: {remainder[7:0], quotient[7:0]}
);

    // State encoding for FSM
    localparam IDLE   = 1'b0;
    localparam DIVIDE = 1'b1;

    reg state, next_state;

    reg [3:0] cnt;              // Iteration counter: counts 0..8 cycles for division
    reg [16:0] SR;              // Shift register holding remainder and quotient:
                               // SR[16:8] remainder (9 bits), SR[7:0] quotient (8 bits)
    reg [8:0] divisor_abs;      // Absolute value of divisor (9 bits for sign extension)
    reg [7:0] dividend_abs;     // Absolute value of dividend (8 bits)
    reg dividend_neg, divisor_neg;    // Signs of inputs for signed division
    reg quotient_neg, remainder_neg;  // Signs for output correction
    reg op_start;               // Indicates operation started

    wire divisor_zero = (divisor_abs == 9'd0);

    // Compute absolute values of dividend and divisor based on sign input
    wire [7:0] divd_abs_w = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [8:0] divs_abs_w = (sign && divisor[7]) ? {1'b0, (~divisor + 8'd1)} : {1'b0, divisor};

    // Subtraction: remainder part of SR minus divisor_abs
    wire signed [9:0] rem_part = {1'b0, SR[16:8]};
    wire signed [9:0] sub_res = rem_part - {1'b0, divisor_abs};

    reg [16:0] SR_next;
    reg [3:0] cnt_next;
    reg res_valid_next;

    // Next state and next values logic
    always @(*) begin
        next_state = state;
        SR_next = SR;
        cnt_next = cnt;
        res_valid_next = res_valid;

        case(state)
            IDLE: begin
                res_valid_next = 1'b0;
                if (opn_valid && !res_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (divisor_zero) begin
                    // Divisor zero case: quotient = 0, remainder = dividend
                    // Immediately complete division
                    SR_next = {dividend_abs, 1'b0, 8'd0}; // remainder with extra bit + quotient
                    cnt_next = 4'd8;
                    res_valid_next = 1'b1;
                    next_state = IDLE;
                end else if (cnt == 4'd8) begin
                    // Division complete
                    res_valid_next = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Iterative division steps
                    // Shift left SR by 1
                    SR_next = {SR[15:0], 1'b0};
                    cnt_next = cnt + 1'b1;

                    if (sub_res >= 0) begin
                        // Subtraction successful: update remainder and set quotient bit
                        SR_next[16:8] = sub_res[8:0];
                        SR_next[0] = 1'b1;
                    end
                    res_valid_next = 1'b0;
                    next_state = DIVIDE;
                end
            end
        endcase
    end

    // Sequential logic: FSM and registers update on clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            cnt <= 4'd0;
            SR <= 17'd0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            op_start <= 1'b0;
        end else begin
            state <= next_state;
            res_valid <= res_valid_next;

            case(state)
                IDLE: begin
                    if (opn_valid && !res_valid && !op_start) begin
                        // Latch inputs and compute absolute values and signs
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg <= (sign && divisor[7]);
                        dividend_abs <= divd_abs_w;
                        divisor_abs <= divs_abs_w;
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Initialize shift register: remainder = dividend_abs shifted left by 1, quotient = 0
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;
                        op_start <= 1'b1;
                    end else if (!opn_valid) begin
                        op_start <= 1'b0;
                    end
                end

                DIVIDE: begin
                    SR <= SR_next;
                    cnt <= cnt_next;
                    // res_valid set in next_state logic
                end
            endcase

            // Clear res_valid if new operation starts before consumption
            if (res_valid && opn_valid)
                res_valid <= 1'b0;

            // Update result output on res_valid asserted
            if (res_valid) begin
                // Extract raw quotient and remainder
                // SR[7:0] quotient, SR[16:9] remainder (8 bits)
                // Correct signs if signed division requested
                reg [7:0] quotient_raw;
                reg [7:0] remainder_raw;
                reg [7:0] quotient_out;
                reg [7:0] remainder_out;

                quotient_raw = SR[7:0];
                remainder_raw = SR[16:9];

                quotient_out = quotient_neg ? (~quotient_raw + 8'd1) : quotient_raw;
                remainder_out = remainder_neg ? (~remainder_raw + 8'd1) : remainder_raw;

                result <= {remainder_out, quotient_out};
            end
        end
    end

endmodule