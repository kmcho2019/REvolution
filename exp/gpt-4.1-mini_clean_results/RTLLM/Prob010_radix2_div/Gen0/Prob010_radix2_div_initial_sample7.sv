module radix2_div(
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [8:0] SR;              // Shift register: holds remainder+quotient bits (9 bits)
    reg [7:0] divisor_abs;     // Absolute value of divisor
    reg [7:0] dividend_abs;    // Absolute value of dividend
    reg [8:0] NEG_DIVISOR;     // 9-bit negated divisor for subtraction
    reg [3:0] cnt;             // counter from 0 to 8 (use 4 bits to hold 0-8)
    reg        start_cnt;      // division in progress flag

    reg sign_quotient;         // sign of quotient
    reg sign_remainder;        // sign of remainder

    // Temporary subtraction result
    reg [9:0] sub_result;      // one extra bit for borrow

    // Registers to store original dividend/divisor signs
    reg dividend_neg;
    reg divisor_neg;

    // Latch inputs on operation valid
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 9'd0;
            divisor_abs <= 8'd0;
            dividend_abs<= 8'd0;
            NEG_DIVISOR <= 9'd0;
            cnt         <= 4'd0;
            start_cnt   <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            sign_quotient  <= 1'b0;
            sign_remainder <= 1'b0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Determine signs and absolute values if signed operation
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];

                    dividend_abs <= dividend[7] ? (~dividend + 1) : dividend;
                    divisor_abs  <= divisor[7]  ? (~divisor + 1)  : divisor;

                    // quotient sign is XOR of dividend and divisor signs
                    sign_quotient <= dividend[7] ^ divisor[7];
                    // remainder sign same as dividend sign
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_abs <= dividend;
                    divisor_abs  <= divisor;

                    dividend_neg   <= 1'b0;
                    divisor_neg    <= 1'b0;
                    sign_quotient  <= 1'b0;
                    sign_remainder <= 1'b0;
                end

                // Initialize SR: (dividend_abs << 1), 9 bits
                SR <= {dividend_abs, 1'b0}; // dividend_abs shifted left by 1

                // NEG_DIVISOR is two's complement of divisor_abs shifted left by 1 (9 bits)
                // Actually we need NEG_DIVISOR as two's complement of divisor_abs in 9 bits to subtract from top bits
                NEG_DIVISOR <= {1'b0, divisor_abs};
                NEG_DIVISOR <= (~{1'b0, divisor_abs} + 9'd1);

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (start_cnt) begin
                // division steps
                // top 9 bits are in SR
                // subtract NEG_DIVISOR from upper bits (bits 8 downto 0 of SR)
                // Note: SR[8:0] is dividend portion
                // Perform: SR[8:0] + NEG_DIVISOR
                sub_result = {1'b0, SR} + {1'b0, NEG_DIVISOR};

                // sub_result[9] is carry-out (borrow bit because we added two's complement)
                if (sub_result[9]) begin
                    // subtraction did not borrow -> set quotient bit to 1
                    // Shift left SR by 1 and insert 1 at LSB
                    SR <= {sub_result[8:0], 1'b1};
                end else begin
                    // subtraction borrow, restore SR shifted left with 0 in LSB
                    // shift SR left by 1 bit and insert 0 in LSB (quotient bit 0)
                    SR <= {SR[7:0], 1'b0};
                end

                // cnt increment or finish
                if (cnt == 4'd8) begin
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    res_valid <= 1'b1;
                    // On finish, SR[8:1] is remainder, SR[7:0] is quotient

                    // quotient and remainder before sign correction
                    // quotient = SR[7:0]
                    // remainder = SR[8:1]

                    // apply sign corrections
                    // quotient sign
                    // remainder sign (only if signed)
                    // For signed, quotient = quotient if sign_quotient==0 else -quotient
                    // For remainder, remainder = remainder if sign_remainder==0 else -remainder

                    // apply two's complement if negative sign

                    // quotient correction
                    if (sign && sign_quotient) begin
                        // negate quotient
                        result[7:0] = (~SR[7:0] + 8'd1);
                    end else begin
                        result[7:0] = SR[7:0];
                    end

                    // remainder correction
                    if (sign && sign_remainder) begin
                        result[15:8] = (~SR[8:1] + 8'd1);
                    end else begin
                        result[15:8] = SR[8:1];
                    end
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end else if (res_valid && opn_valid) begin
                // New operation requested after result valid: clear res_valid for next operation
                res_valid <= 1'b0;
            end
        end
    end
endmodule