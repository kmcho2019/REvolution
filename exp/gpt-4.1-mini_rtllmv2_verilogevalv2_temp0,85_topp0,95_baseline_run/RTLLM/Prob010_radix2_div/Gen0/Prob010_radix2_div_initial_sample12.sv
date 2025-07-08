module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output  reg         res_valid,
    output  reg [15:0]  result
);

    // Internal signals and registers
    reg [7:0] abs_dividend, abs_divisor;
    reg       dividend_sign, divisor_sign;
    reg [16:0] SR;  // 9 bits remainder + 8 bits quotient shifted left by 1 bit
    reg [8:0]  NEG_DIVISOR; // 9 bits for subtraction
    reg [3:0]  cnt;
    reg        start_cnt;

    wire [8:0] sub_res;
    wire       sub_carry;

    // Compute absolute values and sign bits
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs  = (sign && divisor[7])  ? (~divisor + 1)  : divisor;
    wire       dividend_neg = sign && dividend[7];
    wire       divisor_neg  = sign && divisor[7];

    // Subtraction: upper 9 bits of SR - NEG_DIVISOR
    assign {sub_carry, sub_res} = {1'b0, SR[16:8]} + NEG_DIVISOR; // NEG_DIVISOR is already negated

    // NEG_DIVISOR is -abs_divisor extended to 9 bits (two's complement)
    wire [8:0] abs_divisor_ext = {1'b0, abs_divisor};
    wire [8:0] neg_abs_divisor = (~abs_divisor_ext) + 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            cnt       <= 4'd0;
            start_cnt <= 1'b0;
            SR        <= 17'd0;
            NEG_DIVISOR <= 9'd0;
            result    <= 16'd0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs and initialize
                abs_dividend <= dividend_abs;
                abs_divisor  <= divisor_abs;
                dividend_sign <= dividend_neg;
                divisor_sign  <= divisor_neg;
                cnt       <= 4'd1;
                start_cnt <= 1'b1;

                // SR: (dividend_abs << 1) 17 bits:
                // Upper 9 bits: remainder (initialized to 0)
                // Lower 8 bits: quotient bits shifted in during division
                // We will initialize SR as dividend_abs shifted left by 1 bit (lower 9 bits)
                SR <= {8'd0, dividend_abs, 1'b0};

                // NEG_DIVISOR = -abs_divisor extended to 9 bits
                NEG_DIVISOR <= neg_abs_divisor;

                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd9) begin
                    // Division complete after 8 iterations (cnt from 1 to 8)
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // Extract remainder and quotient before adjusting sign
                    // Remainder in upper 9 bits (17:8), quotient in lower 8 bits (7:0)
                    // But remainder is 9 bits, the MSB can be sign extension, so only 8 bits used
                    // We'll truncate remainder to 8 bits (bits 16:9)
                    // Quotient is bits [7:0]
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = SR[7:0];
                    raw_remainder = SR[16:9];

                    // Adjust signs for signed division
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    if (sign) begin
                        // quotient sign = dividend_sign XOR divisor_sign
                        if (dividend_sign ^ divisor_sign) begin
                            final_quotient = (~raw_quotient + 1);
                        end else begin
                            final_quotient = raw_quotient;
                        end

                        // remainder sign = dividend_sign
                        if (dividend_sign) begin
                            final_remainder = (~raw_remainder + 1);
                        end else begin
                            final_remainder = raw_remainder;
                        end
                    end else begin
                        final_quotient = raw_quotient;
                        final_remainder = raw_remainder;
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;

                end else begin
                    // Perform subtraction step:
                    // If sub_carry=1 means no borrow => SR[16:8] >= abs_divisor => subtraction succeeds
                    // Shift left SR by 1 bit, insert 1 at LSB of quotient if subtraction succeeded else 0

                    // SR upper 9 bits updated by sub_res if sub_carry=1 else unchanged upper 9 bits shifted left by 1
                    // We implement as:
                    // If subtraction success (sub_carry=1), SR[16:8] = sub_res, and insert 1 to quotient
                    // else SR[16:8] unchanged, insert 0 to quotient

                    if (sub_carry) begin
                        // Successful subtraction
                        SR <= {sub_res, SR[7:1], 1'b1};
                    end else begin
                        // Unsuccessful subtraction
                        SR <= {SR[15:8], SR[7:1], 1'b0};
                    end

                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Result consumed, clear res_valid to accept new operation
                res_valid <= 1'b0;
            end
        end
    end

endmodule