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

    // Internal states
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg dividend_sign, divisor_sign;

    reg [7:0] quotient;
    reg [7:0] remainder;

    reg [3:0] bit_cnt;    // counter for division steps (0 to 8)

    reg busy;             // division in progress flag

    reg [15:0] dividend_reg; // shift register to bring down dividend bits

    // Intermediate registers for subtraction and decision
    reg [8:0] sub_res;       // 9-bit to hold remainder - divisor_abs result (include carry)
    reg       sub_ge_zero;   // flag if subtraction >= 0
    reg       quotient_bit;  // quotient bit decided this cycle

    // Registers for sign-corrected final results (declared at module scope)
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Function to compute absolute value for signed 8-bit number
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = (val[7]) ? (~val + 1) : val;
        end
    endfunction

    // Function to compute negation (two's complement) of 8-bit number
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 1;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all state and outputs
            res_valid     <= 1'b0;
            busy          <= 1'b0;
            bit_cnt       <= 4'd0;
            quotient      <= 8'd0;
            remainder     <= 8'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            dividend_reg  <= 16'd0;
            result        <= 16'd0;
            final_quotient<= 8'd0;
            final_remainder<=8'd0;
            sub_res       <= 9'd0;
            sub_ge_zero   <= 1'b0;
            quotient_bit  <= 1'b0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;  // clear result valid when idle

                if (opn_valid) begin
                    // On new operation start, latch inputs and prepare internal variables
                    if (sign) begin
                        dividend_sign <= dividend[7];
                        divisor_sign  <= divisor[7];
                        dividend_abs  <= abs8(dividend);
                        divisor_abs   <= abs8(divisor);
                    end else begin
                        dividend_sign <= 1'b0;
                        divisor_sign  <= 1'b0;
                        dividend_abs  <= dividend;
                        divisor_abs   <= divisor;
                    end

                    quotient  <= 8'd0;
                    remainder <= 8'd0;

                    // Load dividend bits into dividend_reg shifted left 8 bits
                    // We'll shift bits down into remainder on each step
                    dividend_reg <= {dividend_abs, 8'd0};

                    bit_cnt <= 4'd0;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Division in progress

                if (divisor_abs == 8'd0) begin
                    // Division by zero case: output max quotient, remainder = dividend_abs
                    quotient <= 8'hFF;
                    remainder <= dividend_abs;
                    busy <= 1'b0;
                    res_valid <= 1'b1;
                end else if (bit_cnt < 8) begin
                    // Shift remainder left by 1 and bring down the MSB of dividend_reg
                    // remainder_next = {remainder[6:0], dividend_reg[15]};
                    // Compute tentative subtraction: remainder_next - divisor_abs
                    // sub_res is 9-bit because subtraction can borrow (sign extend)
                    reg [8:0] tentative_remainder;
                    tentative_remainder = {1'b0, remainder[6:0], dividend_reg[15]};
                    sub_res = tentative_remainder - {1'b0, divisor_abs};

                    // Determine if subtraction result >= 0 (no borrow)
                    sub_ge_zero = ~sub_res[8];

                    // Update quotient bit accordingly
                    quotient_bit = sub_ge_zero ? 1'b1 : 1'b0;

                    // Update remainder and quotient in next cycle
                    if (sub_ge_zero) begin
                        remainder <= sub_res[7:0];
                    end else begin
                        remainder <= tentative_remainder[7:0];
                    end

                    quotient <= {quotient[6:0], quotient_bit};

                    // Shift dividend_reg left by 1 to bring next bit on next cycle
                    dividend_reg <= {dividend_reg[14:0], 1'b0};

                    bit_cnt <= bit_cnt + 1'b1;

                end else begin
                    // Division complete after 8 steps

                    // Apply sign correction
                    if (sign) begin
                        final_quotient <= (dividend_sign ^ divisor_sign) ? neg8(quotient) : quotient;
                        final_remainder <= dividend_sign ? neg8(remainder) : remainder;
                    end else begin
                        final_quotient <= quotient;
                        final_remainder <= remainder;
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                    busy <= 1'b0;
                end
            end
        end
    end

endmodule