module radix2_div(
    input             clk,
    input             rst,
    input             sign,           // 1: signed div, 0: unsigned div
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result           // {remainder[7:0], quotient[7:0]}
);

    // Division in progress flag
    reg busy;

    // Counter for division steps: 0 to 8
    reg [3:0] cnt;

    // Absolute values and sign flags for inputs
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg dividend_neg, divisor_neg;

    // Final sign for quotient and remainder
    reg quotient_neg;
    reg remainder_neg;

    // 9-bit remainder register (one extra bit for shifts)
    reg [8:0] rem;

    // 8-bit quotient register
    reg [7:0] quot;

    // Internal signals for subtraction and comparison
    wire [8:0] rem_shifted;
    wire [8:0] sub_res;
    wire       rem_ge_div; // remainder >= divisor_abs

    // Combinational logic: remainder shifted left by 1
    assign rem_shifted = {rem[7:0], 1'b0};

    // Combinational subtraction: rem_shifted[8:1] - divisor_abs
    assign sub_res = {1'b0, rem_shifted[8:1]} - {1'b0, divisor_abs};

    // Check if remainder >= divisor_abs
    assign rem_ge_div = (rem_shifted[8:1] >= divisor_abs);

    // Sequential process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid     <= 1'b0;
            busy          <= 1'b0;
            cnt           <= 4'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;
            rem           <= 9'd0;
            quot          <= 8'd0;
            result        <= 16'd0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;

                if (opn_valid) begin
                    // Latch inputs and signs
                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg  <= divisor[7];

                        // abs with 2's complement if negative
                        dividend_abs <= dividend[7] ? (~dividend + 1'b1) : dividend;
                        divisor_abs  <= divisor[7]  ? (~divisor + 1'b1)  : divisor;

                        // quotient sign = dividend sign xor divisor sign
                        quotient_neg <= dividend[7] ^ divisor[7];

                        // remainder sign = dividend sign
                        remainder_neg <= dividend[7];
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg <= 1'b0;
                        dividend_abs <= dividend;
                        divisor_abs <= divisor;
                        quotient_neg <= 1'b0;
                        remainder_neg <= 1'b0;
                    end

                    // Initialize remainder: dividend_abs with 0 LSB (9 bits)
                    rem <= {1'b0, dividend_abs};

                    // Clear quotient and count
                    quot <= 8'd0;
                    cnt <= 4'd0;

                    busy <= 1'b1;
                end
            end else begin
                // Division process iteration
                // Shift remainder left by 1 bit (already done via rem_shifted)
                // Try subtract divisor_abs from remainder portion
                if (rem_ge_div) begin
                    // remainder >= divisor_abs: subtraction success
                    rem <= {sub_res[7:0], 1'b1}; // remainder updated with subtracted value, LSB=1 quotient bit
                    quot <= {quot[6:0], 1'b1};
                end else begin
                    // subtraction fails: keep remainder_shifted as is, quotient bit=0
                    rem <= rem_shifted;
                    quot <= {quot[6:0], 1'b0};
                end

                // Increment iteration count
                cnt <= cnt + 1'b1;

                // Check if done
                if (cnt == 4'd7) begin
                    // Division complete after 8 iterations (0 to 7)
                    busy <= 1'b0;

                    // Apply sign correction at the end
                    // Quotient negated if quotient_neg==1
                    // Remainder negated if remainder_neg==1
                    // For negation, use two's complement

                    // Prepare signed quotient
                    if (quotient_neg)
                        quot <= (~quot + 1'b1);
                    // Prepare signed remainder
                    if (remainder_neg)
                        rem[8:1] <= (~rem[8:1] + 1'b1);

                    // Pack output: remainder[7:0], quotient[7:0]
                    result <= {rem[8:1], quot};
                    res_valid <= 1'b1;
                end
            end
        end
    end

endmodule