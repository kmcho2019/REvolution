module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // State encoding (one-hot)
    localparam IDLE   = 3'b001;
    localparam DIVIDE = 3'b010;
    localparam DONE   = 3'b100;

    reg [2:0] state, next_state;

    // Registers to hold operands and flags
    reg dividend_neg, divisor_neg;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Counters
    reg [3:0] count;

    // Partial remainder and quotient registers
    // Partial remainder width 9 bits for sign-extension and shift space
    reg [8:0] remainder;
    reg [7:0] quotient;

    // Signals for subtraction and comparison
    wire [8:0] remainder_shifted;
    wire [8:0] sub_result;
    wire       sub_result_non_neg;

    // Shift remainder left by 1 and bring in next quotient bit later
    assign remainder_shifted = {remainder[7:0], 1'b0};

    // Subtract divisor_abs from shifted remainder
    assign sub_result = remainder_shifted - {1'b0, divisor_abs};

    // Check if subtraction result is non-negative (MSB=0 means >=0)
    assign sub_result_non_neg = ~sub_result[8];

    // Next quotient bit to append (1 if subtraction non-negative else 0)
    wire next_quot_bit = sub_result_non_neg;

    // Next remainder value depending on subtraction result
    wire [8:0] next_remainder = sub_result_non_neg ? sub_result : remainder_shifted;

    // Sign corrected outputs after division done
    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (res_valid && !opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // FSM and datapath sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            count <= 0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            quotient_signed <= 8'd0;
            remainder_signed <= 8'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 0;
                    quotient <= 8'd0;

                    if (opn_valid) begin
                        // Determine sign flags and absolute values
                        dividend_neg <= sign & dividend[7];
                        divisor_neg <= sign & divisor[7];

                        dividend_abs <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                        divisor_abs <= (sign && divisor[7]) ? (~divisor + 1) : divisor;

                        // Initialize remainder: 9-bit remainder with LSB zero
                        // Left-shifted by one to match algorithm start condition
                        remainder <= {dividend_abs, 1'b0};
                    end
                end

                DIVIDE: begin
                    count <= count + 1;

                    // Update remainder and quotient according to subtraction result
                    remainder <= next_remainder;
                    quotient <= {quotient[6:0], next_quot_bit};
                end

                DONE: begin
                    // Division finished, set result valid
                    res_valid <= 1'b1;

                    // Apply sign corrections

                    // Quotient sign: negative if dividend and divisor signs differ (XOR)
                    if (sign && (dividend_neg ^ divisor_neg))
                        quotient_signed <= (~quotient + 1);
                    else
                        quotient_signed <= quotient;

                    // Remainder sign: same sign as dividend
                    if (sign && dividend_neg)
                        remainder_signed <= (~remainder[8:1] + 1);
                    else
                        remainder_signed <= remainder[8:1];

                    // Pack result {remainder[7:0], quotient[7:0]}
                    // remainder is bits [8:1] truncated to 8 bits
                    result <= {remainder_signed, quotient_signed};
                end
            endcase
        end
    end

endmodule