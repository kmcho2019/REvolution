module radix2_div(
    input           clk,
    input           rst,
    input           sign,           // 1=signed, 0=unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    reg [8:0] SR;           // Shift register: [8] is remainder MSB, [7:0] current quotient bits + remainder shift space
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg sign_dividend;
    reg sign_divisor;
    reg sign_result;
    reg start_cnt;
    reg [3:0] cnt;          // 4-bit counter to count up to 8 (0 to 8)
    reg [8:0] sub_res;      // 9-bit to hold subtraction result with borrow
    reg divisor_zero;       // track if divisor is zero (corner case)

    // Compute absolute value and sign flags
    wire dividend_neg = sign & dividend[7];
    wire divisor_neg = sign & divisor[7];

    wire [7:0] dividend_abs_val = dividend_neg ? (~dividend + 1'b1) : dividend;
    wire [7:0] divisor_abs_val = divisor_neg ? (~divisor + 1'b1) : divisor;

    // Negated divisor for subtraction step (two's complement of divisor)
    wire [8:0] neg_divisor = {1'b0, ~abs_divisor} + 9'd1; // 9-bit two's complement negation

    // Division process:
    // SR initialized as {dividend_abs_val, 1'b0} shifted left 1 bit: actually per spec just shifted left 1 bit, so SR[8:1] = dividend_abs, SR[0]=0
    // cnt counts from 1 to 8 inclusive

    // res_valid becomes 1 when division done (cnt==8), stays 1 until a new operation

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            SR <= 9'd0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            sign_dividend <= 1'b0;
            sign_divisor <= 1'b0;
            sign_result <= 1'b0;
            result <= 16'd0;
            divisor_zero <= 1'b0;
        end else begin
            if (opn_valid & ~res_valid) begin
                // Start new division
                abs_dividend <= dividend_abs_val;
                abs_divisor <= divisor_abs_val;
                sign_dividend <= dividend_neg;
                sign_divisor <= divisor_neg;
                sign_result <= dividend_neg ^ divisor_neg; // quotient sign
                divisor_zero <= (divisor == 8'd0);
                // Initialize shift register SR = dividend_abs_val shifted left 1 bit: bit8:1 remainder, bit7:0 quotient bits (starts zero)
                SR <= {dividend_abs_val,1'b0};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // If division in progress
                if (divisor_zero) begin
                    // Divisor zero: division undefined, saturate or clear output: produce zero quotient and remainder = dividend
                    // According to requirements no special mention, just output dividend as remainder and quotient=0
                    SR <= {abs_dividend, 8'd0};
                    res_valid <= 1'b1;
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                end else if (cnt == 4'd8) begin
                    // Division done on this cycle
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    res_valid <= 1'b1;

                    // After division, SR contains remainder and quotient but remainder might be negative due to subtract steps
                    // Fix remainder if negative by adding divisor back
                    // remainder currently in SR[8:1] (9 bits but highest is sign bit in two's complement?)
                    // We handle remainder as signed 9-bit number:
                    // Actually SR is 9 bits with remainder MSB and quotient bits in lower bits shifted through the division
                    // remainder is upper 8 bits SR[8:1] after final iteration, quotient is lower 8 bits of SR

                    // remainder fix:
                    // If remainder negative (SR[8] == 1), remainder = remainder + divisor
                    // remainder and divisor are 8 bits, remainder stored in SR[8:1]

                    reg [8:0] remainder9;
                    reg [8:0] fixed_remainder9;
                    remainder9 = SR;

                    if (remainder9[8] == 1'b1) begin
                        // remainder negative, add divisor_abs
                        fixed_remainder9 = remainder9 + {1'b0, abs_divisor};
                    end else begin
                        fixed_remainder9 = remainder9;
                    end

                    // Prepare quotient and remainder for signed adjustment
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    final_remainder = fixed_remainder9[8:1];

                    // Quotient is in SR[7:0]
                    final_quotient = SR[7:0];

                    // Signed correction:
                    if (sign) begin
                        // If dividend neg and quotient positive, negate quotient
                        if (sign_result)
                            final_quotient = (~final_quotient) + 1'b1;
                        // If dividend neg remainder, negate remainder
                        if (sign_dividend & (final_remainder != 8'd0))
                            final_remainder = (~final_remainder) + 1'b1;
                    end

                    // Compose result: remainder[7:0] in upper 8 bits, quotient[7:0] in lower 8 bits
                    result <= {final_remainder, final_quotient};

                end else begin
                    // cnt < 8: continue division iteration
                    cnt <= cnt + 4'd1;

                    // Compute subtraction: SR - divisor (extend divisor to 9 bits)
                    sub_res = SR + neg_divisor;

                    if (sub_res[8] == 1'b0) begin
                        // subtraction >= 0, quotient bit = 1
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // subtraction < 0, quotient bit = 0, restore remainder (no subtraction)
                        SR <= {SR[7:0], 1'b0};
                    end
                end
            end else begin
                // Idle, no operation running, clear res_valid only when opn_valid triggers a new operation
                // Keep res_valid stable until next operation.
            end
        end
    end
endmodule