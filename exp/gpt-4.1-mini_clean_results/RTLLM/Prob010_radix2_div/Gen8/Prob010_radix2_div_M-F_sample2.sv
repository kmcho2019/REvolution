module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,      // Output valid signal: indicates result ready
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    reg [3:0] cnt;
    reg start_cnt;

    reg dividend_neg, divisor_neg, quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;
    wire [8:0] neg_divisor;

    // 17-bit shift register: [16:8] remainder(9 bits), [7:0] quotient
    reg [16:0] SR;

    // Absolute value calculation for signed inputs
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // 8-bit two's complement
    function [7:0] twos_comp8;
        input [7:0] val;
        begin
            twos_comp8 = ~val + 8'd1;
        end
    endfunction

    // 9-bit two's complement
    function [8:0] twos_comp9;
        input [8:0] val;
        begin
            twos_comp9 = ~val + 9'd1;
        end
    endfunction

    // Compute negated divisor combinationally each cycle for subtraction
    assign neg_divisor = twos_comp9({1'b0, divisor_abs});

    reg [16:0] sub_res;

    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid      <= 1'b0;
            result         <= 16'd0;
            cnt            <= 4'd0;
            start_cnt      <= 1'b0;
            SR             <= 17'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            final_quotient <= 8'd0;
            final_remainder<= 8'd0;
        end else begin
            if (!start_cnt && opn_valid && !res_valid) begin
                // Start division: capture inputs, signs and initialize shift register
                dividend_abs <= abs8(dividend);
                divisor_abs  <= abs8(divisor);
                dividend_neg <= (sign && dividend[7]);
                divisor_neg  <= (sign && divisor[7]);
                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg<= (sign && dividend[7]);

                // Initialize SR: remainder = dividend_abs shifted left by 1 bit (9 bits), quotient=0
                SR <= {dividend_abs, 1'b0, 8'd0};

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process active
                if (divisor_abs == 8'd0) begin
                    // Division by zero: output zeros after 8 cycles
                    if (cnt < 4'd8) begin
                        cnt <= cnt + 1'b1;
                        SR  <= {SR[15:0], 1'b0};  // Shift left SR, quotient bit zero
                    end else begin
                        start_cnt <= 1'b0;
                        cnt       <= 4'd0;
                        result    <= 16'd0;
                        res_valid <= 1'b1;
                    end
                end else if (cnt <= 4'd8) begin
                    // Calculate sub_res = remainder - divisor_abs
                    sub_res = {1'b0, SR[16:8]} + neg_divisor;

                    if (!sub_res[16]) begin
                        // subtraction non-negative: update remainder and quotient bit = 1
                        SR <= {sub_res[15:7], SR[7:1], 1'b1};
                    end else begin
                        // subtraction negative: keep remainder, quotient bit = 0
                        SR <= {SR[15:0], 1'b0};
                    end

                    if (cnt == 4'd8) begin
                        // Division complete
                        start_cnt <= 1'b0;
                        cnt       <= 4'd0;

                        final_quotient  = SR[7:0];
                        final_remainder = SR[16:9];

                        // Adjust signs if signed operation
                        if (sign) begin
                            if (quotient_neg)
                                final_quotient = twos_comp8(final_quotient);
                            if (remainder_neg)
                                final_remainder = twos_comp8(final_remainder);
                        end

                        result    <= {final_remainder, final_quotient};
                        res_valid <= 1'b1;
                    end else begin
                        cnt <= cnt + 1'b1;
                    end
                end
            end else begin
                // Idle: clear res_valid if new opn_valid asserted (optional)
                if (res_valid && opn_valid)
                    res_valid <= 1'b0;
            end
        end
    end

endmodule