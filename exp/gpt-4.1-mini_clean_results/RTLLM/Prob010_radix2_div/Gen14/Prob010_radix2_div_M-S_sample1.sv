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

    reg start;
    reg [3:0] cnt;
    reg [17:0] SR;            // {remainder[8:0], quotient[8:0]} but quotient only 8 bits used, 1 MSB zero padded

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;

    wire [9:0] sub_res;       // 10-bit to hold subtraction with borrow
    wire borrow;

    // Subtract divisor_abs from remainder (9 bits)
    assign sub_res = {1'b0, SR[17:9]} - {1'b0, divisor_abs};
    assign borrow = sub_res[9];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid    <= 1'b0;
            start        <= 1'b0;
            cnt          <= 4'd0;
            SR           <= 18'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            result       <= 16'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Compute absolute values if signed; else use as-is
                    if (sign && dividend[7]) begin
                        dividend_abs <= ~dividend + 1'b1;
                        dividend_neg <= 1'b1;
                    end else begin
                        dividend_abs <= dividend;
                        dividend_neg <= 1'b0;
                    end

                    if (sign && divisor[7]) begin
                        divisor_abs <= ~divisor + 1'b1;
                        divisor_neg <= 1'b1;
                    end else begin
                        divisor_abs <= divisor;
                        divisor_neg <= 1'b0;
                    end

                    quotient_neg  <= sign && (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign && dividend[7];

                    // Initialize SR: remainder=0 (9 bits), quotient=dividend_abs (8 bits), extra 0 bit for shift logic
                    SR <= {9'd0, dividend_abs, 1'b0};

                    cnt   <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division iteration
                if (!borrow) begin
                    // Successful subtraction: remainder = remainder - divisor_abs
                    // Shift left SR by 1, set LSB quotient bit to 1
                    SR <= {sub_res[8:0], SR[8:0], 1'b1};
                end else begin
                    // Failed subtraction: shift left SR, quotient bit = 0
                    SR <= {SR[16:0], 1'b0};
                end

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // End of division process after 8 steps
                    start <= 1'b0;
                    res_valid <= 1'b1;
                end
            end

            if (res_valid) begin
                // Extract quotient and remainder
                // SR[17:9]: remainder (9 bits), SR[8:1]: quotient (8 bits), SR[0] extra bit not part of output
                reg [8:0] rem_raw;
                reg [7:0] quo_raw;
                reg [7:0] quo_corr;
                reg [7:0] rem_corr;

                rem_raw = SR[17:9];
                quo_raw = SR[8:1];

                // Sign correction if needed
                if (sign) begin
                    quo_corr = quotient_neg ? (~quo_raw + 1'b1) : quo_raw;
                    rem_corr = remainder_neg ? (~rem_raw[7:0] + 1'b1) : rem_raw[7:0];
                end else begin
                    quo_corr = quo_raw;
                    rem_corr = rem_raw[7:0];
                end

                result <= {rem_corr, quo_corr};
            end
        end
    end

endmodule