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

    // States encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Latched inputs and sign info
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // 17-bit shift register: upper 9 bits remainder, lower 8 bits quotient
    reg [16:0] SR, SR_next;

    // 4-bit counter for iteration (0..8)
    reg [3:0] cnt, cnt_next;

    // Signals for subtraction
    wire [8:0] rem_part = SR[16:8];            // upper 9 bits remainder
    wire [8:0] sub_res  = rem_part - {1'b0, divisor_abs};
    wire       borrow   = sub_res[8];          // borrow if MSB=1

    wire [8:0] next_rem = borrow ? rem_part : sub_res;
    wire       qbit     = borrow ? 1'b0 : 1'b1;

    // Sequential block: state, counters, registers updates
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

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && divisor != 8'd0) begin
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

                CALC: begin
                    // Nothing else to do here; cnt and SR updated below
                end

                DONE: begin
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // Combinational block: next_state, cnt_next, SR_next calculations
    always @(*) begin
        // Default assignments
        next_state = state;
        cnt_next   = cnt;
        SR_next    = SR;

        case (state)
            IDLE: begin
                if (opn_valid && divisor_r != 8'd0) begin
                    // Initialize SR:
                    // Remainder upper 9 bits = 0
                    // Quotient lower 8 bits = dividend_abs
                    // A left shift by one bit is not required here as we keep remainder in upper bits and quotient in lower bits

                    // Actually, to follow the problem description "SR with abs(dividend) shifted left by one bit"
                    // We can set SR = {8'd0, dividend_abs, 1'b0}; => 9 bits remainder and 8 bits quotient + shift
                    // But since our SR is 17 bits, let's do this carefully:
                    // Using 17 bits: 9 remainder + 8 quotient
                    // We shift dividend_abs left by 1 bit and place it at lower bits, leaving remainder zeroed
                    // That means: remainder = 0, quotient = dividend_abs shifted left by 1?

                    // The original example shifts dividend by 1 bit into remainder (to the left),
                    // Actually radix-2 division algorithm often shifts the remainder left 1 bit with quotient bits appended
                    // Here, to simplify and align with the example, initialize remainder to 0, quotient to dividend_abs

                    SR_next = {9'd0, dividend_abs};
                    cnt_next = 4'd0;
                    next_state = CALC;
                end
            end

            CALC: begin
                // Perform division step:
                // Shift left SR by 1 bit, insert qbit in LSB of quotient, update remainder

                SR_next = {next_rem, SR[7:1], qbit};
                cnt_next = cnt + 1'b1;

                if (cnt == 4'd8) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (opn_valid && divisor != 8'd0) begin
                    // Start new division operation if requested
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
        endcase
    end

    // Output result: signed correction applied combinationally
    // Avoid declaring regs inside procedural blocks by declaring here
    reg [7:0] raw_quotient, raw_remainder;
    reg [7:0] corr_quotient, corr_remainder;

    always @(*) begin
        raw_quotient  = SR[7:0];
        raw_remainder = SR[16:9];

        if (sign) begin
            // quotient sign = dividend_neg XOR divisor_neg
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