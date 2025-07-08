module radix2_div (
    input          clk,
    input          rst,
    input          sign,        // 1: signed, 0: unsigned
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result      // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;      // Shift register: {remainder(9 bits), quotient(8 bits)} but we only use 17 bits as dividend shifted left by 1 bit
    reg [7:0]  abs_dividend;
    reg [7:0]  abs_divisor;
    reg [7:0]  NEG_DIVISOR;       // Two's complement of divisor (absolute)
    reg [3:0]  cnt;               // 4 bits to count 0 to 8
    reg        start_cnt;
    reg        dividend_sign, divisor_sign, quotient_sign, remainder_sign;

    wire [8:0] sub_res;           // subtraction result (9 bits)
    wire       sub_carry_out;     // carry_out from subtraction (borrow for subtraction)
    wire       sub_borrow;        // borrow from subtraction (active low carry_out)
    wire [16:0] SR_next;

    // For subtraction: perform SR[16:8] - NEG_DIVISOR (where SR[16:8] holds partial remainder)
    // NEG_DIVISOR is two's complement of divisor absolute value

    // When performing subtraction, we do SR[16:8] + NEG_DIVISOR (since NEG_DIVISOR = -abs_divisor)
    // The subtraction borrow is indicated if the result is negative (carry_out == 0)

    assign {sub_carry_out, sub_res} = {1'b0, SR[16:8]} + {1'b0, NEG_DIVISOR}; // 9-bit add

    // Update SR with shift and quotient bit insertion
    // If no borrow (sub_carry_out==1), then quotient bit is 1 and remainder = sub_res
    // Else quotient bit is 0 and remainder unchanged

    wire [16:0] SR_substitute;  // SR after subtraction or not

    assign SR_substitute = sub_carry_out ? {sub_res, SR[7:0]} : SR;

    // Next SR: shift left by 1 and insert quotient bit at LSB (quotient bit = sub_carry_out)
    assign SR_next = {SR_substitute[15:0], sub_carry_out};

    // Compute absolute values and signs at operation start
    wire dividend_msb = dividend[7];
    wire divisor_msb = divisor[7];

    wire [7:0] abs_dividend_w = (sign && dividend_msb) ? (~dividend + 1) : dividend;
    wire [7:0] abs_divisor_w  = (sign && divisor_msb)  ? (~divisor + 1) : divisor;

    wire dividend_sign_w = (sign && dividend_msb);
    wire divisor_sign_w  = (sign && divisor_msb);

    // Quotient sign = dividend_sign xor divisor_sign
    wire quotient_sign_w = dividend_sign_w ^ divisor_sign_w;
    // Remainder sign = dividend_sign

    // Two's complement function
    function [7:0] twos_comp;
        input [7:0] val;
        begin
            twos_comp = ~val + 1;
        end
    endfunction

    // Registers for final quotient and remainder before sign correction
    reg [7:0] quotient_abs;
    reg [7:0] remainder_abs;

    // States: idle(ready for new op), busy(dividing), done(result valid)
    // We use start_cnt as busy indicator

    always @(posedge clk) begin
        if (rst) begin
            SR         <= 17'd0;
            cnt        <= 4'd0;
            start_cnt  <= 1'b0;
            res_valid  <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
            NEG_DIVISOR  <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign <= 1'b0;
            quotient_abs <= 8'd0;
            remainder_abs <= 8'd0;
            result <= 16'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Start operation
                // If divisor is zero, division is undefined; for simplicity, output zero result (can be extended later)
                if (divisor == 8'd0) begin
                    SR <= 17'd0;
                    cnt <= 4'd0;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                    quotient_abs <= 8'd0;
                    remainder_abs <= dividend;
                    result <= {8'd0, 8'd0}; // zero quotient and remainder
                end else begin
                    abs_dividend <= abs_dividend_w;
                    abs_divisor  <= abs_divisor_w;
                    NEG_DIVISOR  <= twos_comp(abs_divisor_w);
                    dividend_sign <= dividend_sign_w;
                    divisor_sign  <= divisor_sign_w;
                    quotient_sign <= quotient_sign_w;
                    remainder_sign <= dividend_sign_w;

                    // Initialize SR with dividend absolute shifted left by 1 bit
                    // SR[16:9] = 0, SR[8:1] = abs_dividend, SR[0]=0
                    SR <= {8'd0, abs_dividend_w, 1'b0};
                    cnt <= 4'd1;
                    start_cnt <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division done
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    // Extract quotient and remainder
                    remainder_abs <= SR[16:9];   // upper 8 bits (bits [16:9])
                    quotient_abs <= SR[8:1];    // next 8 bits (bits [8:1])
                    // Set res_valid next cycle to output corrected result
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                    SR <= SR_next;
                end
            end else if (res_valid && !opn_valid) begin
                // After presenting result, clear res_valid if no new operation starts
                res_valid <= 1'b0;
            end
        end
    end

    // Output result with sign correction applied combinationally when res_valid is high
    always @(*) begin
        if (res_valid) begin
            // Apply sign correction
            // Quotient sign
            if (sign && quotient_sign) begin
                result[7:0] = twos_comp(quotient_abs);
            end else begin
                result[7:0] = quotient_abs;
            end

            // Remainder sign (same sign as dividend)
            if (sign && remainder_sign) begin
                result[15:8] = twos_comp(remainder_abs);
            end else begin
                result[15:8] = remainder_abs;
            end
        end else begin
            // When result not valid, output zero
            result = 16'd0;
        end
    end

endmodule