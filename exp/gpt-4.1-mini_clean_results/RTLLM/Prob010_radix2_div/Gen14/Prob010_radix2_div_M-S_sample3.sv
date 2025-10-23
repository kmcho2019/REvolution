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
    reg [16:0] SR;         // {partial_remainder[8:0], quotient[7:0]}

    wire signed [8:0] pr = SR[16:8];        // partial remainder (9 bits signed)
    wire signed [8:0] divisor_ext = {1'b0, divisor_abs}; // divisor extended to 9 bits unsigned treated as signed

    reg signed [9:0] pr_shifted;    // partial remainder shifted left by 1 and incorporate quotient MSB
    reg signed [9:0] pr_next;       // next partial remainder after add/sub
    reg next_qbit;                  // next quotient bit

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            start <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            dividend_abs <= 0;
            divisor_abs <= 0;
            SR <= 17'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Capture signs and compute absolute values
                    dividend_neg <= sign && dividend[7];
                    divisor_neg <= sign && divisor[7];

                    dividend_abs <= (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
                    divisor_abs <= (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

                    quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                    remainder_neg <= (sign && dividend[7]);

                    // Initialize shift register: {partial remainder(9 bits), quotient(8 bits)}
                    // partial remainder initialized with dividend_abs shifted left 1 (9 bits)
                    SR <= {dividend_abs, 1'b0, 8'd0}; // {dividend_abs[7:0], 1'b0, 8'd0}

                    cnt <= 0;
                    start <= 1'b1;
                end
            end else begin
                // Division in progress
                // Shift left SR by 1: partial remainder and quotient shift, incorporate old quotient MSB into partial remainder LSB
                pr_shifted = {pr[7:0], SR[7]}; // pr is 9 bits: pr[8] is sign bit, shift left by 1 discarding MSB pr[8], bring in quotient MSB SR[7] as LSB
                pr_shifted = {pr_shifted, 1'b0}; // shifting to 10 bits for add/sub, lowest bit zero

                // Actually, non-restoring division logic:
                // If pr (partial remainder) >= 0, subtract divisor; else add divisor.
                if (pr[8] == 0) // pr >= 0
                    pr_next = $signed(pr_shifted) - $signed({1'b0, divisor_abs});
                else
                    pr_next = $signed(pr_shifted) + $signed({1'b0, divisor_abs});

                // Next quotient bit: 1 if pr_next >= 0, else 0
                next_qbit = (pr_next[9] == 0) ? 1'b1 : 1'b0;

                // Update SR with pr_next[8:0] as new partial remainder and shift quotient left by 1 plus next_qbit
                SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};

                cnt <= cnt + 1;

                if (cnt == 7) begin
                    // After last iteration
                    // Final correction: if partial remainder negative, add divisor back
                    if (pr_next[9] == 1) begin
                        SR[16:8] <= pr_next[8:0] + {1'b0, divisor_abs};
                    end else begin
                        SR[16:8] <= pr_next[8:0];
                    end
                    start <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign correction
                    // quotient correction
                    if (quotient_neg)
                        result[7:0] <= (~SR[7:0] + 1'b1);
                    else
                        result[7:0] <= SR[7:0];

                    // remainder correction
                    if (remainder_neg)
                        result[15:8] <= (~SR[16:9] + 1'b1);
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end

endmodule