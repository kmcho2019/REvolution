module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    reg [3:0] cnt;                 // counter (0-8)
    reg       start_cnt;

    reg [8:0] SR;                  // shift register: upper 8 bits remainder+carry, lower bits quotient+shifted-in bit
                                   // 9 bits to hold remainder+1 bit shifted in quotient
    reg [8:0] NEG_DIVISOR;         // negative divisor absolute value extended to 9 bits for subtraction

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    reg       dividend_neg;         // sign flags for dividend and divisor
    reg       divisor_neg;

    // Wires for subtraction of NEG_DIVISOR from SR[8:1]
    wire [8:0] sub_res;
    wire       sub_cout;

    // Variables for final quotient and remainder - declared at module scope to fix syntax errors
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Subtraction: SR upper 8 bits (SR[8:1]) - abs divisor (NEG_DIVISOR is negated divisor)
    // We do SR[8:1] + NEG_DIVISOR (NEG_DIVISOR is two's complement negation)
    assign {sub_cout, sub_res} = {1'b0, SR[8:1]} + NEG_DIVISOR;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt            <= 4'd0;
            start_cnt      <= 1'b0;
            SR             <= 9'd0;
            NEG_DIVISOR    <= 9'd0;
            abs_dividend   <= 8'd0;
            abs_divisor    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            final_quotient <= 8'd0;
            final_remainder<= 8'd0;
        end else begin
            // Start division on opn_valid (only if not running)
            if (opn_valid && !res_valid && !start_cnt) begin
                // Compute absolute values for signed operations
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    abs_dividend <= dividend[7] ? (~dividend + 8'd1) : dividend;
                    abs_divisor  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    abs_dividend <= dividend;
                    abs_divisor  <= divisor;
                end

                // Initialize shift register: dividend absolute value shifted left by 1 bit
                // SR[8:1] holds remainder, SR[0] holds next quotient bit (shifted in)
                SR <= {abs_dividend, 1'b0};

                // NEG_DIVISOR = - abs_divisor extended to 9 bits
                NEG_DIVISOR <= {1'b0, (~abs_divisor + 8'd1)}; // 9 bits

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process in progress
                if (cnt == 4'd8) begin
                    // Last step done: compute final result
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;

                    // Update SR one last time based on subtraction result
                    if (sub_cout) begin
                        // No borrow: subtraction successful, shift in 1
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // Borrow: keep SR, shift in 0
                        SR <= {SR[7:0], SR[0], 1'b0};
                    end

                    // Extract quotient and remainder
                    // quotient in SR[7:0]
                    // remainder in SR[8:1]
                    final_quotient  <= SR[7:0];
                    final_remainder <= SR[8:1];

                    // Apply sign correction on next cycle after this block
                end else begin
                    // Perform subtraction step
                    if (sub_cout) begin
                        // Subtraction no borrow: update SR upper bits with sub_res and shift left with inserting 1 in LSB
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // Borrow: keep SR upper bits, shift left with 0 in LSB
                        SR <= {SR[7:0], SR[0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                end
            end else if (res_valid) begin
                // Result is valid, waiting for consumption
                if (!opn_valid) begin
                    res_valid <= 1'b0; // Clear when result consumed
                end
            end

            // Apply sign correction and output result after division finishes
            if (!start_cnt && (final_quotient !== 8'd0 || final_remainder !== 8'd0) && !res_valid) begin
                reg [7:0] q_signed;
                reg [7:0] r_signed;

                q_signed = final_quotient;
                r_signed = final_remainder;

                if (sign) begin
                    if (dividend_neg ^ divisor_neg)
                        q_signed = (~final_quotient + 8'd1);
                    if (dividend_neg)
                        r_signed = (~final_remainder + 8'd1);
                end

                result    <= {r_signed, q_signed};
                res_valid <= 1'b1;

                // Clear finals after output to avoid repeated triggering
                final_quotient  <= 8'd0;
                final_remainder <= 8'd0;
            end
        end
    end

endmodule