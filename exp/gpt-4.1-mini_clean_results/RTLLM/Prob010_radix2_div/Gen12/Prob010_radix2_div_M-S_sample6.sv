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
    reg [3:0] cnt;          // count 8 iterations
    reg [16:0] SR;          // {remainder[8:0], quotient[7:0]}
    reg [8:0] divisor_abs;  // absolute divisor extended 9 bits

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_val;

    // Wires for subtraction
    wire [9:0] sub_res;
    wire borrow;

    // Assign subtraction: remainder - divisor_abs
    assign sub_res = {1'b0, SR[16:8]} - {1'b0, divisor_abs};
    assign borrow = sub_res[9];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid   <= 1'b0;
            start       <= 1'b0;
            cnt         <= 4'd0;
            SR          <= 17'd0;
            divisor_abs <= 9'd0;
            dividend_abs<= 8'd0;
            divisor_val <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            result      <= 16'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Capture inputs and signs
                    if (sign && dividend[7]) begin
                        dividend_abs <= (~dividend) + 1'b1;
                        dividend_neg <= 1'b1;
                    end else begin
                        dividend_abs <= dividend;
                        dividend_neg <= 1'b0;
                    end
                    if (sign && divisor[7]) begin
                        divisor_val <= (~divisor) + 1'b1;
                        divisor_neg <= 1'b1;
                    end else begin
                        divisor_val <= divisor;
                        divisor_neg <= 1'b0;
                    end

                    quotient_neg  <= (sign && (dividend[7] ^ divisor[7]));
                    remainder_neg <= (sign && dividend[7]);

                    divisor_abs <= {1'b0, (sign ? ((divisor[7]) ? ((~divisor)+1'b1) : divisor) : divisor)};
                    // Initialize SR: remainder=0 (9 bits), quotient=dividend_abs (8 bits)
                    SR <= {9'd0, dividend_abs};

                    cnt <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division process
                // Shift left SR by 1
                SR <= (borrow == 0) ?
                    {sub_res[8:0], SR[7:1], 1'b1} :        // subtraction succeeded, quotient bit=1
                    {SR[16:8]<<1 | SR[7], SR[7:1], 1'b0}; // subtraction failed, quotient bit=0

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin // After 8 iterations (0..7)
                    start <= 1'b0;
                    res_valid <= 1'b1;
                end
            end

            // Output result when ready
            if (res_valid) begin
                // Extract raw quotient and remainder
                // Remainder: SR[16:8], Quotient: SR[7:0]
                // Apply sign corrections
                reg [7:0] quotient_raw;
                reg [7:0] remainder_raw;
                reg [7:0] quotient_corr;
                reg [7:0] remainder_corr;

                quotient_raw = SR[7:0];
                remainder_raw = SR[15:8]; // discard SR[16], as remainder is 9-bit but quotient bits are lower 8

                if (sign) begin
                    // Quotient correction
                    if (quotient_neg)
                        quotient_corr = (~quotient_raw) + 1'b1;
                    else
                        quotient_corr = quotient_raw;

                    // Remainder correction
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