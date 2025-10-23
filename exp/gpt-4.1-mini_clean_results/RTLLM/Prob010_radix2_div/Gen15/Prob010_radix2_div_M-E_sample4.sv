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

    reg [3:0] bit_cnt;    // 0..8

    reg busy;             // division in progress

    reg [15:0] dividend_reg; // to shift in bits to remainder on each cycle

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
            res_valid    <= 1'b0;
            busy         <= 1'b0;
            bit_cnt      <= 4'd0;
            quotient     <= 8'd0;
            remainder    <= 8'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            dividend_reg <= 16'd0;
            result       <= 16'd0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;  // clear valid on idle

                if (opn_valid) begin
                    // If divisor is zero, force output zero and valid immediately (avoid divide-by-zero)
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

                    // Reset quotient and remainder
                    quotient  <= 8'd0;
                    remainder <= 8'd0;

                    // Prepare dividend register for bit shifting, left shifted by 8 bits to hold bits for remainder shifting
                    dividend_reg <= {8'd0, (sign && dividend[7]) ? abs8(dividend) : dividend};

                    bit_cnt <= 4'd0;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Division in progress

                if (divisor_abs == 8'd0) begin
                    // Division by zero: quotient = all 1's, remainder = dividend
                    quotient <= 8'hFF;
                    remainder <= dividend_abs;

                    busy <= 1'b0;
                    res_valid <= 1'b1;
                end else if (bit_cnt < 8) begin
                    // Shift remainder left by 1 bit and bring down next dividend bit (MSB first)
                    remainder <= {remainder[6:0], dividend_reg[15]};

                    // Shift dividend_reg left by 1 to bring next bit in next cycle
                    dividend_reg <= {dividend_reg[14:0], 1'b0};

                    // Tentative subtraction remainder - divisor_abs
                    // Because remainder is updated just now, we subtract divisor_abs from this new remainder
                    if ({1'b0, {remainder[6:0], dividend_reg[15]}} >= divisor_abs) begin
                        // Subtract and set quotient bit
                        remainder <= ({remainder[6:0], dividend_reg[15]} - divisor_abs);
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // Keep remainder, quotient bit = 0
                        quotient <= {quotient[6:0], 1'b0};
                    end

                    bit_cnt <= bit_cnt + 1'b1;
                end else begin
                    // Completed 8 bits division

                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Adjust signs if signed division
                    // quotient_sign = dividend_sign XOR divisor_sign
                    // remainder_sign = dividend_sign (remainder always takes dividend sign)
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    if (sign) begin
                        final_quotient = (dividend_sign ^ divisor_sign) ? neg8(quotient) : quotient;
                        final_remainder= dividend_sign ? neg8(remainder) : remainder;
                    end else begin
                        final_quotient = quotient;
                        final_remainder= remainder;
                    end

                    result <= {final_remainder, final_quotient};
                end
            end
        end
    end

endmodule