module radix2_div (
    input            clk,
    input            rst,
    input            sign,           // 1: signed division, 0: unsigned division
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,      // Start operation signal, when high & not busy
    output reg       res_valid,      // Result valid signal
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // Internal signals
    reg [8:0] remainder;     // 9-bit remainder register (extra bit for subtraction)
    reg [7:0] quotient;      // 8-bit quotient register
    reg [7:0] divisor_mag;   // Absolute value of divisor
    reg [7:0] dividend_mag;  // Absolute value of dividend
    reg       dividend_neg;  // Dividend sign
    reg       divisor_neg;   // Divisor sign

    reg [3:0] count;         // Count from 0 to 8 cycles
    reg       busy;          // Indicates division in progress

    // Sign correction flags
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Internal signals for next-step calculations
    reg [8:0] remainder_sub; // Result of remainder - divisor_mag
    reg       subtract_suc;  // Indicates subtraction was successful (no borrow)

    // Absolute value calculation helper function
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    // Sequential logic for division operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            remainder   <= 9'd0;
            quotient    <= 8'd0;
            divisor_mag <= 8'd0;
            dividend_mag<= 8'd0;
            dividend_neg<= 1'b0;
            divisor_neg <= 1'b0;
            count       <= 4'd0;
            busy        <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;   // Clear result valid when not busy

                if (opn_valid && (divisor != 8'd0)) begin
                    // Start new division operation: latch inputs
                    dividend_neg <= sign ? dividend[7] : 1'b0;
                    divisor_neg  <= sign ? divisor[7]  : 1'b0;

                    dividend_mag <= abs8(dividend);
                    divisor_mag  <= abs8(divisor);

                    remainder    <= 9'd0;         // Start remainder = 0
                    quotient     <= abs8(dividend); // Initial quotient = dividend magnitude

                    count        <= 4'd0;
                    busy         <= 1'b1;
                end
                // If divisor == 0 and opn_valid asserted, remain idle and do not start division
                // Could add division-by-zero flag here if desired
            end else begin
                // Division iteration step

                // Shift left remainder and bring in MSB of quotient into remainder LSB
                // remainder[8:1] = remainder[7:0] shifted left by 1 + quotient MSB
                // quotient shifts left by 1 next cycle
                remainder <= {remainder[7:0], quotient[7]};

                // Subtract divisor magnitude from remainder
                remainder_sub = {1'b0, remainder[8:1]} - {1'b0, divisor_mag};

                if (!remainder_sub[8]) begin
                    // Subtraction successful (no borrow)
                    subtract_suc = 1'b1;
                    remainder[8:1] <= remainder_sub[7:0];
                end else begin
                    // Subtraction failed, restore remainder
                    subtract_suc = 1'b0;
                    remainder[8:1] <= remainder[8:1]; // no change
                end

                // Update quotient: shift left by 1 and insert subtract_suc at LSB
                quotient <= {quotient[6:0], subtract_suc};

                count <= count + 1'b1;

                if (count == 4'd7) begin
                    // Completed 8 division cycles

                    // Finish remainder update for last cycle
                    // Perform subtraction for last shifted remainder
                    remainder_sub = {1'b0, remainder[7:0]} - {1'b0, divisor_mag};
                    if (!remainder_sub[8]) begin
                        remainder[8:1] <= remainder_sub[7:0];
                        subtract_suc = 1'b1;
                    end else begin
                        subtract_suc = 1'b0;
                    end

                    quotient <= {quotient[6:0], subtract_suc};

                    busy <= 1'b0;
                    count <= 4'd0;

                    // Sign corrections
                    // Quotient: negate if quotient_neg
                    if (quotient_neg)
                        quotient <= (~quotient) + 8'd1;

                    // Remainder: remainder[8:1] is the magnitude, negate if remainder_neg
                    if (remainder_neg)
                        remainder[8:1] <= (~remainder[8:1]) + 8'd1;

                    // Prepare output: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder[8:1], quotient};
                    res_valid <= 1'b1;
                end
            end
        end
    end

endmodule