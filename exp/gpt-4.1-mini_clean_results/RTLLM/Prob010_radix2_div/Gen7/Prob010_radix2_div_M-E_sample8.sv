module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output     [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // Simple FSM states
    localparam IDLE   = 1'b0;
    localparam DIVIDE = 1'b1;

    reg state, next_state;

    // Latched inputs and sign info
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register 17 bits: [16:8] remainder(9 bits), [7:0] quotient(8 bits)
    reg [16:0] SR;
    reg [16:0] SR_next;

    reg [3:0] cnt, cnt_next; // counter 0..8

    // Signals for subtraction
    wire [8:0] remainder = SR[16:8];
    wire [8:0] subtract_res = remainder - {1'b0, divisor_abs};
    wire borrow = subtract_res[8]; // borrow if MSB = 1

    wire q_bit = borrow ? 1'b0 : 1'b1;
    wire [8:0] next_remainder = borrow ? remainder : subtract_res;

    // State transition and counters sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            cnt          <= 4'd0;
            SR           <= 17'd0;
            res_valid    <= 1'b0;

            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
        end else begin
            state <= next_state;
            cnt   <= cnt_next;
            SR    <= SR_next;
            res_valid <= (next_state == IDLE && state == DIVIDE) ? 1'b1 : 1'b0;

            // Latch inputs on start of division
            if (state == IDLE && opn_valid && divisor != 8'd0) begin
                dividend_r <= dividend;
                divisor_r  <= divisor;
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                    divisor_abs  <= divisor[7]  ? (~divisor + 8'd1) : divisor;
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    dividend_abs <= dividend;
                    divisor_abs  <= divisor;
                end
            end
        end
    end

    // Next state logic and SR, cnt update
    always @(*) begin
        // Defaults
        next_state = state;
        cnt_next = cnt;
        SR_next = SR;

        case(state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0) begin
                    // Initialize SR:
                    // remainder = 0 (9 bits), quotient = dividend_abs (8 bits)
                    SR_next = {9'd0, dividend_abs};
                    cnt_next = 4'd0;
                    next_state = DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 4'd8) begin
                    next_state = IDLE;
                    cnt_next = 4'd0;
                    // SR holds final remainder and quotient
                    SR_next = SR;
                end else begin
                    // Shift left SR by 1 bit: shift remainder+quotient left 1 bit
                    // Replace LSB of quotient with q_bit
                    // The division step:
                    // remainder update depends on borrow from subtraction

                    // Shift left SR by 1 bit:
                    // left shift remainder and quotient by 1 bit, then adjust remainder to next_remainder
                    // We update remainder (bits 16:8) to next_remainder,
                    // shift quotient (bits 7:0) left by 1 bit and insert q_bit at LSB.

                    // Implement step by step:

                    // Shift quotient left 1, insert q_bit
                    // Note quotient is SR[7:0], remainder SR[16:8]

                    SR_next = {next_remainder, SR[7:1], q_bit};
                    cnt_next = cnt + 1'b1;
                end
            end
            default: begin
                next_state = IDLE;
                cnt_next = 4'd0;
                SR_next = 17'd0;
            end
        endcase
    end

    // Signed correction combinational logic for output
    reg [7:0] raw_quotient, raw_remainder;
    reg [7:0] corr_quotient, corr_remainder;

    always @(*) begin
        raw_quotient = SR[7:0];
        raw_remainder = SR[16:9];

        if (sign) begin
            // quotient sign: dividend_neg XOR divisor_neg
            if (dividend_neg ^ divisor_neg)
                corr_quotient = (~raw_quotient + 8'd1);
            else
                corr_quotient = raw_quotient;

            // remainder sign = dividend_neg
            if (dividend_neg)
                corr_remainder = (~raw_remainder + 8'd1);
            else
                corr_remainder = raw_remainder;
        end else begin
            corr_quotient = raw_quotient;
            corr_remainder = raw_remainder;
        end
    end

    assign result = {corr_remainder, corr_quotient};

endmodule