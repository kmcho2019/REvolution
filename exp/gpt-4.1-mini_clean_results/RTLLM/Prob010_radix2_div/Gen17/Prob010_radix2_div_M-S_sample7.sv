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

    reg [7:0] dividend_abs, divisor_abs;

    // Shift register: {partial_remainder[8:0], quotient[7:0]} total 17 bits
    reg [16:0] SR;

    wire signed [8:0] partial_remainder = SR[16:8];
    wire [7:0] quotient = SR[7:0];

    // For subtraction step:
    wire signed [9:0] remainder_shifted = {partial_remainder[7:0], quotient[7]};
    reg signed [9:0] sub_res;
    reg next_quot_bit;

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
                if (opn_valid && !res_valid) begin
                    // Capture sign flags
                    dividend_neg <= sign & dividend[7];
                    divisor_neg <= sign & divisor[7];
                    // Absolute values
                    dividend_abs <= (sign & dividend[7]) ? (~dividend + 1) : dividend;
                    divisor_abs <= (sign & divisor[7]) ? (~divisor + 1) : divisor;
                    quotient_neg <= sign & (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign & dividend[7];
                    // Initialize SR: remainder = dividend_abs, shifted left by 1 to make 9 bits
                    SR <= {9'd0, 8'd0};
                    SR[16:8] <= {dividend_abs, 1'b0}; // partial remainder (9 bits)
                    SR[7:0] <= 8'd0; // quotient
                    cnt <= 0;
                    start <= 1;
                end
            end else begin
                // Division step
                // Shift partial remainder left by 1, bring in next quotient bit (from left shift of quotient)
                // remainder_shifted is 10 bits: {partial_remainder[7:0], quotient[7]}
                if (partial_remainder[8] == 0)
                    sub_res = remainder_shifted - {1'b0, divisor_abs};
                else
                    sub_res = remainder_shifted + {1'b0, divisor_abs};

                // Next quotient bit: 1 if sub_res >=0 else 0
                next_quot_bit = (sub_res[9] == 0) ? 1'b1 : 1'b0;

                // Update SR:
                // partial remainder: sub_res[8:0]
                // quotient: shift left by 1, insert next_quot_bit
                SR <= {sub_res[8:0], (SR[7:0] << 1) | next_quot_bit};

                cnt <= cnt + 1;

                if (cnt == 7) begin
                    // Last cycle: correct remainder if negative
                    if (sub_res[9] == 1) // negative remainder
                        SR[16:8] <= sub_res[8:0] + {1'b0, divisor_abs};
                    else
                        SR[16:8] <= sub_res[8:0];

                    start <= 0;
                    res_valid <= 1;

                    // Apply sign corrections
                    if (quotient_neg)
                        result[7:0] <= (~SR[7:0] + 1);
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_neg)
                        result[15:8] <= (~SR[16:9] + 1);
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end

endmodule