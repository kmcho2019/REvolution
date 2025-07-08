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

    // Internal registers
    reg [8:0] SR; // 9-bit shift register to hold remainder and quotient bits (Remainder + Quotient bit)
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    reg dividend_sign;
    reg divisor_sign;
    reg quotient_sign;
    reg remainder_sign;

    wire [8:0] sub_res;
    wire sub_carry_out;

    // Compute subtraction: SR[8:1] - NEG_DIVISOR (9-bit operands)
    // SR[8:1] is remainder part (8 bits) + one MSB
    wire [8:0] sr_rem = SR[8:1];
    assign {sub_carry_out, sub_res} = {1'b0, sr_rem} + {1'b0, NEG_DIVISOR}; // adding NEG_DIVISOR (which is negative) to remainder

    // Absolute value function
    function [7:0] abs_val(input [7:0] val, input sign_bit);
        begin
            if (sign_bit && val[7])
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Negate function for 8-bit
    function [7:0] negate(input [7:0] val);
        begin
            negate = (~val) + 1'b1;
        end
    endfunction

    // Sign extend NEG_DIVISOR to 9 bits for subtraction
    wire [8:0] neg_divisor_9 = {1'b1, NEG_DIVISOR}; // NEG_DIVISOR is negative, so MSB=1

    // FSM and logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            cnt <= 0;
            start_cnt <= 1'b0;
            SR <= 9'd0;
            result <= 16'd0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            NEG_DIVISOR <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Start operation: latch inputs and prepare
                dividend_sign <= sign & dividend[7];
                divisor_sign  <= sign & divisor[7];
                abs_dividend  <= abs_val(dividend, sign & dividend[7]);
                abs_divisor   <= abs_val(divisor, sign & divisor[7]);
                NEG_DIVISOR   <= negate(abs_val(divisor, sign & divisor[7]));
                // Initialize SR with abs_dividend shifted left by 1 (9 bits)
                SR <= {abs_val(dividend, sign & dividend[7]), 1'b0};
                cnt <= 1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process
                // sub_res = SR[8:1] - abs_divisor (NEG_DIVISOR added because NEG_DIVISOR is negative)
                // if carry out (sub_carry_out) == 1, subtraction result is >=0, update SR accordingly
                // else if carry out == 0, subtraction result negative, do not update remainder part, set quotient bit to 0
                if (cnt == 8) begin
                    // Last cycle, division finished
                    start_cnt <= 1'b0;
                    cnt <= 0;

                    // Final remainder is SR[8:1] if subtraction succeeded on last step, else SR[8:1] unchanged
                    // Quotient is SR[7:0]

                    // Determine quotient_sign and remainder_sign
                    quotient_sign <= dividend_sign ^ divisor_sign;
                    remainder_sign <= dividend_sign;

                    // Apply sign correction for quotient and remainder
                    // If signed, quotient and remainder must be signed corrected
                    // quotient = quotient_sign ? -quotient : quotient
                    // remainder = remainder_sign ? -remainder : remainder

                    // Extract quotient and remainder from SR
                    // Quotient: SR[7:0]
                    // Remainder: SR[8:1]

                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_raw = SR[7:0];
                    remainder_raw = SR[8:1];

                    // Apply sign correction
                    if (sign) begin
                        if (quotient_sign)
                            quotient_signed = negate(quotient_raw);
                        else
                            quotient_signed = quotient_raw;

                        if (remainder_sign)
                            remainder_signed = negate(remainder_raw);
                        else
                            remainder_signed = remainder_raw;
                    end else begin
                        quotient_signed = quotient_raw;
                        remainder_signed = remainder_raw;
                    end

                    // Pack result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;

                end else begin
                    // Continue division process
                    cnt <= cnt + 1;

                    if (sub_carry_out == 1'b1) begin
                        // subtraction >= 0, update remainder, shift left and append 1 to quotient
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // subtraction < 0, keep remainder, shift left and append 0 to quotient
                        SR <= {SR[7:0], SR[0], 1'b0};
                    end
                end
            end else if (res_valid && opn_valid) begin
                // Start new operation after result consumed
                res_valid <= 1'b0;
            end
        end
    end

endmodule