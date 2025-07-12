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

    // Internal registers
    reg [15:0] SR;              // Shift register: upper 8 bits remainder, lower 8 bits quotient
    reg [7:0]  NEG_DIVISOR;     // Negated absolute divisor
    reg [3:0]  cnt;             // count cycles 1 to 8
    reg        start_cnt;       // division process active flag

    // Signed operand absolute values and sign bits
    reg [7:0] abs_dividend, abs_divisor;
    reg       dividend_neg, divisor_neg, result_neg;

    // Temporary variables for subtraction and mux selection
    wire [8:0] sub_res;  // 9-bit to hold subtraction result and carry out
    reg  [15:0] SR_shift_sub; // next SR value after shift and possible subtraction

    // Calculate absolute value for dividend and divisor and signs at opn_valid
    always @(posedge clk) begin
        if (rst) begin
            abs_dividend <= 0;
            abs_divisor  <= 0;
            dividend_neg <= 0;
            divisor_neg  <= 0;
        end else if (opn_valid && !res_valid) begin
            if (sign) begin
                dividend_neg <= dividend[7];
                divisor_neg  <= divisor[7];
                abs_dividend <= dividend[7] ? (~dividend + 1) : dividend;
                abs_divisor  <= divisor[7] ? (~divisor + 1)  : divisor;
            end else begin
                dividend_neg <= 0;
                divisor_neg  <= 0;
                abs_dividend <= dividend;
                abs_divisor  <= divisor;
            end
        end
    end

    // Prepare negated divisor for subtraction: NEG_DIVISOR = ~abs_divisor + 1
    always @(posedge clk) begin
        if (rst) begin
            NEG_DIVISOR <= 8'b0;
        end else if (opn_valid && !res_valid) begin
            NEG_DIVISOR <= ~abs_divisor + 1;
        end
    end

    // Main control: start division process
    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
            start_cnt <= 0;
        end else if (opn_valid && !res_valid) begin
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end else begin
            cnt <= 0;
            start_cnt <= 0;
        end
    end

    // Initialize SR at start_cnt==1 (first cycle)
    // SR = {abs_dividend[7:0], 1'b0} shifted left by 1 bit => {abs_dividend, 1'b0}
    always @(posedge clk) begin
        if (rst) begin
            SR <= 0;
        end else if (opn_valid && !res_valid) begin
            SR <= {abs_dividend, 1'b0}; // left-shifted dividend (multiplied by 2)
        end else if (start_cnt && cnt != 0) begin
            // Perform division iteration
            // We'll do this below outside, using combinational signals
            SR <= SR_shift_sub;
        end
    end

    // Subtract divisor from the upper 9 bits of SR + insert quotient bit accordingly
    wire [8:0] upper_SR_plus = {1'b0, SR[15:8]}; // upper 8 bits remainder extended with 0 carry
    wire [8:0] subtract_result = upper_SR_plus + {1'b0, NEG_DIVISOR}; // subtract divisor by adding two's complement

    // Decide quotient bit and next remainder:
    // If MSB of subtract_result == 1, means remainder >= divisor, subtraction successful
    // Then shift left and put quotient bit 1 at SR[0]
    // Else quotient bit 0 and remainder unchanged (shift left remainder)
    wire carry_out = subtract_result[8]; // if 1 means remainder >= divisor

    // Next SR calculation combinational
    always @(*) begin
        if (carry_out) begin
            // subtraction successful => remainder = subtract_result[7:0]
            // shift left by 1 and insert quotient bit 1 at LSB
            SR_shift_sub = {subtract_result[7:0], SR[7:0]} << 1;
            SR_shift_sub[0] = 1'b1;
        end else begin
            // subtraction failed => remainder unchanged
            // shift left by 1 and insert quotient bit 0
            SR_shift_sub = {SR[15:8], SR[7:0]} << 1;
            SR_shift_sub[0] = 1'b0;
        end
    end

    // Result sign and output formatting
    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            result <= 0;
        end else if (start_cnt && cnt == 8) begin
            // Division finished at cnt == 8
            // Calculate final result sign
            result_neg <= dividend_neg ^ divisor_neg;

            // Compose remainder and quotient
            // Remainder is upper 8 bits of SR_shift_sub (after last shift)
            // Quotient is lower 8 bits of SR_shift_sub
            // For signed results, revert quotient and remainder sign accordingly

            // Default outputs unsigned
            reg [7:0] final_quotient;
            reg [7:0] final_remainder;

            final_quotient = SR_shift_sub[7:0];
            final_remainder = SR_shift_sub[15:8];

            if (sign) begin
                // Adjust quotient sign
                if (result_neg) begin
                    final_quotient = (~final_quotient) + 1;
                end
                // Adjust remainder sign: remainder sign same as dividend sign
                if (dividend_neg) begin
                    final_remainder = (~final_remainder) + 1;
                end
            end

            result <= {final_remainder, final_quotient};
            res_valid <= 1;
        end else if (res_valid && opn_valid && !start_cnt) begin
            // Clear result valid after new operation starts
            res_valid <= 0;
        end
    end

endmodule