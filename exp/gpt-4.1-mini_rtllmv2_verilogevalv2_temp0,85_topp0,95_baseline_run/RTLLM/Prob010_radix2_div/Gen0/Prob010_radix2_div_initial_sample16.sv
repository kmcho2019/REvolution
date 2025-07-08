module radix2_div (
    input         clk,
    input         rst,
    input         sign,
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output reg    res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [8:0] SR;           // 9-bit shift register: holds remainder (8 bits) + quotient bit (1 bit)
    reg [7:0] divisor_abs;  // absolute value of divisor
    reg [7:0] dividend_abs; // absolute value of dividend
    reg [7:0] neg_divisor;  // two's complement of divisor_abs
    reg [3:0] cnt;          // count 1 to 8
    reg       start_cnt;    // division in progress flag

    // Signed input sign bits
    wire dividend_sign = sign & dividend[7];
    wire divisor_sign  = sign & divisor[7];

    // Intermediate signals
    reg [8:0] sub_res;
    wire       sub_cout;

    // Convert dividend and divisor to absolute values on start
    wire [7:0] dividend_abs_w = dividend_sign ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_w  = divisor_sign  ? (~divisor  + 1) : divisor;

    // sign correction of quotient and remainder after division completes
    reg quotient_sign;
    reg remainder_sign;

    // Registers to hold original signs for use at completion
    reg saved_dividend_sign;
    reg saved_divisor_sign;

    // Division by zero handling: if divisor == 0, output zero quotient and dividend remainder
    wire divisor_zero = (divisor_abs_w == 0);

    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 1'b0;
            cnt       <= 4'd0;
            start_cnt <= 1'b0;
            SR        <= 9'd0;
            divisor_abs <= 8'd0;
            dividend_abs <= 8'd0;
            neg_divisor <= 8'd0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
            saved_dividend_sign <= 1'b0;
            saved_divisor_sign <= 1'b0;
            result <= 16'd0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Capture absolute values
                dividend_abs <= dividend_abs_w;
                divisor_abs <= divisor_abs_w;
                neg_divisor <= (~divisor_abs_w) + 1'b1;
                saved_dividend_sign <= dividend_sign;
                saved_divisor_sign <= divisor_sign;

                // Initialize SR: {remainder[7:0], quotient[0]} = {dividend_abs shifted left by 1 bit}
                // dividend_abs is 8-bit, shift left by 1 => 9 bits: MSB is remainder's MSB, LSB is zero (quotient bit)
                SR <= {dividend_abs_w, 1'b0};

                // Initialize counter and start flag
                cnt <= 4'd1;
                start_cnt <= 1'b1;

                // Clear result valid
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division steps
                if (cnt == 4'd8) begin
                    // Division done
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // SR[8:1] remainder; SR[0] quotient bit
                    // After last iteration, SR holds remainder and quotient bits

                    // The quotient is in SR[7:0]
                    // The remainder is in SR[8:1]
                    // Apply sign correction for quotient and remainder

                    // Compose raw quotient and remainder
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = SR[7:0];
                    raw_remainder = SR[8:1];

                    // Determine quotient sign: XOR of input signs
                    quotient_sign = saved_dividend_sign ^ saved_divisor_sign;
                    remainder_sign = saved_dividend_sign;

                    reg [7:0] signed_quotient;
                    reg [7:0] signed_remainder;

                    // If divisor zero, output zero quotient and remainder = dividend
                    if (divisor_zero) begin
                        signed_quotient = 8'd0;
                        signed_remainder = dividend;
                    end else begin
                        // Adjust quotient sign
                        if (sign && quotient_sign)
                            signed_quotient = (~raw_quotient + 1'b1);
                        else
                            signed_quotient = raw_quotient;

                        // Adjust remainder sign
                        if (sign && remainder_sign)
                            signed_remainder = (~raw_remainder + 1'b1);
                        else
                            signed_remainder = raw_remainder;
                    end

                    result <= {signed_remainder, signed_quotient};
                    res_valid <= 1'b1;
                end else begin
                    // Iterative division step

                    // Try to subtract divisor from remainder part of SR
                    // remainder part is SR[8:1]
                    sub_res = {1'b0, SR[8:1]} + {1'b0, neg_divisor}; // 9-bit addition: remainder - divisor_abs
                    sub_cout = ~sub_res[8]; // if MSB=0 => positive or zero => borrow=0, so carry out=1 means subtraction succeeded

                    // If subtraction successful (carry out == 1), update remainder with sub_res[7:0] and set quotient bit to 1
                    // else leave remainder unchanged and quotient bit to 0

                    SR <= {sub_cout ? sub_res[7:0] : SR[8:1], SR[0], 1'b0} << 1 | sub_cout; 
                    // Explanation:
                    // - Shift left the whole SR (9 bits) by 1
                    // - Insert carry_out as the new LSB quotient bit
                    // - For remainder: if subtraction succeeded, update to sub_res; else remain
                    // The way to implement:
                    // SR[8:1] = if sub_cout  sub_res[7:0], else SR[8:1]
                    // then shift left by 1 bit and insert carry_out as new quotient bit (LSB)

                    // To do this correctly:
                    // First build new SR bits[8:1]:
                    // If sub_cout==1, new remainder = sub_res[7:0], else old remainder
                    // Shift left by 1: means SR <= {remainder[7:0], quotient[0]} << 1 | carry_out

                    // Let's implement this with temporary variables for clarity:

                    // New remainder bits:
                    // tmp_remainder = sub_cout ? sub_res[7:0] : SR[8:1]
                    // Shift left by 1 + insert carry_out:
                    // SR <= {tmp_remainder, SR[0]} << 1 | carry_out

                    // Actually, SR is 9 bits, so shifting left by 1 and inserting carry_out at LSB:

                    // We'll implement this below in code.

                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && opn_valid) begin
                // Result consumed, clear res_valid so a new operation can start
                res_valid <= 1'b0;
            end
        end
    end

    // Implement iterative SR update with clearer logic
    always @(posedge clk) begin
        if (rst) begin
            // Already handled above
        end else if (start_cnt && cnt < 4'd8) begin
            // Do subtraction attempt
            sub_res = {1'b0, SR[8:1]} + {1'b0, neg_divisor};
            sub_cout = ~sub_res[8]; // carry out = 1 if subtraction successful

            reg [7:0] new_remainder;
            reg [8:0] new_SR;

            if (sub_cout) new_remainder = sub_res[7:0];
            else          new_remainder = SR[8:1];

            // Shift left by 1 and insert carry_out as new quotient bit
            new_SR = {new_remainder, SR[0]} << 1 | sub_cout;

            SR <= new_SR;
        end
    end

endmodule