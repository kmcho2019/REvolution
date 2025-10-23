module radix2_div (
    input              clk,
    input              rst,
    input              sign,           // 1: signed division, 0: unsigned division
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result          // {remainder[7:0], quotient[7:0]}
);

    // Internal signals and registers
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_neg, divisor_neg;
    reg       quotient_neg, remainder_neg;

    reg [16:0] SR;            // {remainder[8:0], quotient[7:0]} 17-bit shift reg
    reg [3:0]  count;         // iteration count 0..8
    reg        running;       // division process active flag

    wire [8:0] remainder = SR[16:8];
    wire [7:0] quotient  = SR[7:0];

    // Subtraction: remainder - divisor_abs
    wire signed [9:0] sub = {1'b0, remainder} - {1'b0, divisor_abs};
    wire sub_non_neg = ~sub[9]; // MSB borrow bit, 0 means no borrow = non-negative

    // Control FSM logic embedded in sequential logic with 'running' and 'count'

    // Abs and sign extraction on operation start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            count <= 4'd0;
            running <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if (!running) begin
                // Waiting for new operation to start
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    // Latch inputs and preprocess signs if signed
                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg <= divisor[7];
                        dividend_abs <= dividend[7] ? (~dividend + 1'b1) : dividend;
                        divisor_abs <= divisor[7] ? (~divisor + 1'b1) : divisor;
                        quotient_neg <= dividend[7] ^ divisor[7];
                        remainder_neg <= dividend[7];
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg <= 1'b0;
                        dividend_abs <= dividend;
                        divisor_abs <= divisor;
                        quotient_neg <= 1'b0;
                        remainder_neg <= 1'b0;
                    end
                    // Initialize SR: remainder = dividend_abs << 1 (9 bits), quotient = 0
                    SR <= {dividend_abs, 1'b0, 8'd0};
                    count <= 4'd0;
                    running <= 1'b1;
                end
            end else begin
                // Division running
                // Shift left by 1 (shift remainder and quotient left, quotient's LSB will be set conditionally)
                SR <= {SR[15:0], 1'b0};

                // After shift, remainder part is SR[16:8]
                // Check subtraction: remainder - divisor_abs
                if (sub_non_neg) begin
                    // If subtraction >= 0, update remainder field and set quotient bit to 1
                    // Update remainder with subtraction result
                    SR[16:8] <= sub[8:0];
                    // Set quotient LSB (bit 0) to 1
                    SR[0] <= 1'b1;
                end else begin
                    // Else, keep remainder unchanged (due to shift left we already updated remainder),
                    // quotient bit remains 0 (already zero by shift in)
                    // Restore remainder to previous (No subtraction update needed)
                    // Actually, we shifted in 0 by default, so no need to revert remainder field.
                    // We'll keep SR as is.
                end

                count <= count + 1'b1;

                if (count == 4'd7) begin
                    // Last iteration complete this clock, next clock will finish
                    running <= 1'b0;

                    // Final correction for signs:
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    final_quotient = SR[7:0];
                    final_remainder = SR[16:9]; // remainder is 9 bits, MSB is extra bit, keep bits [16:9] (8 bits)

                    // Handle sign correction on result if signed operation
                    if (sign) begin
                        if (quotient_neg)
                            final_quotient = (~final_quotient + 8'd1);
                        if (remainder_neg)
                            final_remainder = (~final_remainder + 8'd1);
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end
            end
        end
    end

endmodule