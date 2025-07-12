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

    // FSM states
    localparam IDLE   = 1'b0;
    localparam DIVIDE = 1'b1;

    reg state, next_state;

    // Latched inputs and sign info
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register 16 bits: [15:8] remainder(8 bits), [7:0] quotient(8 bits)
    reg [15:0] SR;
    reg [15:0] SR_next;

    reg [3:0] cnt, cnt_next; // counter 0..8

    // Subtraction signals:
    wire [7:0] remainder = SR[15:8];
    wire [8:0] subtract_res = {1'b0, remainder} - {1'b0, divisor_abs};
    wire borrow = subtract_res[8]; // borrow if MSB = 1

    wire q_bit = borrow ? 1'b0 : 1'b1;
    wire [7:0] next_remainder = borrow ? remainder : subtract_res[7:0];

    // Sequential logic: state, counter, SR, latches, and res_valid
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            cnt          <= 4'd0;
            SR           <= 16'd0;
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

            // Generate res_valid when division completes (transition DIVIDE->IDLE)
            if (state == DIVIDE && next_state == IDLE)
                res_valid <= 1'b1;
            else
                res_valid <= 1'b0;

            // Latch inputs on start of division when IDLE and opn_valid high and divisor != 0
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

    // Combinational next state logic and SR update
    always @(*) begin
        // Defaults
        next_state = state;
        cnt_next = cnt;
        SR_next = SR;

        case(state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0) begin
                    // Initialize SR:
                    // remainder = 0, quotient = dividend_abs
                    SR_next = {8'd0, dividend_abs};
                    cnt_next = 4'd0;
                    next_state = DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 4'd8) begin
                    // Division done
                    next_state = IDLE;
                    cnt_next = 4'd0;
                    SR_next = SR; // hold final result
                end else begin
                    // Perform one iteration of shift-subtract division
                    // Shift left {remainder, quotient} by 1 bit
                    // Update remainder based on subtraction borrow
                    SR_next = {next_remainder, SR[7:1], q_bit};
                    cnt_next = cnt + 1'b1;
                end
            end
            default: begin
                next_state = IDLE;
                cnt_next = 4'd0;
                SR_next = 16'd0;
            end
        endcase
    end

    // Signed correction for quotient and remainder
    reg [7:0] raw_quotient, raw_remainder;
    reg [7:0] corr_quotient, corr_remainder;

    always @(*) begin
        raw_quotient = SR[7:0];
        raw_remainder = SR[15:8];

        if (sign) begin
            // quotient sign is dividend_neg XOR divisor_neg
            if (dividend_neg ^ divisor_neg)
                corr_quotient = (~raw_quotient + 8'd1);
            else
                corr_quotient = raw_quotient;

            // remainder sign is dividend_neg
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