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

    reg [7:0] dividend_reg, divisor_reg;
    reg [7:0] abs_dividend, abs_divisor;
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    reg [16:0] SR; // 9-bit quotient + 8-bit remainder + 1 extra bit for shift
    reg [7:0] NEG_DIVISOR;
    reg start_cnt;
    reg [3:0] cnt; // count from 0 to 8 (need 4 bits)

    wire [8:0] sub_res;
    wire sub_carry;

    // To calculate absolute values and sign bits
    // signed inputs handling
    wire [7:0] dividend_abs_wire = sign && dividend[7] ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_wire = sign && divisor[7] ? (~divisor + 1) : divisor;

    // Negated divisor for subtraction: 2's complement
    wire [7:0] neg_divisor_wire = ~abs_divisor + 1;

    // Subtraction: SR[16:9] is remainder (9 bits including carry bit for subtraction)
    // but remainder part is 8 bits, and an extra bit to hold sign for subtraction
    // We do subtraction: remainder - divisor, with remainder in upper 9 bits (SR[16:8])
    // Actually, SR is 17 bits: bits [16:9] remainder (8 bits + 1 bit for subtraction), bits [8:1] quotient shifted, bit 0 is the new quotient bit being inserted.
    // For subtraction, take upper 9 bits SR[16:8] as minuend and subtract divisor(8 bits) extended to 9 bits.

    wire [8:0] remainder = {1'b0, SR[16:9]}; // 9 bits remainder (1 MSB zero-extended)
    wire [8:0] divisor_ext = {1'b0, NEG_DIVISOR}; // neg divisor extended to 9 bits

    assign {sub_carry, sub_res} = remainder + divisor_ext; // remainder - divisor (since divisor_ext is negated divisor)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            start_cnt <= 0;
            cnt <= 0;
            SR <= 0;
            dividend_reg <= 0;
            divisor_reg <= 0;
            abs_dividend <= 0;
            abs_divisor <= 0;
            NEG_DIVISOR <= 0;
            dividend_sign <= 0;
            divisor_sign <= 0;
            quotient_sign <= 0;
            remainder_sign <= 0;
            result <= 0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Latch inputs and prepare initial state for division
                dividend_reg <= dividend;
                divisor_reg <= divisor;

                dividend_sign <= sign && dividend[7];
                divisor_sign <= sign && divisor[7];

                abs_dividend <= dividend_abs_wire;
                abs_divisor <= divisor_abs_wire;

                // NEG_DIVISOR is negative absolute divisor (2's complement)
                NEG_DIVISOR <= ~divisor_abs_wire + 1;

                // quotient sign = dividend_sign XOR divisor_sign
                quotient_sign <= (sign && (dividend[7] ^ divisor[7]));
                // remainder sign = dividend_sign (remainder has dividend's sign)
                remainder_sign <= (sign && dividend[7]);

                // Initialize SR: left shift absolute dividend by 1 bit, store at SR[16:9] remainder bits + 1 bit zero + quotient bits 0
                // SR[16:9] = 8 bits dividend shifted left by 1 (so 9 bits)
                // Actually, SR is 17 bits:
                // SR[16:9] = remainder bits (9 bits, initialized to dividend << 1)
                // SR[8:1] = quotient bits (all zero)
                // SR[0] = new bit shifted in (zero)
                SR <= {abs_dividend, 8'b0} << 1;

                cnt <= 1;
                start_cnt <= 1;
                res_valid <= 0;
            end else if (start_cnt) begin
                // Start division iterative process
                if (cnt == 8) begin
                    // Division complete
                    start_cnt <= 0;
                    cnt <= 0;

                    // After division, adjust quotient and remainder for sign if signed division

                    // Extract quotient and remainder
                    // Quotient bits are in SR[8:1], remainder in SR[16:9]
                    // Because we shifted dividend left by 1, the quotient is in bits [8:1]
                    // remainder in bits [16:9]
                    // So extract:
                    // remainder: SR[16:9] (8 bits)
                    // quotient: SR[8:1] (8 bits)

                    // Store them in temp registers for sign adjustment
                    reg [7:0] q;
                    reg [7:0] r;
                    q = SR[8:1];
                    r = SR[16:9];

                    // Adjust signs if signed operation
                    if (sign) begin
                        // Adjust quotient sign
                        if (quotient_sign)
                            q = ~q + 1;
                        // Adjust remainder sign
                        if (remainder_sign)
                            r = ~r + 1;
                    end

                    result <= {r, q};
                    res_valid <= 1;
                end else begin
                    // Iteration step:
                    // Compute subtraction: remainder - divisor
                    // remainder in SR[16:9], divisor negated in NEG_DIVISOR
                    // sub_res and sub_carry calculated above

                    // If subtraction result is non-negative (sub_carry == 1), update remainder and set quotient bit to 1
                    // else restore old remainder, quotient bit set to 0

                    if (sub_carry) begin
                        // remainder = sub_res[7:0]
                        // Shift SR left 1 bit, input quotient bit = 1
                        SR <= {sub_res[7:0], SR[8:1], 1'b1};
                    end else begin
                        // remainder unchanged (SR[16:9]), shift SR left 1 bit, input quotient bit = 0
                        SR <= {SR[16:9], SR[8:1], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end else if (res_valid && !opn_valid) begin
                // When result is valid and operation is not requested, clear valid to allow next operation
                res_valid <= 0;
            end
        end
    end

endmodule