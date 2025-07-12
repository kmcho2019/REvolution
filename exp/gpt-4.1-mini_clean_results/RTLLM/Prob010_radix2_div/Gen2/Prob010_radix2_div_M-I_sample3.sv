module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // Internal registers
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg dividend_neg;
    reg divisor_neg;

    reg sign_quotient;
    reg sign_remainder;

    reg [7:0] quotient;
    reg [8:0] remainder;  // 9 bits to hold shifted remainder with an extra bit for subtraction

    reg [3:0] cnt; // 0 to 8 cycles

    reg [8:0] sub_result; // remainder - divisor_abs shifted

    // FSM state register
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (opn_valid) ? CALC : IDLE;
            CALC:  next_state = (cnt == 4'd8) ? DONE : CALC;
            DONE:  next_state = (opn_valid) ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main data path and control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            quotient <= 8'd0;
            remainder <= 9'd0;
            cnt <= 4'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    quotient <= 8'd0;
                    remainder <= 9'd0;

                    if (opn_valid) begin
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs <= divisor[7] ? (~divisor + 8'd1) : divisor;
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end
                        // Initialize remainder: dividend_abs shifted left by 1 to make room for next bit
                        remainder <= {1'b0, dividend_abs};
                        quotient <= 8'd0;
                        cnt <= 4'd0;
                    end
                end

                CALC: begin
                    // Shift left remainder by 1 bit, bringing in MSB of quotient as zero initially
                    remainder <= {remainder[7:0], 1'b0};

                    // Trial subtraction: remainder - divisor_abs
                    sub_result = remainder - {1'b0, divisor_abs};

                    if (!sub_result[8]) begin
                        // If subtraction result is positive (no borrow)
                        remainder <= sub_result;
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // If subtraction result is negative (borrow), quotient bit = 0
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                end

                DONE: begin
                    res_valid <= 1'b1;

                    // Sign correction once after division complete
                    // remainder currently contains the remainder (positive)
                    // quotient is also positive

                    // Correct quotient sign
                    if (sign && sign_quotient)
                        result[7:0] <= (~quotient + 8'd1);
                    else
                        result[7:0] <= quotient;

                    // Correct remainder sign
                    if (sign && sign_remainder)
                        result[15:8] <= (~remainder[7:0] + 8'd1);
                    else
                        result[15:8] <= remainder[7:0];
                end
            endcase

            // Clear res_valid when new operation starts
            if (state == DONE && opn_valid)
                res_valid <= 1'b0;
        end
    end

endmodule