module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs to registers for stable use
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: shift-subtract long division
    always @(*) begin
        integer i;
        reg [16:0] remainder;      // 17 bits to accommodate shift + dividend bit
        reg [15:0] quotient;
        reg [8:0]  div_candidate;

        remainder = 17'b0;
        quotient  = 16'b0;

        // Initialize remainder with zero
        // We will shift in bits of dividend starting from MSB to LSB, total 16 times
        // Each step: shift remainder left by 1, bring next dividend bit in LSB of remainder
        // Then compare remainder[16:9] with divisor and subtract if possible

        // Start division loop over all bits of dividend, from MSB to LSB
        // Since divisor is 8-bit, remainder upper 9 bits are compared with divisor

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1
            remainder = {remainder[15:0], a_reg[i]};

            // Compare upper 9 bits of remainder with divisor:
            // remainder[16:8] is 9 bits, divisor is 8 bits, so we compare accordingly
            // Actually, divisor is 8 bits, remainder upper 9 bits; since remainder upper 9 bits can be larger
            // We only subtract divisor (8 bits) from lower 8 bits of remainder if remainder top 9 bits >= divisor

            div_candidate = remainder[16:8]; // 9 bits to compare with 8-bit divisor (extend divisor to 9 bits for compare)
            if (div_candidate >= b_reg) begin
                div_candidate = div_candidate - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end

            // Update remainder[16:8] with div_candidate (subtracted or unchanged)
            remainder[16:8] = div_candidate;
        end

        result = quotient;
        // The remainder after division is in remainder[16:8] (9 bits), but remainder can't exceed divisor
        // Remainder fits into 8 bits; the MSB (bit 16) of remainder is always zero here due to subtraction logic
        // So assign remainder lower 8 bits = remainder[15:8], upper 8 bits zero
        odd = {8'b0, remainder[15:8]};
    end

endmodule