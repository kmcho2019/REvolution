module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);
    reg [3:0] cnt;
    reg start;

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift register: {partial_remainder[8:0], quotient[7:0]} total 17 bits
    reg [16:0] SR;

    wire signed [8:0] partial_rem = SR[16:8];
    wire signed [8:0] divisor_ext = {1'b0, divisor_abs};

    reg signed [9:0] pr_shift;  // partial remainder shifted left by 1
    reg signed [9:0] pr_next;   // after add/sub
    reg next_qbit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            start <= 0;
            res_valid <= 0;
            result <= 0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            dividend_abs <= 0;
            divisor_abs <= 0;
            SR <= 0;
        end else begin
            if (!start) begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_neg <= sign & dividend[7];
                    divisor_neg <= sign & divisor[7];
                    dividend_abs <= (sign & dividend[7]) ? (~dividend + 1) : dividend;
                    divisor_abs <= (sign & divisor[7]) ? (~divisor + 1) : divisor;
                    quotient_neg <= sign & (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign & dividend[7];
                    // Initialize SR: partial remainder is dividend_abs shifted left by 1 (9 bits), quotient zero
                    SR <= {dividend_abs, 1'b0, 8'd0};
                    cnt <= 0;
                    start <= 1;
                end
            end else begin
                // Shift partial remainder left by 1, insert MSB of quotient as LSB of partial remainder
                pr_shift = {partial_rem[7:0], SR[7]};
                pr_shift = {pr_shift, 1'b0}; // extend to 10 bits with LSB 0

                // If partial remainder >= 0, subtract divisor; else add divisor
                if (partial_rem[8] == 0)
                    pr_next = $signed(pr_shift) - $signed({1'b0, divisor_abs});
                else
                    pr_next = $signed(pr_shift) + $signed({1'b0, divisor_abs});

                next_qbit = (pr_next[9] == 0) ? 1'b1 : 1'b0;

                // Update SR: new partial remainder and quotient shifted left + next_qbit
                SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};

                cnt <= cnt + 1;

                if (cnt == 7) begin
                    // After last iteration, if remainder negative add divisor back
                    if (pr_next[9]) // negative
                        SR[16:8] <= pr_next[8:0] + {1'b0, divisor_abs};
                    else
                        SR[16:8] <= pr_next[8:0];

                    start <= 0;
                    res_valid <= 1;

                    // Apply sign corrections
                    if (quotient_neg)
                        result[7:0] <= ~SR[7:0] + 1;
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_neg)
                        result[15:8] <= ~SR[16:9] + 1;
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end
endmodule