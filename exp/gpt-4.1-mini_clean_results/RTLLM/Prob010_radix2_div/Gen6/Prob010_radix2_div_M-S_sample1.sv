module radix2_div(
    input             clk,
    input             rst,
    input             sign,          // 1 = signed, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       sign_quotient, sign_remainder;
    reg [16:0] SR;    // {9-bit remainder, 8-bit quotient}
    reg [3:0] count;
    reg       busy;

    wire [7:0] dividend_abs = (sign && dividend_neg) ? (~dividend_reg + 1) : dividend_reg;
    wire [7:0] divisor_abs  = (sign && divisor_neg)  ? (~divisor_reg + 1)  : divisor_reg;

    wire [8:0] remainder = SR[16:8];
    wire [8:0] sub_res = remainder - {1'b0, divisor_abs};
    wire       sub_ok = ~sub_res[8]; // no borrow if MSB=0

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            result <= 0;
            SR <= 0;
            count <= 0;
            busy <= 0;
            dividend_reg <= 0;
            divisor_reg <= 0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            sign_quotient <= 0;
            sign_remainder <= 0;
        end else begin
            if (!busy && opn_valid && !res_valid) begin
                // Capture inputs and signs
                dividend_reg <= dividend;
                divisor_reg <= divisor;
                dividend_neg <= sign ? dividend[7] : 0;
                divisor_neg  <= sign ? divisor[7]  : 0;
                sign_quotient <= sign ? (dividend[7] ^ divisor[7]) : 0;
                sign_remainder <= sign ? dividend[7] : 0;

                // Initialize SR: remainder = dividend_abs << 1, quotient = 0
                SR <= {1'b0, dividend_abs, 8'd0};
                count <= 0;
                res_valid <= 0;
                busy <= 1;
            end else if (busy) begin
                // Iterative division step
                if (count < 8) begin
                    // Subtract divisor from remainder
                    if (sub_ok)
                        SR <= {sub_res[7:0], SR[7:1], 1'b1}; // remainder updated, quotient bit=1
                    else
                        SR <= {remainder[7:0], SR[7:1], 1'b0}; // quotient bit=0
                    count <= count + 1;
                end else begin
                    // Division done, sign correction
                    busy <= 0;

                    // Correct quotient sign
                    if (sign_quotient)
                        result[7:0] <= (~SR[7:0] + 1);
                    else
                        result[7:0] <= SR[7:0];

                    // Correct remainder sign
                    if (sign_remainder)
                        result[15:8] <= (~SR[16:9] + 1);
                    else
                        result[15:8] <= SR[16:9];

                    res_valid <= 1;
                end
            end else if (res_valid && opn_valid) begin
                // New operation requested, clear res_valid to accept new inputs next cycle
                res_valid <= 0;
            end
        end
    end

endmodule