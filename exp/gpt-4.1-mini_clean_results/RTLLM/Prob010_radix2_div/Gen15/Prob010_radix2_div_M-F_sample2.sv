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

    // Partial remainder and divisor extended to 9 bits
    wire signed [8:0] pr = SR[16:8];
    wire signed [8:0] divisor_ext = {1'b0, divisor_abs};

    reg signed [9:0] pr_shifted;    // partial remainder shifted left by 1 and incorporate quotient MSB
    reg signed [9:0] pr_next;       // next partial remainder after add/sub
    reg next_qbit;                  // next quotient bit

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

                    // Initialize shift register with dividend_abs shifted left by 1 for partial remainder,
                    // and quotient = 0
                    // SR = {partial_remainder[8:0], quotient[7:0]} 
                    // partial remainder initialized to dividend_abs << 1 (9 bits)
                    SR <= {dividend_abs, 1'b0, 8'd0};

                    cnt <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division in progress
                // Shift partial remainder left by 1 and insert quotient MSB as LSB of partial remainder
                // pr = SR[16:8] is signed 9-bit partial remainder
                pr_shifted = {pr[7:0], SR[7]}; // shift left by 1 dropping MSB pr[8], add quotient MSB SR[7] as LSB
                pr_shifted = {pr_shifted, 1'b0}; // extend to 10 bits (lowest bit zero)

                // Non-restoring division step:
                // If partial remainder >= 0, subtract divisor_abs; else add divisor_abs
                if (pr[8] == 1'b0)       // partial remainder non-negative
                    pr_next = $signed(pr_shifted) - $signed({1'b0, divisor_abs});
                else                    // partial remainder negative
                    pr_next = $signed(pr_shifted) + $signed({1'b0, divisor_abs});

                // Next quotient bit is 1 if pr_next >= 0, else 0
                next_qbit = (pr_next[9] == 1'b0) ? 1'b1 : 1'b0;

                // Update shift register with new partial remainder and shifted quotient + next_qbit
                SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Final iteration done: apply correction if partial remainder negative
                    if (pr_next[9] == 1'b1) begin
                        // remainder negative => add divisor back
                        SR[16:8] <= pr_next[8:0] + {1'b0, divisor_abs};
                    end else begin
                        SR[16:8] <= pr_next[8:0];
                    end

                    start <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign correction to quotient and remainder
                    // Quotient correction
                    if (quotient_neg)
                        result[7:0] <= (~SR[7:0] + 1'b1);
                    else
                        result[7:0] <= SR[7:0];

                    // Remainder correction
                    if (remainder_neg)
                        result[15:8] <= (~SR[16:9] + 1'b1);
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end

endmodule