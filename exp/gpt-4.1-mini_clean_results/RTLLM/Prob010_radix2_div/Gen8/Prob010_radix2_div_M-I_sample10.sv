module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // Internal state signals
    reg [7:0]  dividend_reg;
    reg [7:0]  divisor_reg;

    // Absolute values and sign flags registered at input capture
    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    // 17-bit shift register:
    // Upper 9 bits: remainder
    // Lower 8 bits: partial quotient
    reg [16:0] SR;

    // Negated divisor extended to 9 bits for subtraction
    reg [8:0] neg_divisor;

    // Iteration counter 1..8
    reg [3:0] cnt;
    reg       running;    // Indicates division in progress

    wire divisor_zero = (divisor == 8'd0);

    // Combinational absolute values
    wire [7:0] dividend_abs_comb = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_comb  = (sign && divisor[7])  ? (~divisor  + 1) : divisor;

    // Subtraction: remainder - divisor_abs
    // remainder is upper 9 bits of SR
    wire [9:0] remainder_ext = {1'b0, SR[16:8]};
    wire [9:0] sub_res = remainder_ext + neg_divisor;
    wire       subtraction_success = sub_res[9]; // If MSB=1, no borrow (i.e., remainder >= divisor)

    // Update SR on each cycle depending on subtraction success:
    // Shift left SR by 1
    // If subtraction success: remainder = sub_res[8:0], quotient LSB=1
    // else: remainder unchanged (shifted left), quotient LSB=0

    always @(posedge clk) begin
        if (rst) begin
            dividend_reg   <= 8'd0;
            divisor_reg    <= 8'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            SR             <= 17'd0;
            neg_divisor    <= 9'd0;
            cnt            <= 4'd0;
            running        <= 1'b0;
            res_valid      <= 1'b0;
            result         <= 16'd0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg  <= divisor;

                    if (divisor_zero) begin
                        // Division by zero: output zero quotient and remainder immediately
                        result     <= 16'd0;
                        res_valid  <= 1'b1;
                        running    <= 1'b0;
                        cnt        <= 4'd0;
                    end else begin
                        // Register absolute values and signs for signed operation
                        dividend_abs  <= dividend_abs_comb;
                        divisor_abs   <= divisor_abs_comb;

                        dividend_neg  <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg   <= (sign) ? divisor[7]  : 1'b0;

                        quotient_neg  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        // Initialize SR:
                        // remainder = dividend_abs << 1 (9 bits)
                        // quotient = 0 (8 bits)
                        SR <= {dividend_abs_comb, 1'b0, 8'd0};

                        // neg_divisor = two's complement of divisor_abs extended to 9 bits
                        neg_divisor <= (~{1'b0, divisor_abs_comb} + 9'd1);

                        cnt <= 4'd1;
                        running <= 1'b1;
                    end
                end
            end else begin
                // Running division cycles
                // Each cycle: try subtract divisor from remainder, shift SR, set quotient bit

                if (cnt <= 8) begin
                    if (subtraction_success) begin
                        // remainder >= divisor, subtract
                        SR <= {sub_res[8:0], SR[7:0], 1'b1};
                    end else begin
                        // remainder < divisor, just shift left and quotient bit=0
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Division done, output results with sign correction

                    running <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder from SR
                    // remainder = upper 8 bits of remainder portion (bits 16:9)
                    // Note: remainder is bits [16:9], quotient is bits [7:0]
                    // remainder stored in bits [16:9], but remainder is 9 bits (upper 9 bits)
                    // Here we output remainder 8 bits only, the top bit was for shifting carry

                    // Use bits [16:9] for remainder value (9 bits), but output remainder 8 bits: discard LSB
                    // This matches initial shift left by one, so remainder should be bits [16:9] shifted right 1
                    // Actually, per original algorithm, remainder is stored shifted left by 1,
                    // the LSB (bit 9) is the shifted bit, so remainder is bits [16:9], so we output bits [16:9]

                    // We output remainder bits [16:9], but since remainder was shifted left once initially,
                    // the remainder is actually bits [16:9] shifted right once => bits [16:9] >> 1

                    // To avoid confusion, simply output bits [16:9] >>1 as remainder (8 bits)
                    // But the classic approach is to discard the LSB after shifting steps

                    // However, for clarity, simply output bits [16:9] as remainder (8 bits),
                    // matching the spec to put remainder in upper 8 bits, quotient in lower 8 bits.

                    // Sign-correct quotient and remainder

                    reg [7:0] quotient_out;
                    reg [7:0] remainder_out;

                    // quotient from bits [7:0]
                    quotient_out = quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];

                    // remainder from bits [16:9]
                    remainder_out = remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];

                    result <= {remainder_out, quotient_out};
                end
            end

            // Clear res_valid if new operation requested and division not running
            if (res_valid && opn_valid && !running) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule