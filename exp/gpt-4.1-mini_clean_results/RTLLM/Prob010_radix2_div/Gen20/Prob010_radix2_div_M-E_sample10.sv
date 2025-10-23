module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);

    // Internal signals and registers
    reg [7:0] abs_dividend, abs_divisor;
    reg       dividend_neg, divisor_neg;

    reg [16:0] shift_reg; // [16:8] remainder (9 bits), [7:0] quotient (8 bits)
    reg [3:0]  cnt;       // iteration counter 0 to 8
    reg        busy;      // division in progress flag

    wire [8:0] partial_remainder = shift_reg[16:8];
    wire [8:0] divisor_9 = {1'b0, abs_divisor};

    // Subtraction result: remainder - divisor
    wire [9:0] sub_res = {1'b0, partial_remainder} - {1'b0, divisor_9};

    // Compute absolute values with sign detection
    // This function converts signed input to magnitude if sign==1
    function [7:0] abs_val;
        input [7:0] val;
        input       is_signed;
        begin
            if (is_signed && val[7])
                abs_val = (~val) + 8'd1;
            else
                abs_val = val;
        end
    endfunction

    // State machine logic folded into busy and cnt signals with clear start conditions

    // Start signal for operation (load inputs and begin division)
    wire start_div = opn_valid && !busy && !res_valid;

    // Sign of quotient and remainder for correction after division complete
    reg quotient_neg, remainder_neg;

    // Division by zero flag
    reg div_by_zero;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid     <= 1'b0;
            result        <= 16'b0;
            shift_reg     <= 17'b0;
            cnt           <= 4'd0;
            busy          <= 1'b0;
            abs_dividend  <= 8'b0;
            abs_divisor   <= 8'b0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;
            div_by_zero   <= 1'b0;
        end else begin
            if (start_div) begin
                // Latch absolute values and signs
                dividend_neg  <= sign && dividend[7];
                divisor_neg   <= sign && divisor[7];
                abs_dividend  <= abs_val(dividend, sign);
                abs_divisor   <= abs_val(divisor, sign);
                // Sign of quotient = dividend_sign XOR divisor_sign
                quotient_neg  <= (sign && (dividend[7] ^ divisor[7]));
                // Sign of remainder = dividend_sign
                remainder_neg <= (sign && dividend[7]);

                div_by_zero   <= (divisor == 8'b0);

                // Initialize shift_reg:
                // Place dividend (abs) in remainder part shifted left by 1 bit (9 bits),
                // quotient initialized to zero
                // shift_reg = {abs_dividend, 1'b0, 8'b0}
                // partial remainder = 9 bits (dividend shifted left 1)
                shift_reg <= {abs_val(dividend, sign), 1'b0, 8'b0};

                cnt       <= 4'd0;
                busy      <= 1'b1;
                res_valid <= 1'b0;
            end else if (busy) begin
                if (cnt < 4'd8) begin
                    // Perform one iteration of division
                    // Subtract divisor from partial remainder (MSB 9 bits)
                    if (!div_by_zero && !sub_res[9]) begin
                        // subtraction successful (non-negative result)
                        // set quotient bit to 1
                        // shift remainder left by 1 bit with subtracted value
                        // shift quotient left by 1 and set LSB=1
                        shift_reg <= {sub_res[8:0], shift_reg[7:1], 1'b1};
                    end else begin
                        // subtraction failed (negative result)
                        // leave remainder unchanged
                        // shift quotient left by 1 and set LSB=0
                        shift_reg <= {partial_remainder, shift_reg[7:1], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Division complete
                    busy <= 1'b0;
                    cnt  <= 4'd0;

                    // Extract quotient and remainder from shift_reg
                    // remainder is 8 bits from shift_reg[16:9] (discard 1 bit LSB)
                    // quotient is 8 bits from shift_reg[7:0]

                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    if (div_by_zero) begin
                        // Division by zero: quotient = 0, remainder = dividend
                        final_quotient = 8'b0;
                        final_remainder = abs_dividend;
                    end else begin
                        final_quotient = shift_reg[7:0];
                        final_remainder = shift_reg[16:9];
                    end

                    // Correct quotient sign if signed
                    if (quotient_neg) final_quotient = (~final_quotient) + 8'd1;
                    // Correct remainder sign if signed
                    if (remainder_neg) final_remainder = (~final_remainder) + 8'd1;

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Clear res_valid when consumer has read result (indicated by opn_valid going low)
                res_valid <= 1'b0;
            end
        end
    end
endmodule