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

    // One-hot encoded states
    localparam IDLE  = 3'b001;
    localparam CALC  = 3'b010;
    localparam DONE  = 3'b100;

    reg [2:0] state, next_state;

    // Registers for signs and absolute values
    reg        dividend_neg, divisor_neg;
    reg        quotient_neg, remainder_neg;
    reg [7:0]  dividend_abs, divisor_abs;

    // Division registers
    reg [8:0]  remainder;      // 9 bits to hold shifted remainder and sign
    reg [7:0]  quotient;
    reg [3:0]  count;

    // Shifted remainder left by 1 bit (combinational)
    wire [8:0] remainder_shifted = {remainder[7:0], 1'b0};

    // Combinational subtraction: remainder_shifted - divisor_abs
    wire signed [9:0] diff = {1'b0, remainder_shifted} - {2'b00, divisor_abs};
    wire subtraction_negative = diff[9];

    // Calculate next remainder and quotient bits
    wire [8:0] remainder_next = subtraction_negative ? remainder_shifted : diff[8:0];
    wire [7:0] quotient_next  = {quotient[6:0], ~subtraction_negative};

    // Input latching and absolute value computation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
        end else if (state == IDLE && opn_valid) begin
            if (sign) begin
                dividend_neg <= dividend[7];
                divisor_neg  <= divisor[7];
                dividend_abs <= dividend[7] ? (~dividend + 1'b1) : dividend;
                divisor_abs  <= divisor[7] ? (~divisor + 1'b1) : divisor;
                quotient_neg <= dividend[7] ^ divisor[7];
                remainder_neg <= dividend[7];
            end else begin
                dividend_neg   <= 1'b0;
                divisor_neg    <= 1'b0;
                dividend_abs   <= dividend;
                divisor_abs    <= divisor;
                quotient_neg   <= 1'b0;
                remainder_neg  <= 1'b0;
            end
        end
    end

    // FSM state register
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
            IDLE:  next_state = (opn_valid) ? CALC : IDLE;
            CALC:  next_state = (count == 4'd8) ? DONE : CALC;
            DONE:  next_state = (opn_valid) ? CALC : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Division operation process and counters
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            remainder <= 9'd0;
            quotient  <= 8'd0;
            count     <= 4'd0;
            res_valid <= 1'b0;
            result    <= 16'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    quotient <= 8'd0;
                    // Load remainder with dividend_abs (zero-extended 9 bits)
                    remainder <= {1'b0, dividend_abs};
                end

                CALC: begin
                    count <= count + 1'b1;
                    remainder <= remainder_next;
                    quotient <= quotient_next;
                    res_valid <= 1'b0;
                end

                DONE: begin
                    // Apply sign correction on quotient and remainder
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_signed = quotient_neg ? (~quotient + 1'b1) : quotient;
                    remainder_signed = remainder_neg ? (~remainder[7:0] + 1'b1) : remainder[7:0];

                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;

                    // Prepare for new operation if opn_valid asserted
                    if (opn_valid) begin
                        count <= 4'd0;
                        quotient <= 8'd0;
                        remainder <= {1'b0, dividend_abs};
                        res_valid <= 1'b0;
                    end
                end

                default: ;
            endcase
        end
    end

endmodule