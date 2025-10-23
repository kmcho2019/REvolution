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
    reg [16:0] SR;           // Shift register: upper 9 bits remainder, lower 8 bits quotient
    reg [8:0]  NEG_DIVISOR;  // 9-bit negated divisor magnitude for subtraction
    reg [3:0]  cnt;          // 4-bit counter from 1 to 8 (MSB indicates done)
    reg        start_cnt;    // 1: division ongoing, 0: idle or done

    reg        dividend_neg, divisor_neg;
    reg [7:0]  abs_dividend, abs_divisor;

    // Wires for subtraction result and carry-out
    wire [8:0] sub_result;
    wire       sub_carry;

    // Temporary regs for subtraction operand and dividend magnitude
    reg  [8:0] SR_upper;     // Upper 9 bits of SR representing remainder part

    // Initialize or update signals at operation start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'b0;
            NEG_DIVISOR  <= 9'b0;
            cnt          <= 4'b0;
            start_cnt    <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor  <= 8'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs and compute absolute values and signs
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

                // Initialize SR with dividend abs shifted left by 1 bit (remainder part = 0)
                // SR[16:9] = 0 (remainder), SR[8:1] = abs_dividend, SR[0] = 0
                SR <= {9'b0, abs_dividend, 1'b0};

                // NEG_DIVISOR = -abs_divisor (9-bit 2's complement)
                // extend abs_divisor to 9 bits first
                NEG_DIVISOR <= (~{1'b0, abs_divisor}) + 1'b1;

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt[3]) begin
                    // cnt MSB is 1 => finished
                    start_cnt <= 1'b0;
                    cnt       <= 4'b0;
                    res_valid <= 1'b1;

                    // Final remainder is SR[16:9], quotient is SR[8:1]
                    // Assign with signed correction below (in combinational block)
                end else begin
                    cnt <= cnt + 1'b1;

                    // Prepare subtraction: SR_upper + NEG_DIVISOR
                    SR_upper = SR[16:8];  // 9-bit remainder part currently shifted

                    {sub_carry, sub_result} = SR_upper + NEG_DIVISOR;

                    // If carry_out == 1 means remainder >= divisor, subtraction successful
                    // Update SR accordingly:
                    // Shift SR left by 1 bit, insert sub_carry at LSB (quotient bit)
                    // Upper bits of SR set to sub_result if subtraction success else old remainder shifted left

                    if (sub_carry) begin
                        // subtraction success: remainder = sub_result, quotient LSB = 1
                        SR <= {sub_result, SR[7:0], 1'b1};
                    end else begin
                        // subtraction fail: remainder unchanged, quotient LSB = 0
                        SR <= {SR[16:8], SR[7:0], 1'b0};  // shift left by 1 bit; remainder shifted in with 0 LSB
                    end
                end
            end else if (res_valid) begin
                // Result valid remains until new operation start
                if (opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

    // Sign correction combinational block for final result when res_valid is set
    always @(*) begin
        if (res_valid) begin
            reg [7:0] final_quotient;
            reg [7:0] final_remainder;
            reg       quotient_neg;
            reg       remainder_neg;

            // Extract raw quotient and remainder from SR
            final_quotient = SR[8:1];
            final_remainder = SR[16:9];

            quotient_neg = sign & (dividend_neg ^ divisor_neg);
            remainder_neg = sign & dividend_neg;

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