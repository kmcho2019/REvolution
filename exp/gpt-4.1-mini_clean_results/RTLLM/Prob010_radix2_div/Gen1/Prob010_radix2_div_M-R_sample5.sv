module radix2_div(
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
    reg [8:0] SR;              // Shift register: remainder + quotient bits (9 bits)
    reg [8:0] NEG_DIVISOR;     // 9-bit negated divisor for subtraction
    reg [7:0] dividend_abs;    // absolute dividend
    reg [7:0] divisor_abs;     // absolute divisor

    reg [3:0] cnt;             // counts division cycles from 0 to 8

    // Signs
    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    // Subtraction result with carry out
    reg [9:0] sub_result;

    // State register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: 
                if (opn_valid)
                    next_state = CALC;
                else
                    next_state = IDLE;
            CALC: 
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = CALC;
            DONE: 
                if (opn_valid)
                    next_state = CALC;
                else
                    next_state = DONE;
            default:
                next_state = IDLE;
        endcase
    end

    // Data path and control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 9'd0;
            NEG_DIVISOR <= 9'd0;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            cnt         <= 4'd0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;

                    if (opn_valid) begin
                        // Calculate sign flags and absolute values
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];

                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs  <= divisor[7]  ? (~divisor + 8'd1)  : divisor;

                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;

                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end
                        // Initialize shift register with dividend_abs shifted left by 1
                        SR <= {dividend_abs, 1'b0};
                        // NEG_DIVISOR is two's complement of divisor_abs extended to 9 bits
                        NEG_DIVISOR <= (~{1'b0, divisor_abs} + 9'd1);
                        cnt <= 4'd0;
                    end
                end

                CALC: begin
                    // Perform subtraction: SR[8:0] + NEG_DIVISOR
                    sub_result = {1'b0, SR} + {1'b0, NEG_DIVISOR};

                    if (sub_result[9]) begin
                        // No borrow, subtraction successful, quotient bit=1
                        // Update SR: lower 8 bits = sub_result[8:1], shift left 1, insert 1 LSB
                        SR <= {sub_result[8:0], 1'b1};
                    end else begin
                        // Borrow, restore SR shifted left 1, quotient bit=0
                        SR <= {SR[7:0], 1'b0};
                    end

                    cnt <= cnt + 4'd1;
                end

                DONE: begin
                    res_valid <= 1'b1;

                    // Apply sign correction for quotient and remainder once
                    // Only do it once after the last cycle of CALC
                    // SR after CALC done:
                    // Remainder = SR[8:1]
                    // Quotient = SR[7:0]

                    // Sign correct quotient
                    if (sign && sign_quotient)
                        result[7:0] <= (~SR[7:0] + 8'd1);
                    else
                        result[7:0] <= SR[7:0];

                    // Sign correct remainder
                    if (sign && sign_remainder)
                        result[15:8] <= (~SR[8:1] + 8'd1);
                    else
                        result[15:8] <= SR[8:1];
                end
            endcase

            // Clear res_valid if next operation starts in DONE state
            if (state == DONE && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule