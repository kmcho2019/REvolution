module radix2_div(
    input           clk,
    input           rst,
    input           sign,           // 1 = signed, 0 = unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    reg [8:0] SR;               // 9-bit shift register: upper bits remainder, lower bits quotient
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg sign_dividend;
    reg sign_divisor;
    reg sign_quotient;
    reg start_div;
    reg [3:0] cnt;              // count from 1 to 8
    reg divisor_zero;

    reg [8:0] sub_res;          // result of SR - divisor

    // Registers for final results and corrections
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;
    reg [8:0] remainder9;

    // Absolute value and sign extraction
    wire dividend_neg = sign & dividend[7];
    wire divisor_neg  = sign & divisor[7];

    wire [7:0] dividend_abs_val = dividend_neg ? (~dividend + 1'b1) : dividend;
    wire [7:0] divisor_abs_val  = divisor_neg  ? (~divisor  + 1'b1) : divisor;

    // Two's complement negation of divisor for subtraction: 9 bits
    wire [8:0] neg_divisor = {1'b0, ~abs_divisor} + 9'd1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid      <= 1'b0;
            SR             <= 9'd0;
            abs_dividend   <= 8'd0;
            abs_divisor    <= 8'd0;
            sign_dividend  <= 1'b0;
            sign_divisor   <= 1'b0;
            sign_quotient  <= 1'b0;
            start_div      <= 1'b0;
            cnt            <= 4'd0;
            divisor_zero   <= 1'b0;
            result         <= 16'd0;
            final_quotient <= 8'd0;
            final_remainder<= 8'd0;
            remainder9     <= 9'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Start new division
                abs_dividend  <= dividend_abs_val;
                abs_divisor   <= divisor_abs_val;
                sign_dividend <= dividend_neg;
                sign_divisor  <= divisor_neg;
                sign_quotient <= dividend_neg ^ divisor_neg;
                divisor_zero  <= (divisor == 8'd0);
                // Initialize shift register: dividend_abs shifted left by 1 bit (LSB zero)
                // SR[8:1] = dividend_abs, SR[0] = 0
                SR            <= {dividend_abs_val,1'b0};
                cnt           <= 4'd1;
                start_div     <= 1'b1;
                res_valid     <= 1'b0;
            end else if (start_div) begin
                if (divisor_zero) begin
                    // Division by zero: quotient = 0, remainder = dividend
                    final_quotient  <= 8'd0;
                    final_remainder <= abs_dividend;
                    // Apply sign correction for remainder if signed and dividend negative
                    if (sign && sign_dividend && abs_dividend != 8'd0)
                        final_remainder <= (~abs_dividend + 1'b1);
                    result      <= {final_remainder, final_quotient};
                    res_valid   <= 1'b1;
                    start_div   <= 1'b0;
                    cnt         <= 4'd0;
                end else if (cnt == 4'd8) begin
                    // Final iteration done
                    // Check remainder in SR[8:1], if negative add back divisor
                    remainder9 = SR;
                    if (remainder9[8] == 1'b1) begin
                        remainder9 = remainder9 + {1'b0, abs_divisor};
                    end
                    final_remainder = remainder9[8:1];
                    final_quotient  = SR[7:0];

                    // Signed correction
                    if (sign) begin
                        if (sign_quotient)
                            final_quotient = (~final_quotient) + 1'b1;
                        if (sign_dividend && (final_remainder != 8'd0))
                            final_remainder = (~final_remainder) + 1'b1;
                    end

                    result    <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                    start_div <= 1'b0;
                    cnt       <= 4'd0;
                end else begin
                    // Iterative division step
                    cnt <= cnt + 4'd1;

                    // Subtract divisor: SR + neg_divisor = SR - divisor
                    sub_res = SR + neg_divisor;

                    if (sub_res[8] == 1'b0) begin
                        // subtraction result >= 0
                        // Shift left and set quotient bit to 1 (LSB)
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // subtraction result < 0
                        // Restore SR and shift left quotient bit to 0
                        SR <= {SR[7:0], 1'b0};
                    end
                end
            end else if (res_valid && opn_valid) begin
                // If result valid and new op arrives, clear res_valid to accept new operation
                res_valid <= 1'b0;
            end
            // Else maintain stable state
        end
    end

endmodule