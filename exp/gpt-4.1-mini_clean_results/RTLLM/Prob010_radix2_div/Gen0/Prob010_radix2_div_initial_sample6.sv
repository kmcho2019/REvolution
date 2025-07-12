module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output  reg     res_valid,
    output  reg [15:0] result
);

    // Internal registers and wires
    reg [8:0] SR;              // Shift register: 9 bits to hold remainder and quotient bits during division
    reg [8:0] NEG_DIVISOR;     // Negated divisor absolute value with one extra bit for subtraction
    reg [3:0] cnt;             // 4-bit counter for division steps (max 8)
    reg start_cnt;             // Start signal to enable division iterations

    // Registers to hold inputs latched
    reg [7:0] dividend_r;
    reg [7:0] divisor_r;
    reg sign_r;

    // Internal absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg dividend_sign;
    reg divisor_sign;

    // Quotient and remainder sign for final result adjustment
    reg quotient_sign;
    reg remainder_sign;

    // Temporary subtraction result
    wire [8:0] sub_res;
    wire       sub_carry;  // carry-out from subtraction

    // Compute absolute values and signs
    // For signed mode, extract sign bits and convert to absolute values with 2's complement if negative
    always @(*) begin
        if (sign_r) begin
            dividend_sign = dividend_r[7];
            divisor_sign  = divisor_r[7];
            dividend_abs  = dividend_sign ? (~dividend_r + 1'b1) : dividend_r;
            divisor_abs   = divisor_sign  ? (~divisor_r  + 1'b1) : divisor_r;
        end else begin
            dividend_sign = 1'b0;
            divisor_sign  = 1'b0;
            dividend_abs  = dividend_r;
            divisor_abs   = divisor_r;
        end
        quotient_sign = dividend_sign ^ divisor_sign;
        remainder_sign = dividend_sign;
    end

    // NEG_DIVISOR = 2's complement of divisor_abs extended to 9 bits
    // Extended to 9 bits so subtraction works properly with SR (which is 9 bits)
    always @(*) begin
        NEG_DIVISOR = {1'b0, ~divisor_abs} + 9'd1;
    end

    // Subtraction: SR + NEG_DIVISOR (which is SR - divisor_abs)
    assign {sub_carry, sub_res} = SR + NEG_DIVISOR;

    // Main sequential process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all state
            SR <= 9'd0;
            NEG_DIVISOR <= 9'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            dividend_r <= 8'd0;
            divisor_r <= 8'd0;
            sign_r <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Latch inputs and start operation
                dividend_r <= dividend;
                divisor_r <= divisor;
                sign_r <= sign;

                // Prepare shift register:
                // Load dividend absolute value shifted left by 1 bit:
                // The dividend absolute is 8 bits, shift left by 1 makes 9 bits,
                // Initially remainder bits are zero, quotient bits will be formed during division.
                // SR layout: [8:0], initially = dividend_abs << 1
                SR <= {dividend_abs, 1'b0};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division iterations
                // Perform subtraction step: SR - divisor_abs
                // sub_carry = 1 means no borrow (SR >= divisor_abs)
                // sub_carry = 0 means borrow occurred (SR < divisor_abs)
                if (cnt[3]) begin
                    // cnt[3] is the most significant bit of 4-bit cnt
                    // When cnt reaches 8 or more, division finished
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // Final SR contains remainder and quotient bits
                    // At end of loop SR layout:
                    // remainder in upper bits (bits 8 down to 1) and quotient in bit0 to bit7
                    // The quotient bits are in bits [7:0], remainder bits in [8:1]

                    // Adjust final quotient and remainder signs if signed
                    // quotient_abs = SR[7:0]
                    // remainder_abs = SR[8:1]

                    // Intermediate values
                    // We'll convert quotient and remainder back to signed if sign_r is high

                    // Signed adjustments done below

                    // Prepare result
                    // First assign remainder and quotient as unsigned
                    // Then adjust sign if needed

                    reg [7:0] quotient_abs;
                    reg [7:0] remainder_abs;
                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    quotient_abs = SR[7:0];
                    remainder_abs = SR[8:1];

                    // Adjust remainder sign: remainder sign = dividend sign
                    if (sign_r && remainder_sign && (remainder_abs != 8'd0))
                        remainder_final = (~remainder_abs + 1'b1);
                    else
                        remainder_final = remainder_abs;

                    // Adjust quotient sign: quotient sign = dividend_sign ^ divisor_sign
                    if (sign_r && quotient_sign && (quotient_abs != 8'd0))
                        quotient_final = (~quotient_abs + 1'b1);
                    else
                        quotient_final = quotient_abs;

                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;
                end else begin
                    // Perform next iteration
                    cnt <= cnt + 4'd1;

                    // If subtraction no borrow (sub_carry==1), update SR with sub_res shifted left and set bit0=1
                    // else shift SR left and bit0=0

                    if (sub_carry) begin
                        // SR = {sub_res[7:0], 1'b1}
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // SR = {SR[7:0], 1'b0}
                        SR <= {SR[7:0], 1'b0};
                    end
                end
            end else if (res_valid) begin
                // Wait for next op, res_valid remains until opn_valid starts again
                if (opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule