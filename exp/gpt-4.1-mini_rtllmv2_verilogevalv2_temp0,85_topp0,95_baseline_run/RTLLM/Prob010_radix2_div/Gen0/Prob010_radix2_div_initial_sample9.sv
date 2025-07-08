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
    reg [8:0] SR; // Shift register: 9 bits to hold remainder (8 bits + 1) and quotient bit shifted in
    reg [7:0] divisor_abs;
    reg [8:0] NEG_DIVISOR; // Negative divisor absolute value extended to 9 bits (for subtraction)
    reg [3:0] cnt; // counter from 1 to 8 inclusive
    reg start_cnt;

    reg [7:0] dividend_abs;
    reg dividend_sign;
    reg divisor_sign;

    // Temporary subtraction result
    reg signed [9:0] sub_res; // 10 bits signed to hold subtraction result with sign

    // State machine or control signals implicitly via counters and start_cnt

    // Helper function: absolute value
    function [7:0] abs_val;
        input [7:0] val;
        input s;
        begin
            if (s && val[7]) // signed and negative
                abs_val = (~val + 1);
            else
                abs_val = val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 0;
            NEG_DIVISOR <= 0;
            divisor_abs <= 0;
            dividend_abs <= 0;
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 0;
            result <= 0;
            dividend_sign <= 0;
            divisor_sign <= 0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Latch inputs and initialize
                dividend_sign <= sign && dividend[7];
                divisor_sign <= sign && divisor[7];

                dividend_abs <= abs_val(dividend, sign);
                divisor_abs <= abs_val(divisor, sign);

                // Initialize SR with dividend_abs shifted left by 1 bit (9 bits)
                // SR[8:1] = dividend_abs, SR[0] = 0
                SR <= {dividend_abs, 1'b0};

                // NEG_DIVISOR is two's complement of divisor_abs, extended to 9 bits
                NEG_DIVISOR <= {1'b0, divisor_abs};
                NEG_DIVISOR <= (~{1'b0, divisor_abs} + 9'b1);

                cnt <= 4'd1;
                start_cnt <= 1;
                res_valid <= 0;
                result <= 0;
            end else if (start_cnt) begin
                // Perform division step
                // sub_res = SR[8:0] + NEG_DIVISOR (SR holds remainder bits, divisor negated for subtraction)
                // Use signed arithmetic: extend SR and NEG_DIVISOR to signed 10 bits
                sub_res = $signed({1'b0, SR}) + $signed({1'b0, NEG_DIVISOR});

                if (sub_res[9] == 0) begin
                    // subtraction result is positive or zero: update SR with sub_res shifted left by 1 and set LSB 1
                    SR <= {sub_res[8:0], 1'b1};
                end else begin
                    // subtraction result is negative: shift SR left by 1 and set LSB 0
                    SR <= {SR[7:0], 1'b0};
                end

                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 0;
                    cnt <= 0;

                    // Final remainder is in SR[8:1] (9 bits shifted), quotient in SR[0..7]
                    // Extract remainder and quotient
                    reg [7:0] quotient;
                    reg [7:0] remainder;

                    // Remainder is SR[8:1]
                    remainder = SR[8:1];
                    quotient = SR[0] ? {SR[7:1], 1'b1} : SR[7:0];
                    // Correction on quotient is already in SR by shifting in bits

                    // Adjust signs if signed division:
                    if (sign) begin
                        // quotient sign = dividend_sign ^ divisor_sign
                        if (dividend_sign ^ divisor_sign)
                            quotient = (~quotient) + 8'b1;

                        // remainder sign = dividend_sign
                        if (dividend_sign)
                            remainder = (~remainder) + 8'b1;
                    end

                    // Compose result: remainder in upper 8 bits, quotient in lower 8 bits
                    result <= {remainder, quotient};
                    res_valid <= 1;
                end else begin
                    cnt <= cnt + 1;
                end
            end else begin
                // Wait for next opn_valid or clear res_valid after consumption
                if (res_valid && opn_valid) begin
                    // If new operation requested when result is still valid, ignore start until reset or next cycle
                    res_valid <= res_valid;
                end else if (res_valid && !opn_valid) begin
                    // Clear res_valid when result is consumed (opn_valid low)
                    res_valid <= 0;
                end
            end
        end
    end

endmodule