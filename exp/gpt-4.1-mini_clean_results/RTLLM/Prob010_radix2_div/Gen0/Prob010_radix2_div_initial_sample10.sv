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

    reg [7:0]  dividend_reg, divisor_reg;
    reg        start_cnt;
    reg [3:0]  cnt;           // count to 8 (4 bits enough)
    reg [16:0] SR;            // shift register: 9 bits remainder + 8 bits quotient + 1 bit extra shift (total 17)
    reg [8:0]  NEG_DIVISOR;   // negated divisor (9 bits for sign extension)
    reg [7:0]  abs_dividend, abs_divisor;
    reg        quotient_sign;  // sign of quotient
    reg        dividend_sign, divisor_sign;

    // Internal signals for subtraction
    wire [8:0] sub_res;
    wire       sub_carry;

    // Assign internal subtraction: SR[16:8] - divisor
    // SR[16:8]: 9 bits (remainder with one extra bit)
    // NEG_DIVISOR is -abs(divisor)
    assign {sub_carry, sub_res} = SR[16:8] + NEG_DIVISOR; // Adding negative divisor = subtraction

    // On reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            start_cnt <= 1'b0;
            cnt <= 4'b0;
            SR <= 17'b0;
            NEG_DIVISOR <= 9'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            quotient_sign <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
        end else begin
            // Start operation when opn_valid and not busy (res_valid == 0)
            if (opn_valid && !res_valid) begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;

                // Determine signs if signed operation
                if (sign) begin
                    dividend_sign <= dividend[7];
                    divisor_sign <= divisor[7];
                    // abs_dividend
                    abs_dividend <= dividend[7] ? (~dividend + 1) : dividend;
                    // abs_divisor
                    abs_divisor <= divisor[7] ? (~divisor + 1) : divisor;
                    // quotient sign
                    quotient_sign <= dividend[7] ^ divisor[7];
                end else begin
                    dividend_sign <= 1'b0;
                    divisor_sign <= 1'b0;
                    abs_dividend <= dividend;
                    abs_divisor <= divisor;
                    quotient_sign <= 1'b0;
                end

                // Initialize SR with abs(dividend) shifted left by 1: remainder(9 bits) + quotient(8 bits)
                // We prepare remainder in bits [16:8] (9 bits), quotient in [7:0]
                // Initialize quotient to zero (lowest 8 bits zero)
                SR <= {abs_dividend, 1'b0, 8'b0}; 
                // Since abs_dividend is 8 bits, shift left 1 bit: remainder=9 bits
                // Actually, we want remainder in bits [16:8] = abs_dividend << 1
                // Let's assign as follows:
                // bits [16:9] = abs_dividend bits [7:0] + 1 bit zero (LSB)
                // bits [8:0] = quotient and extra bit

                // Simplify: set remainder = abs_dividend << 1 in bits [16:8], quotient zero in bits [7:0]
                SR <= {abs_dividend, 1'b0, 8'b0}; // abs_dividend(8), 1 bit zero, quotient(8 bits)
                // abs_dividend (8 bits) placed at bits [16:9], bit 8 zero, quotient bits [7:0]

                // Initialize NEG_DIVISOR = -abs_divisor
                NEG_DIVISOR <= (~{1'b0, abs_divisor} + 1'b1); // 9 bits (leading zero + 8 bits abs_divisor), negate

                // Initialize counter and start flag
                cnt <= 4'b1; // start from 1
                start_cnt <= 1'b1;

                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete
                    // Adjust quotient sign if signed division
                    // Quotient is in bits [7:0] of SR
                    // Remainder is in bits [16:9] of SR (9 bits), but remainder is always positive in this design.
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;

                    // Quotient and remainder extraction
                    // quotient: SR[7:0]
                    // remainder: SR[16:9] (9 bits), but output remainder is 8 bits (upper 8 bits in result)
                    // The MSB (bit 16) is extra bit from shifting, discard

                    // Extract remainder and quotient
                    // remainder = SR[16:9], 8 bits are bits [16:9], bit 16 MSB included, but remainder is 8 bits => bits [16:9]
                    // bit 16 included, so actually 9 bits remainder with an extra bit. We take bits [16:9], but must discard MSB bit 16
                    // The shift left by 1 was to allow proper subtraction, so remainder is actually in bits [16:9], discard bit 16?

                    // For output remainder 8 bits, we use bits [16:9] after shifting right by 1 (divide by 2)
                    // But per the original instructions, the remainder is in upper 8 bits (bits 15:8).
                    // We extract remainder bits [16:9] shifted right 1.

                    // So remainder (8 bits) = SR[16:9] >> 1
                    // But since we initially shifted abs_dividend by 1 to get remainder, the remainder is in bits [16:9]
                    // After the division process, SR[16:9] contains the remainder shifted left 1.
                    // So, remainder = SR[16:9] >> 1;

                    // Quotient sign correction
                    // If quotient_sign is set, quotient = -quotient
                    // Quotient is unsigned currently
                    // We apply two's complement if quotient_sign

                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    // compute remainder_final: divide by 2 (shift right 1)
                    remainder_final = SR[16:9] >> 1;

                    // quotient before sign correction
                    quotient_final = SR[7:0];

                    if (sign && quotient_sign) begin
                        quotient_final = (~quotient_final) + 1'b1;
                    end

                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;
                end else begin
                    // Perform iteration step

                    // If subtraction result MSB (sign bit of 9 bits) is 1 => subtraction negative => restore previous remainder and set quotient bit to 0
                    // Else subtraction non-negative => update remainder with sub_res and set quotient bit to 1
                    if (sub_res[8] == 1'b0) begin
                        // subtraction non-negative (carry out 1)
                        // update remainder = sub_res[7:0], quotient shift left + 1
                        SR <= {sub_res[7:0], SR[7:0], 1'b1}; // shift left remainder+quotient by 1, insert quotient bit = 1
                    end else begin
                        // subtraction negative, restore remainder, quotient bit = 0
                        SR <= {SR[15:0], 1'b0}; // shift left by 1, quotient bit 0
                    end

                    cnt <= cnt + 1'b1;
                end
            end else begin
                // no operation, clear res_valid when result is consumed (assuming user clears opn_valid when result consumed)
                // Or keep res_valid high until new operation start
                if (res_valid && !opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule