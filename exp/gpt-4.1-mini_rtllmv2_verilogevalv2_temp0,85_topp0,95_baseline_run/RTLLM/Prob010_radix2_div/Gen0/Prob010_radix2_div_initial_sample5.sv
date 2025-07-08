module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [8:0] SR;             // 9-bit shift register: remainder(8 bits)+quotient(1 bit)
    reg [7:0] NEG_DIVISOR;    // negated absolute divisor
    reg [3:0] cnt;            // 4-bit counter (to count 1 to 8)
    reg        start_cnt;

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg       dividend_sign;  // sign of dividend if signed
    reg       divisor_sign;   // sign of divisor if signed

    reg       result_sign;    // sign of quotient (dividend_sign ^ divisor_sign)
    reg       rem_sign;       // sign of remainder (same as dividend_sign)

    // Combinational wire for subtraction result
    wire [8:0] sub_res;
    wire       sub_carry;

    // Calculate subtraction: SR[8:1] - NEG_DIVISOR
    // SR[8:1] is the upper 8 bits of SR (current remainder)
    wire [8:0] remainder = SR[8:1];
    wire [8:0] divisor_ext = {1'b0, NEG_DIVISOR}; // extend divisor to 9 bits unsigned for subtraction

    assign {sub_carry, sub_res} = {1'b0, remainder} + {1'b0, ~NEG_DIVISOR} + 9'b1; // remainder - NEG_DIVISOR

    // abs function for 8-bit signed input
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = (val[7]) ? (~val + 1'b1) : val;
        end
    endfunction

    // negate 8-bit value
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 1'b1;
        end
    endfunction

    // Sign extraction for signed inputs
    wire dividend_is_neg = sign & dividend[7];
    wire divisor_is_neg  = sign & divisor[7];

    // State machine and counters
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR         <= 9'd0;
            NEG_DIVISOR<= 8'd0;
            cnt        <= 4'd0;
            start_cnt  <= 1'b0;
            res_valid  <= 1'b0;
            result     <= 16'd0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            result_sign  <= 1'b0;
            rem_sign     <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Save abs dividend and divisor
                abs_dividend <= abs8(dividend);
                abs_divisor  <= abs8(divisor);
                dividend_sign<= dividend_is_neg;
                divisor_sign <= divisor_is_neg;
                result_sign  <= dividend_is_neg ^ divisor_is_neg;
                rem_sign     <= dividend_is_neg;

                // Initialize SR: abs_dividend shifted left 1 (9 bits)
                // SR[8:1] = abs_dividend, SR[0] = 0 initially (LSB of quotient)
                SR <= {abs8(dividend), 1'b0};

                // NEG_DIVISOR is negated abs_divisor
                NEG_DIVISOR <= neg8(abs8(divisor));

                cnt <= 4'd1;      // start counting from 1
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete
                    cnt <= 4'd0;
                    start_cnt <= 1'b0;

                    // Now SR contains remainder in upper 8 bits and quotient in lower 8 bits
                    // Apply sign correction if signed division
                    // Quotient sign: negate quotient if result_sign == 1
                    // Remainder sign: negate remainder if rem_sign == 1

                    // Extract quotient and remainder
                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned= SR[8:1];

                    if (sign) begin
                        // Apply sign correction for quotient
                        if (result_sign)
                            quotient_signed = neg8(quotient_unsigned);
                        else
                            quotient_signed = quotient_unsigned;

                        // Apply sign correction for remainder
                        if (rem_sign)
                            remainder_signed = neg8(remainder_unsigned);
                        else
                            remainder_signed = remainder_unsigned;

                        result <= {remainder_signed, quotient_signed};
                    end else begin
                        // Unsigned result directly
                        result <= {remainder_unsigned, quotient_unsigned};
                    end

                    res_valid <= 1'b1;
                end else begin
                    // Perform division iteration

                    // sub_carry indicates if remainder - divisor >= 0 (carry out from subtraction)
                    // If carry out = 1, means remainder >= divisor, so subtraction result is valid
                    // If sub_carry==0, subtraction result is negative, do not subtract

                    reg [8:0] new_SR;
                    reg q_bit;

                    if (sub_carry) begin
                        // subtraction success, next quotient bit = 1
                        q_bit = 1'b1;
                        // update remainder with subtraction result (sub_res)
                        new_SR = {sub_res[7:0], SR[0]} << 1 | q_bit;
                    end else begin
                        // subtraction fail, next quotient bit = 0
                        q_bit = 1'b0;
                        // remainder unchanged, shift left and append q_bit
                        new_SR = (SR << 1) | q_bit;
                    end

                    SR <= new_SR;
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Wait for result consumption: clear res_valid when opn_valid is low and res_valid is high
                res_valid <= 1'b0;
            end
        end
    end

endmodule