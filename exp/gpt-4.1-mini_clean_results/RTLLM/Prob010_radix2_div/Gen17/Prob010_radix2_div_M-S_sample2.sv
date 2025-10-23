module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    reg [3:0] cnt;
    reg start;
    reg [8:0] remainder;        // 9-bit remainder for shift and subtract
    reg [7:0] dividend_reg;     // holds dividend bits shifted in
    reg [8:0] divisor_abs;      // 9-bit absolute divisor
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] quotient;

    // Temporary subtraction result
    reg signed [9:0] sub_res;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt         <= 0;
            start       <= 0;
            remainder   <= 0;
            dividend_reg<= 0;
            divisor_abs <= 0;
            dividend_neg<= 0;
            divisor_neg <= 0;
            quotient_neg<= 0;
            remainder_neg <= 0;
            quotient    <= 0;
            result      <= 0;
            res_valid   <= 0;
        end else begin
            if (!start) begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Determine sign and absolute values
                    dividend_neg <= sign && dividend[7];
                    divisor_neg  <= sign && divisor[7];
                    quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                    remainder_neg<= sign && dividend[7];

                    // Convert to absolute values
                    dividend_reg <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                    divisor_abs  <= (sign && divisor[7]) ? ({1'b0, (~divisor + 1)}) : {1'b0, divisor};

                    remainder   <= 9'd0;
                    quotient    <= 8'd0;
                    cnt         <= 0;
                    start       <= 1;
                end
            end else begin
                // Shift left remainder and shift in next dividend bit
                remainder <= {remainder[7:0], dividend_reg[7]};
                dividend_reg <= {dividend_reg[6:0], 1'b0};

                // Compute remainder - divisor_abs
                sub_res = $signed({1'b0, remainder}) - $signed(divisor_abs);

                if (sub_res >= 0) begin
                    remainder <= sub_res[8:0];    // Update remainder
                    quotient  <= {quotient[6:0], 1'b1};
                end else begin
                    // Restore remainder, quotient bit = 0
                    // remainder already shifted in above, no subtraction update
                    quotient  <= {quotient[6:0], 1'b0};
                end

                cnt <= cnt + 1;

                if (cnt == 4'd7) begin
                    // Done after 8 cycles (cnt from 0 to 7)
                    // Correct signs of quotient and remainder

                    reg [7:0] q_abs, r_abs;
                    q_abs = quotient;
                    r_abs = remainder[7:0]; // remainder is 9 bits, top bit unused or sign

                    if (quotient_neg)
                        q_abs = ~q_abs + 1;

                    if (remainder_neg)
                        r_abs = ~r_abs + 1;

                    result <= {r_abs, q_abs};
                    res_valid <= 1;

                    start <= 0; // Ready for next operation
                end
            end
        end
    end

endmodule