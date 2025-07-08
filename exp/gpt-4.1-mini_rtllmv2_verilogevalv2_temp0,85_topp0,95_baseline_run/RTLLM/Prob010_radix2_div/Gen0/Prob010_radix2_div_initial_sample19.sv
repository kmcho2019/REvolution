module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);
    reg [16:0] SR; // 17-bit shift register: [16:9]=remainder, [8:1]=quotient bits, [0]=extra bit for shifting
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [8:0] NEG_DIVISOR; // 9-bit to hold negated divisor with sign extension for subtraction
    reg [3:0] cnt;
    reg start_cnt;
    reg dividend_sign;
    reg divisor_sign;
    reg quotient_sign;
    reg remainder_sign;

    wire [8:0] sub_res;
    wire sub_carry_out;

    // Subtract NEG_DIVISOR from upper 9 bits of SR (current remainder)
    assign {sub_carry_out, sub_res} = {1'b0, SR[16:8]} + NEG_DIVISOR;

    // Sign-extend 8-bit to 9-bit
    function [8:0] abs_8bit;
        input [7:0] val;
        input sign_flag;
        begin
            if (sign_flag && val[7]) abs_8bit = {1'b0, (~val + 1'b1)};
            else abs_8bit = {1'b0, val};
        end
    endfunction

    // Negate 9-bit number
    function [8:0] neg_9bit;
        input [8:0] val;
        begin
            neg_9bit = ~val + 1'b1;
        end
    endfunction

    // Signed 8-bit negation
    function [7:0] neg_8bit;
        input [7:0] val;
        begin
            neg_8bit = ~val + 1'b1;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            NEG_DIVISOR <= 9'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Capture signs if signed operation
                dividend_sign <= sign && dividend[7];
                divisor_sign <= sign && divisor[7];
                // Compute abs values for dividend and divisor
                abs_dividend <= (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
                abs_divisor <= (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

                // Initialize shift register: remainder = abs_dividend shifted left by 1 (9 bits remainder)
                // Shift left by 1 means remainder in bits [16:8], quotient bits [7:1] zero, and bit 0 zero
                // We'll build quotient bits from left to right in lower bits of SR
                SR <= {abs_dividend, 8'b0, 1'b0};

                // NEG_DIVISOR = -abs_divisor extended to 9 bits
                NEG_DIVISOR <= neg_9bit({1'b0, abs_divisor});

                // Initialize counter and start
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;

                // Compute quotient and remainder signs
                quotient_sign <= dividend_sign ^ divisor_sign;
                remainder_sign <= dividend_sign;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete, update SR with final remainder and quotient
                    // SR: remainder in bits [16:8], quotient in bits [7:0]
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;

                    // Extract remainder and quotient from SR
                    // remainder = SR[16:9] (8 bits)
                    // quotient = SR[8:1] (8 bits)
                    // bit 0 is not part of quotient

                    // Adjust quotient sign if signed operation
                    // Adjust remainder sign if signed operation
                    // Apply sign correction only if sign == 1
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = SR[8:1];
                    raw_remainder = SR[16:9];

                    if (sign) begin
                        final_quotient = quotient_sign ? neg_8bit(raw_quotient) : raw_quotient;
                        final_remainder = remainder_sign ? neg_8bit(raw_remainder) : raw_remainder;
                    end else begin
                        final_quotient = raw_quotient;
                        final_remainder = raw_remainder;
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end else begin
                    // Division step iteration
                    cnt <= cnt + 1'b1;
                    // Determine if subtraction result is negative via carry out:
                    // carry_out = 1 means no borrow and subtraction positive or zero
                    // carry_out = 0 means subtraction negative (borrow)
                    if (sub_carry_out) begin
                        // subtraction non-negative, so set quotient bit to 1
                        // Shift SR left by 1, insert 1 at LSB
                        SR <= {sub_res, SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative, keep remainder unchanged, quotient bit = 0
                        // Shift SR left by 1, insert 0 at LSB
                        SR <= {SR[16:0], 1'b0} << 1;
                        // Actually, to keep remainder unchanged, shift left by 1 and insert 0 at LSB of quotient
                        // so equivalent to:
                        // SR <= {SR[16:0], 1'b0} << 1 is a left shift by 2 bits which is not correct
                        // Correct: shift left by 1 inserting 0 at LSB:
                        // SR <= {SR[15:0],1'b0};
                        // But remainder is upper 9 bits, so:
                        SR <= {SR[15:0], 1'b0};
                    end
                end
            end else if (res_valid && !opn_valid) begin
                // Clear res_valid when result has been consumed (opn_valid low)
                res_valid <= 1'b0;
            end
        end
    end
endmodule