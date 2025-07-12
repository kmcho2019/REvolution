module radix2_div(
    input             clk,
    input             rst,
    input             sign,          // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers to store operands and signs
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       sign_quotient, sign_remainder;

    // Absolute values
    wire [7:0] dividend_abs;
    wire [7:0] divisor_abs;

    assign dividend_abs = (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
    assign divisor_abs  = (sign && divisor_reg[7])  ? (~divisor_reg + 1) : divisor_reg;

    // Shift register: 17 bits = 9 bits remainder (MSB), 8 bits quotient (LSB)
    reg [16:0] SR;

    // Counter for division cycles (0 to 7)
    reg [3:0] cnt;

    // Combinational signals for subtraction
    wire [8:0] remainder_part;
    wire [9:0] sub_result;
    wire       sub_borrow;
    wire [8:0] remainder_next;
    wire       quotient_bit;

    assign remainder_part = SR[16:8]; // upper 9 bits
    assign {sub_borrow, sub_result} = {1'b0, remainder_part} - {1'b0, divisor_abs};
    assign quotient_bit = ~sub_borrow;
    assign remainder_next = quotient_bit ? sub_result[8:0] : remainder_part;

    // Next value of SR during RUN state
    wire [16:0] SR_next;
    assign SR_next = {remainder_next, SR[7:1], quotient_bit};

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? RUN : IDLE;
            RUN:    next_state = (cnt == 4'd7) ? DONE : RUN;
            DONE:   next_state = (opn_valid) ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            cnt <= 4'd0;
            dividend_reg <= 8'd0;
            divisor_reg <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;

                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end

                        // Initialize SR: remainder = dividend_abs shifted left by 1 bit (9 bits)
                        // The remainder field is 9 bits wide to accommodate shifted dividend_abs
                        // Quotient starts at 0
                        SR <= {dividend_abs, 8'd0};
                    end
                end

                RUN: begin
                    // Perform one division iteration
                    SR <= SR_next;
                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Apply sign correction to quotient and remainder
                    // Extract unsigned quotient and remainder
                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned = SR[16:9];

                    // Quotient sign correction
                    quotient_signed = sign_quotient ? (~quotient_unsigned + 1) : quotient_unsigned;

                    // Remainder sign correction
                    remainder_signed = sign_remainder ? (~remainder_unsigned + 1) : remainder_unsigned;

                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;

                    // If new operation valid, clear res_valid next cycle via state transition
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                        // Next state logic will move us to RUN automatically
                    end
                end
            endcase
        end
    end

endmodule