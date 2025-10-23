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

    // Registers as per problem statement
    reg [16:0] SR;              // Shift register: 17 bits: {remainder[8:0], quotient[7:0]}
    reg [7:0]  dividend_r;
    reg [7:0]  divisor_r;

    reg        start_cnt;
    reg [3:0]  cnt;             // count from 1 to 8

    reg        dividend_neg;
    reg        divisor_neg;

    reg [7:0]  abs_dividend;
    reg [7:0]  abs_divisor;
    reg [8:0]  neg_divisor;     // 9-bit negated divisor magnitude for subtraction

    // Intermediate wires for subtraction
    wire [8:0] remainder_part = SR[16:8];    // upper 9 bits: remainder + 1 extra bit (for shift)
    wire [8:0] sub_res;
    wire       borrow_sub;

    // Subtraction: remainder_part - neg_divisor (= remainder_part + divisor magnitude)
    assign {borrow_sub, sub_res} = {1'b0, remainder_part} + {1'b0, neg_divisor}; 
    // Note: neg_divisor is two's complement negation of abs_divisor, so remainder + neg_divisor = remainder - divisor

    // On subtraction, borrow_sub == 1 means remainder_part < neg_divisor (negative result)
    // So if borrow_sub==0, subtraction successful and quotient bit = 1, else quotient bit=0 and remainder unchanged

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all
            res_valid    <= 1'b0;
            SR           <= 17'b0;
            dividend_r   <= 8'b0;
            divisor_r    <= 8'b0;
            start_cnt    <= 1'b0;
            cnt          <= 4'b0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor  <= 8'b0;
            neg_divisor  <= 9'b0;
            result       <= 16'b0;
        end else begin
            // Start operation: latch inputs and initialize shift register and control signals
            if (opn_valid && !res_valid) begin
                // Latch inputs
                dividend_r <= dividend;
                divisor_r <= divisor;

                // Determine signs and absolute values for signed operation
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    abs_dividend <= dividend[7] ? (~dividend + 1'b1) : dividend;
                    abs_divisor  <= divisor[7] ? (~divisor + 1'b1) : divisor;
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    abs_dividend <= dividend;
                    abs_divisor  <= divisor;
                end

                // Initialize SR with dividend magnitude shifted left by 1 (times 2), remainder zero
                // SR format: {remainder[8:0], quotient[7:0]}
                // remainder initialized to 0 (9 bits), quotient initialized to abs_dividend shifted left by 1 bit (9 bits)
                // However, problem states initialize SR with abs(dividend)<<1, so quotient portion shifted left by 1 bit
                // We'll store quotient in lower 8 bits, so shift abs_dividend left by 1, put in lower 9 bits of SR
                SR <= {9'b0, abs_dividend, 1'b0};

                // Prepare NEG_DIVISOR as two's complement of abs_divisor (9-bit)
                // Negate abs_divisor extended to 9 bits (LSB 0)
                neg_divisor <= (~{1'b0, abs_divisor} + 9'b1);

                // Start counting
                cnt <= 4'd1;
                start_cnt <= 1'b1;

                // Clear res_valid until done
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process ongoing
                if (cnt[3]) begin
                    // cnt reaches 8 or more (cnt[3] == 1 when cnt>=8), division complete
                    // Clear start_cnt and cnt
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;

                    // Final SR already updated in previous cycle (see below)

                    // Extract raw remainder and quotient from SR
                    // Remainder: upper 9 bits, but discard LSB (least significant remainder bit)
                    // Quotient: lower 8 bits of SR
                    // Sign correct quotient and remainder if signed

                    // Extract raw quotient and remainder
                    // This will be done combinationally below for output

                    res_valid <= 1'b1;
                end else begin
                    // Division ongoing: execute one division cycle

                    // Compute subtraction result remainder_part - abs_divisor (using neg_divisor)
                    // If borrow_sub == 0 => subtraction successful, quotient bit = 1
                    // Else quotient bit = 0, remainder unchanged

                    // Shift left SR by 1 bit
                    // Insert quotient bit at LSB of quotient portion
                    // Update remainder according to subtraction result

                    if (!borrow_sub) begin
                        // Subtraction successful, update remainder to sub_res, quotient bit = 1
                        SR <= {sub_res, SR[7:1], 1'b1};
                    end else begin
                        // Subtraction failed, remainder unchanged, quotient bit = 0
                        SR <= {remainder_part, SR[7:1], 1'b0};
                    end

                    // Increment counter
                    cnt <= cnt + 1'b1;
                end
            end else begin
                // Not starting, division not running
                // Keep outputs stable, clear res_valid if consumed by new opn_valid
                if (!opn_valid) begin
                    res_valid <= 1'b0;
                end
            end

            // Compute final output when res_valid asserted
            if (res_valid) begin
                // Extract raw quotient and remainder from SR (SR holds remainder and quotient)
                // Remainder upper 9 bits, we discard LSB remainder bit per problem statement, so upper 8 bits remain
                // Quotient lower 8 bits

                // raw quotient and remainder
                wire [7:0] raw_quotient = SR[7:0];
                wire [7:0] raw_remainder = SR[16:9]; // discard LSB remainder bit (SR[8])

                // sign correction
                wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
                wire remainder_neg = sign & dividend_neg;

                wire [7:0] quotient_corr = quotient_neg ? (~raw_quotient + 1'b1) : raw_quotient;
                wire [7:0] remainder_corr = remainder_neg ? (~raw_remainder + 1'b1) : raw_remainder;

                result <= {remainder_corr, quotient_corr};
            end
        end
    end

endmodule