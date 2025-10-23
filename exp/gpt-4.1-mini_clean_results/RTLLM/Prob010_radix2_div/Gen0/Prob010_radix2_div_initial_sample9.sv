module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // Internal signals
    reg [7:0]  dividend_reg;
    reg [7:0]  divisor_reg;
    reg        sign_reg;
    reg        start_cnt;
    reg [3:0]  cnt;          // 4 bits to count up to 8

    // Working variables for division
    reg [8:0]  SR;           // 9-bit shift register: [8:0], upper 8 bits remainder part + 1 bit extra for subtraction carry
    reg [8:0]  NEG_DIVISOR;  // 9 bits for subtraction, two's complement negation of absolute divisor

    // Sign flags for adjustment
    reg        dividend_sign; // 1 if dividend negative and sign=1, else 0
    reg        divisor_sign;  // 1 if divisor negative and sign=1, else 0
    wire       quotient_sign; // XOR of signs for quotient sign

    // Absolute values computation
    wire [7:0] abs_dividend;
    wire [7:0] abs_divisor;

    // Helper function: absolute value
    function [7:0] abs_val;
        input [7:0] val;
        input       is_signed;
        begin
            if (is_signed && val[7])
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    assign abs_dividend = abs_val(dividend, sign);
    assign abs_divisor  = abs_val(divisor,  sign);
    assign quotient_sign = dividend_sign ^ divisor_sign;

    // Division process registers
    reg [8:0] sub_res;  // Result of subtraction
    reg       sub_carry; // Carry out of subtraction (borrow)

    // Subtraction: SR[8:0] + NEG_DIVISOR to perform SR - divisor
    // NEG_DIVISOR is two's complement negation of divisor absolute value extended to 9 bits
    // Use adder to do subtraction: SR + NEG_DIVISOR
    wire [9:0] add_res;
    assign add_res = {1'b0, SR} + {1'b0, NEG_DIVISOR};

    // On reset or division finish, res_valid goes low; on division finish it is set high.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid     <= 1'b0;
            start_cnt     <= 1'b0;
            cnt           <= 4'd0;
            SR            <= 9'd0;
            NEG_DIVISOR   <= 9'd0;
            dividend_reg  <= 8'd0;
            divisor_reg   <= 8'd0;
            sign_reg      <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            result        <= 16'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs
                dividend_reg  <= dividend;
                divisor_reg   <= divisor;
                sign_reg      <= sign;

                // Compute signs
                dividend_sign <= (sign && dividend[7]);
                divisor_sign  <= (sign && divisor[7]);

                // Initialize SR with abs(dividend) shifted left by 1 bit (9 bits)
                // SR format: bits [8:1] = abs_dividend, bit 0 = 0
                SR <= {abs_dividend, 1'b0};

                // NEG_DIVISOR = two's complement negation of abs_divisor extended to 9 bits
                NEG_DIVISOR <= {1'b0, abs_divisor};
                NEG_DIVISOR <= (~{1'b0, abs_divisor}) + 10'd1;

                // Initialize counter and start signal
                cnt <= 4'd1;
                start_cnt <= 1'b1;

                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Perform subtraction: SR + NEG_DIVISOR
                // add_res is 10 bits, MSB is carry out
                sub_res <= add_res[8:0];
                sub_carry <= add_res[9];

                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // SR update on last step:
                    // If sub_carry == 1 means subtraction did not borrow (SR >= divisor)
                    // then assign SR = sub_res with last quotient bit set to 1
                    if (sub_carry) begin
                        SR <= sub_res;
                        SR[0] <= 1'b1;
                    end else begin
                        // Keep SR as is with quotient bit 0
                        SR <= SR;
                        SR[0] <= 1'b0;
                    end

                    // After finishing, adjust signs and output result
                    // Quotient is lower 8 bits of SR
                    // Remainder is upper 8 bits of SR shifted (SR[8:1])
                    // Adjust quotient sign
                    // Adjust remainder sign: same sign as dividend

                    // Calculate quotient and remainder in variables for sign adjustment
                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned = SR[8:1];

                    if (sign_reg) begin
                        // Quotient sign adjust
                        if (quotient_sign)
                            quotient_signed = (~quotient_unsigned + 1'b1);
                        else
                            quotient_signed = quotient_unsigned;

                        // Remainder sign adjust: same as dividend_sign
                        if (dividend_sign)
                            remainder_signed = (~remainder_unsigned + 1'b1);
                        else
                            remainder_signed = remainder_unsigned;
                    end else begin
                        // Unsigned division no sign adjustment
                        quotient_signed = quotient_unsigned;
                        remainder_signed = remainder_unsigned;
                    end

                    // Pack result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;
                end else begin
                    // Continue division steps
                    // If subtraction successful (no borrow), update SR with sub_res and set quotient bit = 1
                    // Else keep SR and set quotient bit = 0
                    if (sub_carry) begin
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        SR <= {SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Wait for next operation
                if (res_valid && !opn_valid) begin
                    // Clear result valid when result is consumed and no new operation
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule