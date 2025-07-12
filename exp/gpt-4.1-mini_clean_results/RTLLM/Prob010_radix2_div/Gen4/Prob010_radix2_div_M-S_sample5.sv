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

    // FSM States encoding
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;

    // Registers to hold operands and signs
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       sign_quotient, sign_remainder;

    // Absolute values
    wire [7:0] dividend_abs;
    wire [7:0] divisor_abs;

    assign dividend_abs = (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
    assign divisor_abs  = (sign && divisor_reg[7])  ? (~divisor_reg + 1) : divisor_reg;

    // 17-bit shift register: [16:8] remainder (9 bits), [7:0] quotient
    reg [16:0] SR;

    // Division iteration counter (0 to 7)
    reg [3:0] cnt;

    // Combinational subtraction: remainder - divisor_abs
    wire [8:0] remainder_part = SR[16:8];
    wire [9:0] sub_result = {1'b0, remainder_part} - {1'b0, divisor_abs};
    wire       sub_borrow = sub_result[9];
    wire       quotient_bit = ~sub_borrow;
    wire [8:0] remainder_next = quotient_bit ? sub_result[8:0] : remainder_part;

    wire [16:0] SR_next = {remainder_next, SR[7:1], quotient_bit};

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (opn_valid) ? RUN : IDLE;
            RUN:  next_state = (cnt == 4'd7) ? DONE : RUN;
            DONE: next_state = (opn_valid) ? RUN : DONE;
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

                        // Initialize SR: remainder = dividend_abs (9 bits, with zero extended MSB),
                        // quotient = 0
                        // To align with shifting, set remainder in bits [16:8], quotient zeroed.
                        // Use zero extension for remainder MSB since dividend_abs is 8 bits.
                        SR <= {1'b0, dividend_abs, 8'd0}; // 1-bit MSB + 8-bit dividend + 8-bit quotient
                    end
                end

                RUN: begin
                    SR <= SR_next;
                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Extract unsigned quotient and remainder
                    reg [7:0] quotient_u;
                    reg [7:0] remainder_u;
                    reg [7:0] quotient_s;
                    reg [7:0] remainder_s;

                    quotient_u = SR[7:0];
                    remainder_u = SR[16:9];

                    // Apply sign correction
                    quotient_s = sign_quotient ? (~quotient_u + 1) : quotient_u;
                    remainder_s = sign_remainder ? (~remainder_u + 1) : remainder_u;

                    result <= {remainder_s, quotient_s};
                    res_valid <= 1'b1;

                    // Clear res_valid when new operation arrives next cycle
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule