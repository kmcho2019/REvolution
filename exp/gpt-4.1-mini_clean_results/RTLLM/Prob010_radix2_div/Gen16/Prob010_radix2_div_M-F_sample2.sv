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

    reg [3:0] cnt;         // iteration counter (0 to 8)
    reg start;             // division in progress flag

    reg dividend_neg, divisor_neg;   // sign flags for input operands
    reg quotient_neg, remainder_neg; // sign flags for outputs

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift Register: {partial_remainder[8:0], quotient[7:0]} total 17 bits
    reg [16:0] SR;

    // partial remainder bits: SR[16:8], quotient bits: SR[7:0]
    wire signed [8:0] pr = SR[16:8];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 4'd0;
            start <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            SR <= 17'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Capture sign bits and calculate absolute values
                    dividend_neg <= sign & dividend[7];
                    divisor_neg <= sign & divisor[7];

                    dividend_abs <= (sign & dividend[7]) ? (~dividend + 1'b1) : dividend;
                    divisor_abs <= (sign & divisor[7]) ? (~divisor + 1'b1) : divisor;

                    quotient_neg <= sign & (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign & dividend[7];

                    // Initialize shift register:
                    // partial remainder = dividend_abs (8 bits) shifted left by 1 (9 bits)
                    // quotient = 0
                    SR <= {dividend_abs, 1'b0, 8'd0};

                    cnt <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division in progress

                // Shift partial remainder left by 1, bring in MSB of quotient as LSB of partial remainder
                // pr_shifted: left shift pr[8:0] by 1 with LSB as SR[7] (MSB of quotient)
                // pr_shifted is 10 bits (for intermediate calculation)
                reg signed [9:0] pr_shifted;
                reg signed [9:0] pr_next;
                reg next_qbit;

                pr_shifted = {pr[7:0], SR[7]};
                pr_shifted = {pr_shifted, 1'b0}; // shift left by 1 for next partial remainder calculation

                // Non-restoring division step:
                // If partial remainder >=0: subtract divisor_abs
                // else add divisor_abs
                if (pr[8] == 1'b0)       // pr >= 0
                    pr_next = $signed(pr_shifted) - $signed({1'b0, divisor_abs});
                else
                    pr_next = $signed(pr_shifted) + $signed({1'b0, divisor_abs});

                // Next quotient bit is 1 if pr_next >= 0, else 0
                next_qbit = (pr_next[9] == 1'b0) ? 1'b1 : 1'b0;

                // Update shift register:
                // partial remainder = pr_next[8:0]
                // quotient = shift left by 1 and insert next_qbit as LSB
                SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Final iteration done
                    // Apply correction if partial remainder negative
                    if (pr_next[9] == 1'b1) begin
                        // remainder negative: add divisor_abs back
                        SR[16:8] <= pr_next[8:0] + {1'b0, divisor_abs};
                    end else begin
                        SR[16:8] <= pr_next[8:0];
                    end

                    start <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign correction to quotient and remainder
                    if (quotient_neg)
                        result[7:0] <= (~SR[7:0] + 1'b1);
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_neg)
                        result[15:8] <= (~SR[16:9] + 1'b1);
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end

endmodule