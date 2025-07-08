module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);
    // Internal registers
    reg [8:0] SR;         // Shift register: 9 bits to hold remainder + quotient bits during division
    reg [7:0] NEG_DIVISOR; // Negated divisor absolute value
    reg [3:0] cnt;        // 4-bit counter (count up to 8)
    reg start_cnt;        // Indicates division in progress

    // Registers to hold absolute values and sign bits of operands
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg dividend_sign;
    reg divisor_sign;

    wire dividend_sign_bit;
    wire divisor_sign_bit;

    // Extract sign bits if signed operation
    assign dividend_sign_bit = sign ? dividend[7] : 1'b0;
    assign divisor_sign_bit  = sign ? divisor[7]  : 1'b0;

    // Absolute value calculation function
    function [7:0] abs_val;
        input [7:0] val;
        input sign_bit;
        begin
            if(sign_bit)
                abs_val = (~val) + 1;
            else
                abs_val = val;
        end
    endfunction

    // Two's complement negate for 8 bits
    function [7:0] negate_8bit;
        input [7:0] val;
        begin
            negate_8bit = (~val) + 1;
        end
    endfunction

    // Subtraction: SR[8:1] - NEG_DIVISOR
    wire [8:0] sub_result;
    wire sub_borrow;

    assign {sub_borrow, sub_result} = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR};

    // Division process
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            SR <= 9'd0;
            NEG_DIVISOR <= 8'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end else begin
            if(opn_valid && !res_valid) begin
                // Start new operation
                dividend_abs <= abs_val(dividend, dividend_sign_bit);
                divisor_abs <= abs_val(divisor, divisor_sign_bit);
                dividend_sign <= dividend_sign_bit;
                divisor_sign <= divisor_sign_bit;

                // Initialize SR with dividend_abs shifted left by 1 bit (9 bits)
                SR <= {dividend_abs, 1'b0};

                // NEG_DIVISOR = -divisor_abs (two's complement negate)
                NEG_DIVISOR <= negate_8bit(abs_val(divisor, divisor_sign_bit));

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if(start_cnt) begin
                if(cnt == 4'd8) begin
                    // Division complete, stop counting
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // At this point:
                    // SR[8:1] = remainder (possibly negative)
                    // SR[0]   = last quotient bit

                    // Quotient is lower 8 bits of SR[7:0]
                    // Remainder is upper 8 bits to be corrected for sign

                    // Compute quotient and remainder sign correction
                    // quotient_sign = dividend_sign ^ divisor_sign
                    // remainder_sign = dividend_sign

                    // Reconstruct quotient and remainder from SR
                    reg [7:0] quotient;
                    reg [7:0] remainder;

                    quotient = SR[7:0];
                    remainder = SR[8:1];

                    // If signed, correct quotient sign
                    if(sign) begin
                        if(dividend_sign ^ divisor_sign) begin
                            // quotient = -quotient
                            quotient = negate_8bit(quotient);
                        end
                        if(dividend_sign) begin
                            // remainder = -remainder
                            remainder = negate_8bit(remainder);
                        end
                    end

                    // Pack result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder, quotient};
                    res_valid <= 1'b1;

                end else begin
                    // Division iteration step

                    // If subtraction result is non-negative (borrow=0), shift in 1 to quotient
                    // Otherwise shift in 0 and keep old remainder
                    if(!sub_borrow) begin
                        // subtraction succeeded, load sub_result and shift in 1 to quotient bits
                        SR <= {sub_result[7:0], SR[0], 1'b1};
                    end else begin
                        // subtraction failed, keep SR[8:1] as is, shift in 0
                        SR <= {SR[7:0], 1'b0};
                    end

                    cnt <= cnt + 1'b1;
                end
            end else if(res_valid && !opn_valid) begin
                // Clear res_valid once result consumed and no new operation
                res_valid <= 1'b0;
            end
        end
    end
endmodule