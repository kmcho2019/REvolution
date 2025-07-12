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

    reg start;              // division operation in progress
    reg [3:0] cnt;          // iteration counter (0 to 8)
    reg [16:0] SR;          // Shift register: {remainder[8:0], quotient[7:0]} total 17 bits

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;

    wire [9:0] sub_res;     // remainder - divisor
    wire borrow;

    // Subtraction: remainder (9 bits) minus divisor_abs (8 bits extended)
    assign sub_res = {1'b0, SR[16:8]} - {1'b0, divisor_abs};
    assign borrow = sub_res[9];  // borrow = 1 means remainder < divisor_abs, subtraction fails

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid   <= 1'b0;
            start       <= 1'b0;
            cnt         <= 4'd0;
            SR          <= 17'd0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg<= 1'b0;
            remainder_neg<=1'b0;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            result      <= 16'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Compute absolute values and signs
                    if (sign && dividend[7]) begin
                        dividend_abs <= (~dividend) + 1'b1;
                        dividend_neg <= 1'b1;
                    end else begin
                        dividend_abs <= dividend;
                        dividend_neg <= 1'b0;
                    end

                    if (sign && divisor[7]) begin
                        divisor_abs <= (~divisor) + 1'b1;
                        divisor_neg <= 1'b1;
                    end else begin
                        divisor_abs <= divisor;
                        divisor_neg <= 1'b0;
                    end

                    quotient_neg  <= (sign && (dividend[7] ^ divisor[7]));
                    remainder_neg <= (sign && dividend[7]);

                    // Initialize SR:
                    // remainder = 0 (9 bits), quotient = dividend_abs (8 bits)
                    // SR = {remainder[8:0], quotient[7:0]}
                    SR <= {9'd0, dividend_abs};

                    cnt <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division step
                // Shift left SR by 1 bit (combined remainder and quotient)
                // Try subtraction: remainder - divisor_abs
                if (!borrow) begin
                    // Subtraction succeeded
                    // remainder = sub_res[8:0], quotient bit = 1
                    SR <= {sub_res[8:0], SR[7:1], 1'b1};
                end else begin
                    // Subtraction failed
                    // remainder unchanged, quotient bit = 0
                    SR <= {SR[16:8]<<1 | SR[7], SR[7:1], 1'b0};
                end

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // After 8 iterations, division completes
                    start <= 1'b0;
                    res_valid <= 1'b1;
                end
            end

            // Output result when valid
            if (res_valid) begin
                // Extract raw quotient and remainder
                // remainder = SR[16:8], quotient = SR[7:0]
                // Apply sign corrections if signed division

                reg [7:0] quotient_raw;
                reg [8:0] remainder_raw9;  // 9-bit remainder before sign correction
                reg [7:0] remainder_raw;   // truncated to 8 bits for output

                reg [7:0] quotient_corr;
                reg [7:0] remainder_corr;

                quotient_raw = SR[7:0];
                remainder_raw9 = SR[16:8];

                // Truncate remainder to 8 bits for output; high bit is discarded (sign bit)
                // If remainder negative sign correction required, the 9th bit (SR[16]) is not used for output
                remainder_raw = remainder_raw9[7:0];

                if (sign) begin
                    // Quotient sign correction
                    if (quotient_neg)
                        quotient_corr = (~quotient_raw) + 1'b1;
                    else
                        quotient_corr = quotient_raw;

                    // Remainder sign correction
                    if (remainder_neg)
                        remainder_corr = (~remainder_raw) + 1'b1;
                    else
                        remainder_corr = remainder_raw;
                end else begin
                    quotient_corr = quotient_raw;
                    remainder_corr = remainder_raw;
                end

                result <= {remainder_corr, quotient_corr};
            end
        end
    end

endmodule