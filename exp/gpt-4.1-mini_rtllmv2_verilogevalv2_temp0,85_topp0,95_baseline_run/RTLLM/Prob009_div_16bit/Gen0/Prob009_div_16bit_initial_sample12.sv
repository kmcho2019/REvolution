module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division algorithm combinational block
    // Restoring division: shift-subtract method
    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;

    always @(*) begin
        quotient  = 16'b0;
        remainder = 16'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next bit of a_reg
            remainder = {remainder[14:0], a_reg[i]};
            // Compare remainder's top 8 bits with divisor
            // Since divisor is 8-bit, we consider remainder[15:8] as the "higher bits"
            // but in the problem, the remainder is used for comparison against divisor directly.
            // So, compare remainder[7:0] with b_reg, but remainder is 16-bit and divisor 8-bit:
            // According to the problem, compare highest bits matching divisor width:
            // So compare remainder[15:8] with b_reg?
            // The problem states: extract higher bits of dividend, matching width of divisor.
            // But here, the remainder is constructed from bits shifted in. So we compare remainder[15:8]
            // The algorithm is usually: remainder >= divisor?
            // We can treat remainder as 16-bit, but divisor 8-bit, so compare remainder[15:8] with divisor.
            // But the problem states to compare bits matching divisor width.
            // To clarify, compare remainder[15:8] with b_reg, if greater or equal, subtract.
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor from remainder's higher bits
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        result = quotient;
        odd = remainder;
    end

endmodule