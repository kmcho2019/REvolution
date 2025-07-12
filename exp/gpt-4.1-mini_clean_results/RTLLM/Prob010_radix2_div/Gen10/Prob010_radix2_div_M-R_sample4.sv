module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // One-hot FSM state signals
    reg state_idle, state_run, state_done;
    wire next_idle, next_run, next_done;

    // Latched inputs and sign flags
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // Division registers
    reg [7:0] quotient;
    reg [7:0] remainder;

    // Iteration counter
    reg [3:0] cnt;

    // Combinational subtraction result (remainder - divisor_abs)
    wire [8:0] sub_res = {1'b0, remainder} - {1'b0, divisor_abs};
    wire       borrow = sub_res[8];

    // Next remainder and quotient bit based on subtraction
    wire [7:0] remainder_sub = sub_res[7:0];
    wire       q_bit = ~borrow;

    // Next remainder and quotient values for next cycle
    wire [7:0] next_remainder = borrow ? remainder : remainder_sub;
    wire [7:0] next_quotient = {quotient[6:0], q_bit};

    // State transitions logic (combinational)
    assign next_idle = rst || (state_done && !opn_valid);
    assign next_run = (state_idle && opn_valid && (divisor != 8'd0)) || (state_run && cnt != 4'd8);
    assign next_done = (state_run && cnt == 4'd8);

    // FSM sequential logic (one-hot encoding)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_idle <= 1'b1;
            state_run <= 1'b0;
            state_done <= 1'b0;
        end else begin
            state_idle <= next_idle;
            state_run <= next_run;
            state_done <= next_done;
        end
    end

    // Latch operands on operation start
    always @(posedge clk) begin
        if (state_idle && opn_valid && divisor != 8'd0) begin
            dividend_r <= dividend;
            divisor_r <= divisor;
            if (sign) begin
                dividend_neg <= dividend[7];
                divisor_neg <= divisor[7];
                dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                divisor_abs <= divisor[7] ? (~divisor + 8'd1) : divisor;
            end else begin
                dividend_neg <= 1'b0;
                divisor_neg <= 1'b0;
                dividend_abs <= dividend;
                divisor_abs <= divisor;
            end
            // Initialize remainder to zero, quotient to dividend_abs
            remainder <= 8'd0;
            quotient <= dividend_abs;
            cnt <= 4'd0;
            res_valid <= 1'b0;
        end else if (state_run) begin
            // Perform division iteration:
            // Shift {remainder, quotient} left by 1 bit, input q_bit into quotient LSB
            remainder <= next_remainder;
            quotient <= next_quotient;
            cnt <= cnt + 1'b1;
        end else if (state_done) begin
            // Hold result valid for one cycle
            res_valid <= 1'b1;
            cnt <= 4'd0;
        end else begin
            res_valid <= 1'b0;
        end
    end

    // Handle divisor == 0 (undefined division), output zero quotient and remainder
    wire zero_divisor = (divisor_r == 8'd0);

    // Signed correction logic for quotient and remainder (combinational)
    reg [7:0] corr_quotient;
    reg [7:0] corr_remainder;

    always @(*) begin
        if (state_done) begin
            if (zero_divisor) begin
                // Division by zero yields zero quotient and remainder by definition here
                corr_quotient = 8'd0;
                corr_remainder = 8'd0;
            end else if (sign) begin
                // Quotient sign correction: dividend_neg XOR divisor_neg
                if (dividend_neg ^ divisor_neg)
                    corr_quotient = (~quotient + 8'd1);
                else
                    corr_quotient = quotient;
                // Remainder sign correction: same sign as dividend_neg
                if (dividend_neg)
                    corr_remainder = (~remainder + 8'd1);
                else
                    corr_remainder = remainder;
            end else begin
                corr_quotient = quotient;
                corr_remainder = remainder;
            end
        end else begin
            // Not done, output zero or hold last result (here zero)
            corr_quotient = 8'd0;
            corr_remainder = 8'd0;
        end
    end

    // Result register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'd0;
        end else if (state_done) begin
            result <= {corr_remainder, corr_quotient};
        end
    end

endmodule