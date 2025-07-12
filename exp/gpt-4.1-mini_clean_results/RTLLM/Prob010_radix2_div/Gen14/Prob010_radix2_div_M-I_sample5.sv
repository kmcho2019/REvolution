module radix2_div (
    input              clk,
    input              rst,
    input              sign,           // 1: signed, 0: unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;           // Shift register: [16:8] remainder(9 bits), [7:0] quotient (8 bits)
    reg [8:0]  NEG_DIVISOR;  // 9-bit negated divisor magnitude for subtraction
    reg [3:0]  cnt;          // counts from 1 to 8, MSB used to detect finish
    reg        start_cnt;    // 1: division in progress

    reg        dividend_neg, divisor_neg;
    reg [7:0]  abs_dividend, abs_divisor;

    // Temporary variables for subtraction
    reg [8:0]  remainder_part;
    wire [8:0] sub_result;
    wire       sub_carry;

    // Combinational subtraction: remainder_part + NEG_DIVISOR
    assign {sub_carry, sub_result} = remainder_part + NEG_DIVISOR;

    // Calculate absolute values on operation start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'b0;
            NEG_DIVISOR  <= 9'b0;
            cnt          <= 4'd0;
            start_cnt    <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor  <= 8'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs and compute abs values and signs
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    abs_dividend <= dividend[7] ? (~dividend + 1'b1) : dividend;
                    abs_divisor  <= divisor[7]  ? (~divisor  + 1'b1) : divisor;
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    abs_dividend <= dividend;
                    abs_divisor  <= divisor;
                end

                // Initialize SR: remainder=0, quotient=abs_dividend, plus one zero bit for shifting
                // SR = {9'b0, abs_dividend[7:0]} = 17 bits, but we need to shift dividend left by 1 for alignment
                // According to problem: SR initialized with abs_dividend shifted left by 1 bit
                // So SR = {8'b0, abs_dividend, 1'b0} total 17 bits:
                SR <= {9'b0, abs_dividend, 1'b0};

                // NEG_DIVISOR = -abs_divisor as 9 bits two's complement
                NEG_DIVISOR <= (~{1'b0, abs_divisor}) + 1'b1;

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt[3]) begin
                    // cnt MSB is 1 => division complete (cnt=8 or higher)
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;

                    // Select remainder part (upper 9 bits of SR)
                    remainder_part <= SR[16:8];

                    // After subtraction: if sub_carry=1 means remainder >= divisor => subtraction success
                    // Update SR as:
                    // shift left SR by 1 bit (drops MSB of remainder), insert sub_carry as LSB of quotient

                    if (sub_carry) begin
                        // subtraction success: new remainder = sub_result
                        // SR[16:8] = sub_result shifted left by 1 bit with LSB dropped
                        // Actually shift by 1 bit is done on entire SR. To avoid confusion:

                        // We create next SR as:
                        // SR_next = {sub_result, SR[7:0]} << 1 + insert 1'b1 as LSB quotient bit

                        // But must do precise bit shifting to keep 17 bits
                        // shift left by 1 bit:
                        // new SR[16:1] = old SR[15:0]
                        // new SR[0] = sub_carry (1)

                        // Compose next SR from new remainder and quotient bits:

                        // Since remainder is 9 bits, quotient 8 bits:
                        // After shift left by 1:
                        // SR[16:8] = sub_result[8:0] shifted left by 1, truncated to 9 bits?
                        // Actually, the standard radix-2 division shifts entire SR left by 1 bit, with LSB quotient updated

                        // The conventional method is:
                        // shift entire SR left by 1 bit, drop MSB
                        // update SR[0] = sub_carry (1)

                        SR <= {sub_result, SR[7:0]} << 1 | 17'b1; // insert 1 at LSB

                    end else begin
                        // subtraction fail: remainder unchanged
                        // shift left SR by 1 bit, insert 0 at LSB

                        SR <= SR << 1;
                    end
                end
            end else if (res_valid) begin
                // result valid remains until new op start
                if (opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

    // Sign correction and result output combinational logic
    always @(*) begin
        if (res_valid) begin
            reg [7:0] final_quotient;
            reg [7:0] final_remainder;
            reg       quotient_neg;
            reg       remainder_neg;

            // Extract raw quotient and remainder
            // Quotient is lower 8 bits of SR after division (SR[7:0])
            // Remainder is upper 8 bits of SR (bits 16:9), but we have 9-bit remainder SR[16:8],
            // remainder is 8 bits output, so take MSB bits [16:9] for remainder output:
            final_quotient = SR[7:0];
            final_remainder = SR[16:9]; // 8 bits remainder

            quotient_neg = sign & (dividend_neg ^ divisor_neg);
            remainder_neg = sign & dividend_neg;

            // Signed correction on quotient and remainder
            if (quotient_neg)
                final_quotient = (~final_quotient) + 1'b1;
            if (remainder_neg)
                final_remainder = (~final_remainder) + 1'b1;

            result = {final_remainder, final_quotient};
        end else begin
            result = 16'b0;
        end
    end

endmodule