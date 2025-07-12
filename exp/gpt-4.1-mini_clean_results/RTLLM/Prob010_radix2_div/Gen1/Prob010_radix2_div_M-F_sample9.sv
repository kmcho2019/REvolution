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
    wire [8:0] subtract_result;  // 9-bit subtraction result with carry out
    reg  [15:0] SR_shift_sub;    // next SR value after shift and possible subtraction

    // Temporary registers to hold final quotient and remainder for sign adjustment
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

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
                abs_divisor  <= divisor[7]  ? (~divisor  + 1) : divisor;
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

    // Main control: start division process and count cycles
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

    // Initialize SR at opn_valid (start of division)
    // SR = {abs_dividend, 1'b0} (left shifted by 1 bit)
    always @(posedge clk) begin
        if (rst) begin
            SR <= 16'd0;
        end else if (opn_valid && !res_valid) begin
            SR <= {abs_dividend, 1'b0};
        end else if (start_cnt && cnt != 0) begin
            SR <= SR_shift_sub;
        end
    end

    // Perform subtraction: upper 9 bits of SR + NEG_DIVISOR
    // SR upper 8 bits zero-extended to 9 bits
    wire [8:0] upper_SR_ext = {1'b0, SR[15:8]};
    assign subtract_result = upper_SR_ext + {1'b0, NEG_DIVISOR};

    // Next SR calculation combinational logic
    always @(*) begin
        if (subtract_result[8]) begin
            // subtraction successful (remainder >= divisor)
            // remainder = subtract_result[7:0], shift left, quotient bit=1
            SR_shift_sub = {subtract_result[7:0], SR[7:0]} << 1;
            SR_shift_sub[0] = 1'b1;
        end else begin
            // subtraction failed
            // remainder unchanged, shift left, quotient bit=0
            SR_shift_sub = {SR[15:8], SR[7:0]} << 1;
            SR_shift_sub[0] = 1'b0;
        end
    end

    // Manage result output and valid signal
    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 1'b0;
            result <= 16'd0;
            final_quotient <= 8'd0;
            final_remainder <= 8'd0;
            result_neg <= 1'b0;
        end else if (start_cnt && cnt == 8) begin
            // Division done: adjust signs if signed operation

            result_neg <= dividend_neg ^ divisor_neg;

            // Capture quotient and remainder from SR after last cycle
            final_quotient  <= SR_shift_sub[7:0];
            final_remainder <= SR_shift_sub[15:8];

            // Adjust signs in next cycle to avoid combinational loops
            // Actually assign result in this cycle since regs declared
            if (sign) begin
                // Adjust quotient sign
                if (result_neg)
                    final_quotient <= (~SR_shift_sub[7:0]) + 1'b1;
                else
                    final_quotient <= SR_shift_sub[7:0];
                // Adjust remainder sign: remainder sign same as dividend sign
                if (dividend_neg)
                    final_remainder <= (~SR_shift_sub[15:8]) + 1'b1;
                else
                    final_remainder <= SR_shift_sub[15:8];
            end else begin
                // unsigned, no sign adjustment
                final_quotient <= SR_shift_sub[7:0];
                final_remainder <= SR_shift_sub[15:8];
            end

            // Output combined result: remainder upper 8 bits, quotient lower 8 bits
            result <= {final_remainder, final_quotient};
            res_valid <= 1'b1;

        end else if (res_valid && opn_valid && !start_cnt) begin
            // Clear valid flag for new operation start
            res_valid <= 1'b0;
        end
    end

endmodule