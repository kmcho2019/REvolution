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
    reg [8:0] SR; // 9-bit shift register: upper 8 bits remainder, lower bit quotient bit
    reg [7:0] NEG_DIVISOR; // negated divisor absolute value
    reg [3:0] cnt; // 4-bit counter (max 8)
    reg start_cnt;

    // Registers to hold absolute values and sign info
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg dividend_sign;
    reg divisor_sign;

    // Wires for subtraction
    wire [8:0] sub_res;
    wire sub_carry;

    // Compute absolute values and signs
    wire [7:0] dividend_abs = sign && dividend[7] ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs = sign && divisor[7] ? (~divisor + 1) : divisor;

    // Subtraction: SR[8:1] - NEG_DIVISOR
    assign {sub_carry, sub_res} = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR};

    // Sign of quotient and remainder for signed division
    wire quotient_sign = sign && (dividend[7] ^ divisor[7]);
    wire remainder_sign = sign && dividend[7];

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            result <= 16'b0;
            SR <= 9'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end else begin
            if (res_valid && opn_valid) begin
                // Result consumed, clear res_valid to accept new operation
                res_valid <= 1'b0;
            end

            if (opn_valid && !res_valid && !start_cnt) begin
                // Latch inputs and initialize
                abs_dividend <= dividend_abs;
                abs_divisor <= divisor_abs;
                dividend_sign <= sign && dividend[7];
                divisor_sign <= sign && divisor[7];

                // Initialize SR: dividend_abs shifted left by 1 bit
                SR <= {dividend_abs, 1'b0};

                // NEG_DIVISOR = -abs_divisor
                NEG_DIVISOR <= (~divisor_abs) + 1;

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;

                    // Final remainder and quotient before sign correction
                    // SR[8:1] = remainder, SR[0] = last quotient bit
                    // Quotient is in SR[7:0], remainder in SR[8:1]
                    // Extract quotient and remainder
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    quotient_raw = SR[7:0];
                    remainder_raw = SR[8:1];

                    // Correct quotient sign if signed division
                    if (quotient_sign)
                        quotient_raw = (~quotient_raw) + 1;

                    // Correct remainder sign if signed division
                    if (remainder_sign)
                        remainder_raw = (~remainder_raw) + 1;

                    result <= {remainder_raw, quotient_raw};
                    res_valid <= 1'b1;
                end else begin
                    // Perform one division step
                    // If subtraction result carry out is 1, subtraction did not borrow, so quotient bit = 1
                    // Else quotient bit = 0 and SR upper bits remain unchanged
                    if (sub_carry) begin
                        // Subtraction successful, update SR upper bits with sub_res[7:0]
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // Subtraction failed, keep SR upper bits, shift left and insert 0 quotient bit
                        SR <= {SR[8:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule