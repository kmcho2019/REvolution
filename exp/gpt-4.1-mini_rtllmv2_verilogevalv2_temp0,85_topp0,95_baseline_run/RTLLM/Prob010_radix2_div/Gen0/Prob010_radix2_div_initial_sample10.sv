module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [8:0] SR;          // Shift register holding remainder + quotient (9 bits: remainder 8 bits + 1 bit quotient)
    reg [7:0] NEG_DIVISOR; // Two's complement of divisor absolute value
    reg [3:0] cnt;         // 4-bit counter to count up to 8 (max 8 iterations)
    reg start_cnt;         // Indicates division process active
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    // Wires for subtraction result
    wire [8:0] sub_res;
    wire       sub_carry_out;

    // Compute subtraction: SR[8:1] - NEG_DIVISOR = remainder - divisor
    assign {sub_carry_out, sub_res} = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR};

    // Absolute value computation for signed operands
    always @(*) begin
        if (sign) begin
            dividend_neg = dividend[7];
            divisor_neg = divisor[7];
            abs_dividend = dividend_neg ? (~dividend + 1) : dividend;
            abs_divisor  = divisor_neg  ? (~divisor  + 1) : divisor;
        end else begin
            dividend_neg = 1'b0;
            divisor_neg = 1'b0;
            abs_dividend = dividend;
            abs_divisor  = divisor;
        end
        quotient_neg = dividend_neg ^ divisor_neg;
        remainder_neg = dividend_neg;
    end

    // NEG_DIVISOR = -abs_divisor
    always @(*) begin
        NEG_DIVISOR = ~abs_divisor + 1'b1;
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 9'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            // Start new operation
            if (opn_valid && !res_valid) begin
                // Initialize shift register with dividend abs shifted left by 1 (multiply by 2)
                SR <= {abs_dividend, 1'b0};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process ongoing
                if (cnt == 4'd8) begin
                    // Last iteration done, finalize
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    // SR[8:1] contains final remainder (signed abs)
                    // SR[0] is last quotient bit, but quotient is in SR[7:0] after shifts
                    // Assemble quotient and remainder from SR
                    // Quotient is in SR[7:0] (lowest 8 bits)
                    // Remainder in SR[8:1] (8 bits)
                    // Adjust sign of quotient and remainder if needed

                    // Reconstruct quotient
                    // Quotient is bits SR[7:0]
                    // Remainder is bits SR[8:1]

                    // Apply sign to quotient
                    // If quotient_neg, quotient = -quotient_abs
                    // Else quotient = quotient_abs

                    // Apply sign to remainder
                    // If remainder_neg, remainder = -remainder_abs
                    // Else remainder = remainder_abs

                    // Convert back to signed 8-bit
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Use variables to hold abs values
                    reg [7:0] quotient_abs;
                    reg [7:0] remainder_abs;

                    quotient_abs = SR[7:0];
                    remainder_abs = SR[8:1];

                    // Sign-correct quotient
                    if (sign && quotient_neg)
                        final_quotient = ~quotient_abs + 1'b1;
                    else
                        final_quotient = quotient_abs;

                    // Sign-correct remainder
                    if (sign && remainder_neg)
                        final_remainder = ~remainder_abs + 1'b1;
                    else
                        final_remainder = remainder_abs;

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;

                end else begin
                    // cnt < 8, continue division step
                    cnt <= cnt + 1;

                    // Decide next SR based on subtraction carry out
                    // If sub_carry_out == 1 (no borrow), set next quotient bit to 1 and update remainder to sub_res
                    // Else quotient bit = 0, remainder unchanged (SR[8:1])
                    if (sub_carry_out) begin
                        // Update SR: {sub_res[7:0], quotient_bit=1}
                        SR <= {sub_res[7:0], SR[0], 1'b1}; // Will be shifted left below
                    end else begin
                        // Update SR: {SR[8:1], quotient_bit=0}
                        SR <= {SR[8:1], SR[0], 1'b0}; // Will be shifted left below
                    end

                    // Shift left SR by 1 bit to prepare for next iteration (left shift with quotient bit entering LSB)
                    // But in radix-2 division, the shift left is actually done when loading the next bit of quotient
                    // However, since SR is 9 bits, we can implement the shift after updating the quotient bit:
                    // Actually, the above assignments already shift bits accordingly:
                    // - The MSB part is sub_res[7:0] or SR[8:1]
                    // - The LSB part is the quotient bit (1 or 0)
                    // To implement one shift left, we do:
                    // SR <= {SR[7:0], 1'b0};

                    // After reviewing the design, the shift operation can be done as follows:

                    // Actually, the approach is to shift SR left by 1 each cycle, introducing quotient bit at LSB
                    // We implemented this by assigning SR <= {remainder_or_sub_result, quotient_bit}
                    // Then left shift by 1 is effectively done.

                    // Therefore, no additional shift needed here.

                end
            end else if (res_valid) begin
                // Wait for new opn_valid to clear res_valid
                if (!opn_valid) begin
                    res_valid <= 1'b0;
                end
            end else begin
                // Idle
                SR <= SR;
                cnt <= cnt;
                start_cnt <= start_cnt;
                res_valid <= res_valid;
                result <= result;
            end
        end
    end

endmodule