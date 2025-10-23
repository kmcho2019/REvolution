module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    reg [3:0] cnt;
    reg start_cnt;

    reg dividend_neg, divisor_neg, quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;
    reg [8:0] neg_divisor;     // 9-bit negated divisor
    reg [16:0] SR;             // 17-bit shift register: [16:8] remainder (9 bits), [7:0] quotient

    // Abs calculation for signed inputs
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Two's complement 8-bit
    function [7:0] twos_comp8;
        input [7:0] val;
        begin
            twos_comp8 = ~val + 8'd1;
        end
    endfunction

    // Two's complement 9-bit
    function [8:0] twos_comp9;
        input [8:0] val;
        begin
            twos_comp9 = ~val + 9'd1;
        end
    endfunction

    reg [16:0] sub_res;  // remainder - divisor_abs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid    <= 1'b0;
            result       <= 16'd0;
            cnt          <= 4'd0;
            start_cnt    <= 1'b0;
            SR           <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            neg_divisor  <= 9'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            if (!start_cnt && opn_valid && !res_valid) begin
                // Start new division
                dividend_abs <= abs8(dividend);
                divisor_abs  <= abs8(divisor);
                dividend_neg <= (sign && dividend[7]);
                divisor_neg  <= (sign && divisor[7]);
                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg<= (sign && dividend[7]);

                // neg_divisor = -divisor_abs extended to 9 bits
                neg_divisor <= twos_comp9({1'b0, abs8(divisor)});

                // Initialize SR: remainder (9 bits) = dividend_abs shifted left 1 bit, quotient = 0
                SR <= {dividend_abs, 1'b0, 8'd0};

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division in progress
                if (divisor_abs == 8'd0) begin
                    // Division by zero: keep shifting till cnt=8
                    if (cnt < 4'd8) cnt <= cnt + 1'b1;
                    else begin
                        start_cnt <= 1'b0;
                        cnt       <= 0;
                        result    <= 16'd0;
                        res_valid <= 1'b1;
                    end
                end else if (cnt <= 4'd8) begin
                    // Calculate remainder - divisor_abs
                    sub_res = {1'b0, SR[16:8]} + neg_divisor;
                    if (!sub_res[16]) begin
                        // subtraction result >= 0, update remainder and quotient bit = 1
                        SR <= {sub_res[15:7], SR[7:1], 1'b1};
                    end else begin
                        // subtraction result < 0, keep remainder, quotient bit = 0
                        SR <= {SR[15:0], 1'b0};
                    end

                    if (cnt == 4'd8) begin
                        start_cnt <= 1'b0;
                        cnt       <= 0;

                        // Correct signs if signed
                        reg [7:0] final_quotient = SR[7:0];
                        reg [7:0] final_remainder = SR[16:9];
                        if (sign) begin
                            if (quotient_neg)
                                final_quotient = twos_comp8(final_quotient);
                            if (remainder_neg)
                                final_remainder = twos_comp8(final_remainder);
                        end

                        result <= {final_remainder, final_quotient};
                        res_valid <= 1'b1;
                    end else begin
                        cnt <= cnt + 1'b1;
                    end
                end
            end else begin
                // Wait for new input or reset res_valid on new opn_valid
                if (res_valid && opn_valid)
                    res_valid <= 1'b0;
            end
        end
    end

endmodule