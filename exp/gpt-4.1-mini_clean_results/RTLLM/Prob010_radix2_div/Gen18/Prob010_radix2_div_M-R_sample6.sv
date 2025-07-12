module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result          // [15:8] remainder, [7:0] quotient
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;
    reg [1:0] state, next_state;

    // Registers to hold signed info
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    // Absolute values of inputs
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Division registers
    reg [8:0] remainder;   // 9-bit remainder (to hold shifted dividend bits + carry)
    reg [7:0] quotient;    // 8-bit quotient
    reg [3:0] bit_cnt;     // iteration counter (0 to 8)

    wire divisor_is_zero = (divisor_abs == 8'd0);

    // Combinational subtraction: remainder - divisor_abs
    wire signed [9:0] rem_minus_div = {1'b0, remainder} - {1'b0, divisor_abs};

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(opn_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if(bit_cnt == 4'd8 || divisor_is_zero)
                    next_state = DONE;
            end
            DONE: begin
                if(!opn_valid)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for FSM and division process
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            bit_cnt <= 4'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    bit_cnt <= 4'd0;
                    quotient <= 8'd0;
                    remainder <= 9'd0;

                    if(opn_valid) begin
                        // Determine signed flags
                        dividend_neg <= sign && dividend[7];
                        divisor_neg <= sign && divisor[7];
                        // Absolute values
                        dividend_abs <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                        divisor_abs <= (sign && divisor[7]) ? (~divisor + 1) : divisor;
                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize remainder with dividend_abs shifted left by 1 for division (9 bits)
                        remainder <= {1'b0, (sign && dividend[7]) ? (~dividend + 1) : dividend};
                        quotient <= 8'd0;
                    end
                end

                DIVIDE: begin
                    if(divisor_is_zero) begin
                        // Division by zero: quotient = 0, remainder = dividend_abs
                        quotient <= 8'd0;
                        remainder <= {1'b0, dividend_abs};
                        bit_cnt <= 4'd8; // force end
                    end else begin
                        // Shift remainder left by 1, bring in next quotient bit
                        remainder <= {remainder[7:0], quotient[7]};
                        quotient <= {quotient[6:0], 1'b0};

                        // Subtract divisor_abs from remainder
                        if(rem_minus_div >= 0) begin
                            remainder <= rem_minus_div[8:0];
                            quotient[0] <= 1'b1;
                        end

                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end

                DONE: begin
                    if(bit_cnt == 4'd8) begin
                        // Correct signs on quotient and remainder if signed division
                        if(quotient_neg)
                            quotient <= (~quotient + 1);
                        if(remainder_neg)
                            remainder <= (~remainder + 1);
                        res_valid <= 1'b1;

                        // Form result: remainder[7:0], quotient[7:0]
                        result <= {remainder[7:0], quotient};
                    end
                    // Wait for opn_valid low to return to IDLE
                    if(!opn_valid)
                        res_valid <= 1'b0;
                end

                default: ; // Should never happen
            endcase
        end
    end

endmodule