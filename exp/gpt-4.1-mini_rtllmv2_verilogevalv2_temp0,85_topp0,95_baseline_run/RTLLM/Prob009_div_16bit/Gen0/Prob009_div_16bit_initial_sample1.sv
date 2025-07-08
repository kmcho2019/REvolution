module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    // Latch inputs
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    integer i;
    reg [7:0] remainder;
    reg [15:0] quotient;
    reg [7:0] dividend_bits;

    // Initialize
    quotient = 0;
    remainder = a_reg[15:8]; // highest 8 bits of dividend

    for(i = 15; i >= 8; i = i - 1) begin
        // For bits 15 down to 8, we already loaded remainder as highest 8 bits
        // No shift needed here since remainder already set at start
        if (remainder >= b_reg) begin
            quotient[i] = 1'b1;
            remainder = remainder - b_reg;
        end else begin
            quotient[i] = 1'b0;
        end

        // Only shift remainder left by 1 and add next dividend bit if not last step
        if(i > 8)
            remainder = {remainder[6:0], a_reg[i-1]};
    end

    // Now process bits 7 down to 0
    // For these bits, remainder is 8 bits; each iteration we shift left, bring down next bit,
    // compare with divisor, set quotient bit accordingly.
    for(i = 7; i >= 0; i = i -1) begin
        remainder = {remainder[6:0], a_reg[i]};
        if(remainder >= b_reg) begin
            quotient[i] = 1'b1;
            remainder = remainder - b_reg;
        end else begin
            quotient[i] = 1'b0;
        end
    end

    result = quotient;
    odd = {8'b0, remainder}; // remainder is 8 bits, pad upper 8 bits with zero
end

endmodule