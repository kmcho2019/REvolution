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

    // Internal signals
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg dividend_sign, divisor_sign;

    reg [7:0] quotient;
    reg [7:0] remainder;

    reg [3:0] bit_cnt;    // counts 0..8 for 8 bits division

    reg busy;             // division in progress

    reg [15:0] dividend_reg; // shift register holding dividend bits for feeding remainder

    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Function to compute absolute value for signed 8-bit number
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    // Function to compute negation (two's complement) of 8-bit number
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 8'd1;
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
            final_quotient  <= 8'd0;
            final_remainder <= 8'd0;
        end else begin
            if (!busy) begin
                // Idle state
                res_valid <= 1'b0;  // clear valid when idle

                if (opn_valid) begin
                    // Latch signs and absolute values based on 'sign' input
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

                    // Load dividend into shift register: left-align bits for shifting in remainder
                    // We use the absolute dividend
                    dividend_reg <= {8'd0, (sign ? abs8(dividend) : dividend)};

                    bit_cnt <= 4'd0;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Division in progress
                if (divisor_abs == 8'd0) begin
                    // Division by zero: output all ones quotient and dividend as remainder
                    quotient <= 8'hFF;
                    remainder <= dividend_abs;

                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Adjust signs for final output after division done below
                end else if (bit_cnt < 8) begin
                    // Each iteration:
                    // Shift remainder left by 1 and bring down next bit from dividend_reg MSB
                    // then subtract divisor_abs from trial remainder
                    // if result >= 0, set quotient bit 1, update remainder
                    // else quotient bit 0, remainder unchanged

                    // Extract next bit from dividend_reg
                    wire next_bit = dividend_reg[15];

                    // New trial remainder = (remainder << 1) + next_bit
                    wire [8:0] trial_rem = {remainder, 1'b0} | {{8{1'b0}}, next_bit};
                    // Actually better: trial_rem = (remainder << 1) + next_bit
                    // so trial_rem[8:0]

                    // trial_rem minus divisor_abs
                    wire [8:0] trial_sub = trial_rem - {1'b0, divisor_abs};

                    // Prepare next quotient bit and next remainder value
                    reg [7:0] next_quotient;
                    reg [7:0] next_remainder;

                    // Decide quotient bit and remainder value
                    if (!trial_sub[8]) begin
                        // result >= 0
                        next_remainder = trial_sub[7:0];
                        next_quotient = {quotient[6:0], 1'b1};
                    end else begin
                        // result < 0
                        next_remainder = trial_rem[7:0];
                        next_quotient = {quotient[6:0], 1'b0};
                    end

                    // Update registers
                    remainder <= next_remainder;
                    quotient  <= next_quotient;

                    // Shift dividend_reg left to bring next bit in next cycle
                    dividend_reg <= {dividend_reg[14:0], 1'b0};

                    bit_cnt <= bit_cnt + 1'b1;

                end else begin
                    // Division done: adjust signs if needed
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Sign correction
                    if (sign) begin
                        // quotient sign: dividend_sign XOR divisor_sign
                        if (dividend_sign ^ divisor_sign)
                            final_quotient <= neg8(quotient);
                        else
                            final_quotient <= quotient;

                        // remainder sign = dividend_sign
                        if (dividend_sign)
                            final_remainder <= neg8(remainder);
                        else
                            final_remainder <= remainder;
                    end else begin
                        final_quotient <= quotient;
                        final_remainder <= remainder;
                    end

                    result <= {final_remainder, final_quotient};
                end
            end
        end
    end

endmodule