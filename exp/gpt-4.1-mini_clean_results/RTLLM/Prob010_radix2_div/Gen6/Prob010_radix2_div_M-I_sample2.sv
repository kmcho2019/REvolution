module radix2_div(
    input             clk,
    input             rst,
    input             sign,           // 1: signed div, 0: unsigned div
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result           // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;

    // Registers for sign and absolute values of inputs
    reg        dividend_neg, divisor_neg;
    reg        quotient_neg, remainder_neg;
    reg [7:0]  dividend_abs, divisor_abs;

    // 9-bit remainder register (one extra bit for shifting)
    reg [8:0] remainder;

    // 8-bit quotient register
    reg [7:0] quotient;

    // 4-bit counter for division iterations (0 to 8)
    reg [3:0] count;

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: next_state = (opn_valid) ? CALC : IDLE;
            CALC: next_state = (count == 4'd8) ? DONE : CALC;
            DONE: next_state = (opn_valid) ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential block: state, registers, division logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            remainder     <= 9'd0;
            quotient      <= 8'd0;
            count         <= 4'd0;
            result        <= 16'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    quotient <= 8'd0;

                    // Latch inputs and compute absolute values and signs once opn_valid asserted
                    if (opn_valid) begin
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            // abs conversion: if negative then two's complement, else as is
                            dividend_abs <= dividend[7] ? (~dividend + 1'b1) : dividend;
                            divisor_abs  <= divisor[7]  ? (~divisor + 1'b1)  : divisor;
                            // quotient sign = dividend sign XOR divisor sign
                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                            quotient_neg <= 1'b0;
                            remainder_neg <= 1'b0;
                        end
                        // Initialize remainder with dividend_abs shifted left by 1 (9 bits)
                        remainder <= {1'b0, dividend_abs};
                    end
                end
                CALC: begin
                    // Shift remainder left by 1 bit to make room for quotient bit
                    // remainder is 9 bits: upper 8 bits hold remainder, LSB will be updated with quotient bit
                    // We'll try to subtract divisor_abs from upper 8 bits of shifted remainder

                    // Shift left remainder by 1 bit
                    // remainder_shifted = remainder << 1 with 9-bit width
                    reg [8:0] remainder_shifted;
                    reg [8:0] sub_result;
                    reg carry;

                    remainder_shifted = {remainder[7:0], 1'b0}; // left shift by 1

                    // Attempt subtraction: remainder_shifted[8:1] - divisor_abs
                    // But since remainder_shifted is 9 bits, we consider the upper 8 bits as remainder portion
                    // For subtraction, subtract divisor_abs from bits [8:1] of remainder_shifted

                    // Subtract divisor_abs from bits [8:1] of remainder_shifted
                    // Using unsigned arithmetic: compare first to see if remainder_shifted[8:1] >= divisor_abs
                    if (remainder_shifted[8:1] >= divisor_abs) begin
                        sub_result = {1'b0, remainder_shifted[8:1] - divisor_abs, remainder_shifted[0]};
                        carry = 1'b1; // subtraction successful
                    end else begin
                        sub_result = remainder_shifted;
                        carry = 1'b0; // subtraction failed
                    end

                    // Update remainder: upper 8 bits get sub_result[8:1], LSB gets carry (quotient bit)
                    remainder <= {sub_result[8:1], carry};

                    // Shift in quotient bit
                    quotient <= {quotient[6:0], carry};

                    // Increment count
                    count <= count + 1'b1;
                end
                DONE: begin
                    // Apply sign correction for quotient and remainder
                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    quotient_final = quotient_neg ? (~quotient + 1'b1) : quotient;
                    remainder_final = remainder_neg ? (~remainder[8:1] + 1'b1) : remainder[8:1];

                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;

                    // Hold outputs until next opn_valid triggers new division
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                        count <= 4'd0;
                        quotient <= 8'd0;
                        remainder <= {1'b0, dividend_abs}; // loaded fresh in next cycle IDLE
                    end
                end
                default: ;
            endcase
        end
    end

endmodule