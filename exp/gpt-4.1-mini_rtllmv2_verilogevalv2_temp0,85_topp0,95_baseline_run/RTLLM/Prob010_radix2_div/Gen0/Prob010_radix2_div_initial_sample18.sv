module radix2_div (
    input           clk,
    input           rst,
    input           sign,       // 1=signed, 0=unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result     // [15:8] remainder, [7:0] quotient
);

    // Internal signals and registers
    reg [8:0] SR;           // Shift register: 9 bits: [8:1] remainder bits, [0] quotient bit
    reg [7:0] NEG_DIVISOR;  // Two's complement of divisor abs
    reg [3:0] cnt;
    reg       start_cnt;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg       dividend_sign;
    reg       divisor_sign;
    reg       quotient_sign;
    reg       remainder_sign;

    wire [8:0] sub_res;
    wire       sub_carry;

    // Compute absolute values and signs
    wire [7:0] dividend_abs_w = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_w  = (sign && divisor[7]) ? (~divisor + 1) : divisor;

    // Two's complement negation of divisor_abs for subtraction
    wire [7:0] neg_divisor_w = (~divisor_abs_w) + 1;

    // Subtraction: SR[8:1] + NEG_DIVISOR, since NEG_DIVISOR = -divisor_abs
    // Use 9-bit addition to detect borrow:
    // sub_res = SR[8:1] + NEG_DIVISOR
    assign {sub_carry, sub_res} = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR};

    // State machine and registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid    <= 0;
            SR           <= 0;
            NEG_DIVISOR  <= 0;
            cnt          <= 0;
            start_cnt    <= 0;
            dividend_abs <= 0;
            divisor_abs  <= 0;
            dividend_sign<= 0;
            divisor_sign <= 0;
            quotient_sign<= 0;
            remainder_sign<=0;
            result       <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs and initialize
                dividend_abs  <= dividend_abs_w;
                divisor_abs   <= divisor_abs_w;
                dividend_sign <= (sign) ? dividend[7] : 0;
                divisor_sign  <= (sign) ? divisor[7] : 0;
                // Quotient sign = dividend_sign XOR divisor_sign
                quotient_sign <= (sign) ? (dividend[7] ^ divisor[7]) : 0;
                remainder_sign<= (sign) ? dividend[7] : 0;

                // Initialize SR = dividend_abs << 1, 9 bits
                // Shift dividend_abs left by 1: bits [8:1], LSB quotient bit is 0 initially
                SR <= {dividend_abs_w, 1'b0};

                // NEG_DIVISOR = -divisor_abs_w
                NEG_DIVISOR <= (~divisor_abs_w) + 1;

                cnt <= 1;
                start_cnt <= 1;

                res_valid <= 0;
            end else if (start_cnt) begin
                // Perform division step
                if (cnt == 8) begin
                    // Division complete
                    start_cnt <= 0;
                    cnt <= 0;

                    // Final remainder and quotient from SR:
                    // SR[8:1] remainder, SR[0] quotient bit (last step)
                    // Compose 8-bit quotient from SR LSB + shifted bits during operation
                    // Quotient bits have been shifted into SR LSB every cycle
                    // But we need to adjust sign after division

                    // Extract unsigned quotient and remainder
                    // Quotient in lower 8 bits of SR shifted right by 1 (because we inserted bits at LSB)
                    // Actually, at each step, quotient bit inserted at SR[0], after 8 steps quotient is in SR[7:0]
                    // The final SR is 9 bits: remainder in bits [8:1], quotient bits in bits [0] + previously shifted in bits
                    // Actually quotient bits have been built in SR's lower 8 bits as we shift left each cycle inserting quotient bit at LSB

                    // So remainder = SR[8:1]
                    // Quotient = SR[7:0]

                    // Apply sign correction:
                    // Quotient = quotient_sign ? -quotient : quotient
                    // Remainder = remainder_sign ? -remainder : remainder

                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;
                    reg [7:0] signed_quotient;
                    reg [7:0] signed_remainder;

                    raw_remainder = SR[8:1];
                    raw_quotient = SR[7:0];

                    if (sign) begin
                        signed_quotient = quotient_sign ? (~raw_quotient + 1) : raw_quotient;
                        signed_remainder = remainder_sign ? (~raw_remainder + 1) : raw_remainder;
                    end else begin
                        signed_quotient = raw_quotient;
                        signed_remainder = raw_remainder;
                    end

                    result <= {signed_remainder, signed_quotient};
                    res_valid <= 1;

                end else begin
                    // Division ongoing

                    // Perform subtraction: SR[8:1] - divisor_abs_w (using addition with NEG_DIVISOR)
                    // If no borrow (sub_carry == 1), subtraction >= 0
                    // If subtraction >=0, set quotient bit to 1, SR = (sub_res << 1) | 1
                    // else quotient bit = 0, SR = (SR << 1) | 0

                    if (sub_carry) begin
                        // Subtraction result >=0, quotient bit = 1
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // Subtraction result <0, quotient bit = 0
                        SR <= {SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end else if (res_valid && !opn_valid) begin
                // Clear res_valid after result consumed (opn_valid low)
                res_valid <= 0;
            end
        end
    end
endmodule