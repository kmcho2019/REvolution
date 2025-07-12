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
    // Internal states
    reg busy; // operation in progress

    // Registers for sign and absolute values
    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit remainder register: upper 9 bits for remainder, lower bits for shifting in
    // Initialized with {8'b0, dividend_abs}
    reg [16:0] remainder_reg;

    // 8-bit quotient register
    reg [7:0] quotient_reg;

    // Counter for iteration (1 to 8)
    reg [3:0] count;

    // Subtraction result for checking remainder - divisor_abs
    reg [8:0] sub_res;

    // Flag to indicate the subtraction result >=0
    wire sub_non_negative;

    assign sub_non_negative = ~sub_res[8]; // MSB=0 means non-negative

    // Calculate absolute values and signs at start
    wire [7:0] dividend_abs_w = sign && dividend[7] ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_w  = sign && divisor[7]  ? (~divisor + 1)  : divisor;
    wire dividend_neg_w = sign ? dividend[7] : 1'b0;
    wire divisor_neg_w  = sign ? divisor[7]  : 1'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            remainder_reg <= 17'b0;
            quotient_reg <= 8'b0;
            count <= 4'd0;
            sub_res <= 9'd0;
        end else begin
            if (!busy && opn_valid) begin
                // Start operation: latch values
                dividend_abs <= dividend_abs_w;
                divisor_abs <= divisor_abs_w;
                dividend_neg <= dividend_neg_w;
                divisor_neg <= divisor_neg_w;
                sign_quotient <= dividend_neg_w ^ divisor_neg_w;
                sign_remainder <= dividend_neg_w;
                remainder_reg <= {9'd0, dividend_abs_w}; // remainder upper 9 bits cleared, lower 8 bits dividend
                quotient_reg <= 8'd0;
                count <= 4'd0;
                busy <= 1'b1;
                res_valid <= 1'b0;
            end else if (busy) begin
                // Perform division step

                // Shift remainder left by 1, bring in next quotient bit (will be decided after subtraction)
                // Shift left one bit:
                // remainder_reg[16:0] << 1 
                // Then subtract divisor_abs from upper 9 bits and check sign

                // First prepare shifted remainder for subtraction:
                // Shift left remainder_reg by 1 bit (bit 16 downto 1) and 0 in LSB
                // But we must do the subtraction after shift

                // So we shift remainder_reg by 1, then subtract divisor_abs (aligned to upper 9 bits)
                // Steps:
                // 1) shift remainder_reg left by 1: shifted = remainder_reg <<1
                // 2) subtract divisor_abs (9 bits) from upper 9 bits of shifted
                // 3) if subtraction >= 0: set quotient bit to 1, update remainder upper bits to subtraction result
                // 4) else: set quotient bit to 0, restore remainder to shifted without subtraction

                // Step 1: shift remainder left 1
                // For clarity, compute shift and subtraction in separate variables

                // Perform shift left 1
                reg [16:0] shifted;
                shifted = remainder_reg << 1;

                // Perform subtraction: upper 9 bits of shifted - divisor_abs
                // upper 9 bits: shifted[16:8], divisor_abs is 8 bits, extend divisor_abs to 9 bits
                sub_res = {1'b0, shifted[16:8]} - {1'b0, divisor_abs};

                if (sub_non_negative) begin
                    // subtraction positive or zero: update remainder upper bits with subtraction result
                    remainder_reg <= {sub_res[8:0], shifted[7:0]}; // upper bits updated with subtraction result, lower bits same as shifted
                    quotient_reg <= {quotient_reg[6:0], 1'b1};    // set quotient LSB bit to 1
                end else begin
                    // subtraction negative: do not update remainder upper bits, only shifted
                    remainder_reg <= shifted;
                    quotient_reg <= {quotient_reg[6:0], 1'b0};    // quotient bit 0
                end

                count <= count + 4'd1;

                if (count == 4'd7) begin
                    // Last iteration done (counts 0 to 7 for 8 steps)
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Correct quotient and remainder signs if signed
                    // remainder_reg upper 9 bits hold remainder (9 bits), remainder is 8 bits max, extra bit for sign extension
                    // The remainder is in remainder_reg[16:8] (9 bits), but only 8 bits meaningful - sign extended
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Extract remainder bits
                    final_remainder = remainder_reg[16:9]; // 8 bits remainder is remainder_reg[16:9]

                    // Sign corrections:
                    if (sign) begin
                        // quotient correction
                        if (sign_quotient) begin
                            final_quotient = (~quotient_reg + 1);
                        end else begin
                            final_quotient = quotient_reg;
                        end
                        // remainder correction
                        if (sign_remainder) begin
                            final_remainder = (~final_remainder + 1);
                        end
                    end else begin
                        final_quotient = quotient_reg;
                        final_remainder = remainder_reg[16:9];
                    end

                    result <= {final_remainder, final_quotient};
                end
            end else begin
                // Idle state, clear res_valid if opn_valid asserted again
                if (res_valid && opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end
endmodule