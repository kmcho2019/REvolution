module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        integer i;

        quotient = 0;
        remainder = 0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down the next bit from a_reg
            remainder = (remainder << 1) | ((a_reg >> i) & 1'b1);

            // Compare upper bits of remainder (matching divisor width) with divisor
            // Extract high 8 bits of remainder for comparison
            // But remainder may be wider (16-bit), here the divisor is 8-bit,
            // so we just compare remainder[15:8] or since remainder is growing from bits
            // Actually, in classical restoring division, we compare full remainder with divisor
            // The problem states to extract higher bits of remainder matching divisor width,
            // so we compare remainder[15:8] with divisor b_reg

            // However, since remainder is 16-bit, the higher 8 bits is remainder[15:8]
            // but the 'higher bits' in the problem means the 'most significant bits' matching divisor width
            // We can implement the comparison as remainder[15:8] >= b_reg

            // But for proper division, the comparison should be with full remainder against divisor,
            // since remainder is the current partial remainder shifted in with dividend bits,
            // and divisor is 8-bit. Actually the original problem wants to extract the highest bits of dividend matching divisor's width,
            // so here, we interpret it as comparing remainder[15:8] to b_reg

            // If remainder[15:8] >= b_reg, subtract and set quotient bit

            if (remainder[15:8] >= b_reg) begin
                remainder = remainder - (b_reg << 8);
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule