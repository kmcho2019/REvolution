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

    // Internal registers
    reg [7:0]  dividend_reg;
    reg [7:0]  divisor_reg;

    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    reg [3:0]  cnt;            // Count iteration steps 0 to 8
    reg        running;

    // Separate remainder and quotient registers
    reg [8:0]  remainder;      // 9-bit remainder for shift and subtraction
    reg [7:0]  quotient;

    wire       divisor_zero = (divisor == 8'd0);

    // Combinational absolute value calculation for signed inputs
    wire [7:0] dividend_abs_comb = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_comb  = (sign && divisor[7])  ? (~divisor  + 8'd1) : divisor;

    // Negated divisor extended to 9 bits for subtraction
    wire [8:0] neg_divisor = (~{1'b0, divisor_abs} + 9'd1);

    // Subtraction result and borrow from remainder + negated divisor
    wire [9:0] sub_full = {1'b0, remainder} + neg_divisor;
    wire       sub_borrow = ~sub_full[9];   // borrow is inverse of carry out in addition with negative operand

    // At division completion, adjust quotient and remainder signs
    wire [7:0] quotient_signed = quotient_neg ? (~quotient + 8'd1) : quotient;
    wire [7:0] remainder_signed = remainder_neg ? (~remainder[7:0] + 8'd1) : remainder[7:0];

    always @(posedge clk) begin
        if (rst) begin
            // Reset all state and outputs
            dividend_reg   <= 8'd0;
            divisor_reg    <= 8'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            remainder      <= 9'd0;
            quotient       <= 8'd0;
            cnt            <= 4'd0;
            running        <= 1'b0;
            res_valid      <= 1'b0;
            result         <= 16'd0;
        end else begin
            if (!running) begin
                // Idle state: wait for new operation if no running division
                res_valid <= 1'b0;

                if (opn_valid && !res_valid) begin
                    // Capture inputs synchronously
                    dividend_reg <= dividend;
                    divisor_reg  <= divisor;

                    // Handle division by zero: output zero result immediately
                    if (divisor_zero) begin
                        quotient     <= 8'd0;
                        remainder    <= 9'd0;
                        res_valid    <= 1'b1;
                        running      <= 1'b0;
                        result       <= 16'd0;
                    end else begin
                        // Determine absolute values and signs for signed operation
                        dividend_abs  <= dividend_abs_comb;
                        divisor_abs   <= divisor_abs_comb;

                        dividend_neg  <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg   <= (sign) ? divisor[7]  : 1'b0;

                        quotient_neg  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        // Initialize remainder with dividend_abs shifted left by 1 (9 bits)
                        remainder    <= {dividend_abs_comb, 1'b0};
                        quotient     <= 8'd0;

                        cnt          <= 4'd0;
                        running      <= 1'b1;
                        res_valid    <= 1'b0;
                    end
                end
            end else begin
                // Running division: perform radix-2 division step each cycle
                if (cnt < 8) begin
                    if (sub_borrow == 1'b1) begin
                        // remainder >= divisor: subtraction succeeded, update remainder and set quotient bit to 1
                        remainder <= sub_full[8:0];             // remainder = remainder - divisor
                        quotient  <= {quotient[6:0], 1'b1};    // shift quotient left and insert 1
                    end else begin
                        // subtraction failed: keep remainder, shift quotient left and insert 0
                        remainder <= {remainder[7:0], 1'b0};
                        quotient  <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Division complete after 8 steps
                    running <= 1'b0;
                    res_valid <= 1'b1;

                    // Output result with sign correction if needed
                    result <= {remainder_neg ? (~remainder[7:0] + 8'd1) : remainder[7:0], 
                               quotient_neg  ? (~quotient + 8'd1)      : quotient};
                end
            end

            // Clear result valid if new operation requested and currently not running
            if (res_valid && opn_valid && !running) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule