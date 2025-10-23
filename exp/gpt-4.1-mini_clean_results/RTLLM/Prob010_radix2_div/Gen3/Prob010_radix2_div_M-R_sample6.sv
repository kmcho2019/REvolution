module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUN     = 2'b01,
        DONE    = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       quotient_sign, remainder_sign;

    reg [8:0] remainder;       // 9-bit remainder register: upper bit for possible borrow
    reg [7:0] quotient;

    reg [3:0] count;           // count from 0 to 8 steps (0-7 for division steps)

    // Compute absolute values and signs
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs  = (sign && divisor[7])  ? (~divisor + 1)  : divisor;

    // FSM sequential
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'b0;

            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;

            remainder <= 9'b0;
            quotient <= 8'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch inputs and initialize registers
                        dividend_reg <= dividend_abs;
                        divisor_reg <= divisor_abs;
                        dividend_neg <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg <= (sign) ? divisor[7] : 1'b0;
                        quotient_sign <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign <= (sign) ? dividend[7] : 1'b0;

                        remainder <= {1'b0, dividend_abs}; // 9-bit remainder with 0 msb
                        quotient <= 8'b0;
                        count <= 4'd0;
                    end
                end

                RUN: begin
                    // Shift left remainder and quotient, perform subtraction step
                    // 1) Shift left remainder by 1 (concatenate remainder and quotient MSB)
                    // Remainder is 9 bits; quotient is 8 bits
                    // Here, remainder[8:0], quotient[7:0]

                    // Shift remainder left by 1, bring in quotient MSB as bit0 (we use quotient LSB separately)
                    // But the radix-2 algorithm usually shifts remainder left by 1, shifts quotient left by 1,
                    // and inserts the subtraction result bit in quotient LSB.

                    // For clarity:
                    // Step 1: shift remainder left by 1
                    // Step 2: subtract divisor_reg if possible
                    // Step 3: update quotient LSB based on subtraction

                    reg [8:0] shifted_remainder;
                    reg [8:0] sub_res;

                    shifted_remainder = {remainder[7:0], quotient[7]}; // Shift left remainder and bring in quotient MSB
                    // Actually, according to classical radix-2, the quotient is shifted left by 1 each iteration,
                    // remainder shifted left by 1, and subtract divisor.

                    // Here the standard is:
                    // remainder = (remainder << 1) | quotient[7]
                    // quotient = (quotient << 1)

                    // Actually, it's simpler to shift remainder left by 1, shift quotient left by 1,
                    // then do the subtraction test, update remainder and set quotient LSB accordingly.

                    // We implement as:

                    // 1) Shift remainder left by 1, insert next dividend bit (handled at input stage)
                    // Since dividend is already loaded in remainder, shift remainder left by 1:
                    shifted_remainder = {remainder[7:0], quotient[7]};

                    // 2) Subtract divisor_reg
                    sub_res = shifted_remainder - {1'b0, divisor_reg};

                    if (~sub_res[8]) begin
                        // subtraction >= 0
                        remainder <= sub_res;
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // subtraction < 0
                        remainder <= shifted_remainder;
                        quotient <= {quotient[6:0], 1'b0};
                    end

                    count <= count + 1'b1;
                end

                DONE: begin
                    // Output result with sign corrections
                    res_valid <= 1'b1;

                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Apply sign correction to quotient
                    if (quotient_sign)
                        final_quotient = ~quotient + 1;
                    else
                        final_quotient = quotient;

                    // Apply sign correction to remainder
                    if (remainder_sign)
                        final_remainder = ~remainder[7:0] + 1;
                    else
                        final_remainder = remainder[7:0];

                    result <= {final_remainder, final_quotient};
                end

                default: begin
                    // Safety default to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end

    // FSM combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
            end
            RUN: begin
                if (count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule