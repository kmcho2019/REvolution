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

    reg [16:0] SR;        // Shift register: {remainder[7:0], quotient[8:0]}, MSB first (one extra bit for shifting)
    reg [7:0] divisor_abs;
    reg [7:0] dividend_abs;
    reg [3:0] cnt;        // counts 0..8 cycles
    reg start;            // division process active

    reg dividend_sign;
    reg divisor_sign;

    // Compute absolute value
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 1) : val;
        end
    endfunction

    // Two's complement negation
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 1;
        end
    endfunction

    // Sign correct quotient
    function [7:0] sign_correct_quot;
        input [7:0] val;
        input sign_bit;
        begin
            sign_correct_quot = sign_bit ? neg8(val) : val;
        end
    endfunction

    // Sign correct remainder
    function [7:0] sign_correct_rem;
        input [7:0] val;
        input sign_bit;
        begin
            sign_correct_rem = sign_bit ? neg8(val) : val;
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            start <= 0;
            cnt <= 0;
            SR <= 0;
            divisor_abs <= 0;
            dividend_abs <= 0;
            dividend_sign <= 0;
            divisor_sign <= 0;
            result <= 0;
        end else begin
            if (!start) begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Latch signs if signed
                    if (sign) begin
                        dividend_sign <= dividend[7];
                        divisor_sign  <= divisor[7];
                        dividend_abs  <= abs8(dividend);
                        divisor_abs   <= abs8(divisor);
                    end else begin
                        dividend_sign <= 0;
                        divisor_sign  <= 0;
                        dividend_abs  <= dividend;
                        divisor_abs   <= divisor;
                    end

                    // If divisor_abs == 0, output max quotient and dividend as remainder immediately
                    if (divisor == 0) begin
                        res_valid <= 1;
                        // Quotient = all 1's, remainder = dividend
                        result <= {dividend, 8'hFF};
                        start <= 0;
                        cnt <= 0;
                    end else begin
                        // Initialize SR = {remainder=0, quotient=dividend_abs} shifted left 1 bit: quotient is 9 bits
                        // Starting remainder is zero, quotient = dividend_abs, left shifted for division steps
                        SR <= {9'd0, dividend_abs} << 1;
                        cnt <= 0;
                        start <= 1;
                        res_valid <= 0;
                    end
                end
            end else begin
                // Division process running
                // Subtract divisor_abs from remainder portion
                // remainder portion in SR[16:9], 8 bits remainder + 1 bit carry
                // We'll perform: temp = remainder - divisor_abs
                // If no borrow (temp[8]==0), set quotient LSB=1 and remainder=temp
                // Else keep remainder, set quotient LSB=0
                // Then shift SR left by 1 and insert quotient bit at LSB

                // Extract remainder (bits 16 downto 9)
                wire [8:0] remainder_ext = SR[16:8]; // 9 bits for subtraction with borrow detection
                wire [8:0] divisor_ext = {1'b0, divisor_abs};

                wire [8:0] sub = remainder_ext - divisor_ext;
                wire borrow = sub[8]; // borrow if MSB set

                // Prepare new remainder and quotient bit
                // Shift left SR by 1 bit first, quotient shifts left, new LSB set based on borrow
                reg [16:0] SR_next;
                if (!borrow) begin
                    // subtraction successful: remainder = sub[7:0]
                    SR_next[16:9] = sub[7:0];           // update remainder
                    SR_next[8:1] = SR[7:0];             // shift quotient left 1
                    SR_next[0] = 1'b1;                  // quotient LSB = 1
                end else begin
                    // subtraction failed: remainder unchanged
                    SR_next[16:9] = SR[16:9];
                    SR_next[8:1] = SR[7:0];
                    SR_next[0] = 1'b0;
                end

                // increment counter
                cnt <= cnt + 1;

                if (cnt == 7) begin
                    // Last cycle: latch result and apply sign correction
                    start <= 0;
                    res_valid <= 1;

                    // quotient is bits [8:1] (8 bits), remainder is bits [16:9] (8 bits)
                    reg [7:0] quotient_val;
                    reg [7:0] remainder_val;

                    quotient_val = SR_next[8:1];
                    remainder_val = SR_next[16:9];

                    // Sign correction if signed
                    if (sign) begin
                        // quotient sign = dividend_sign XOR divisor_sign
                        quotient_val = (dividend_sign ^ divisor_sign) ? neg8(quotient_val) : quotient_val;
                        // remainder sign = dividend_sign
                        remainder_val = dividend_sign ? neg8(remainder_val) : remainder_val;
                    end

                    result <= {remainder_val, quotient_val};
                end else begin
                    SR <= SR_next;
                end
            end
        end
    end

endmodule