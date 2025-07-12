module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= b_reg) begin
            quotient[15-i] = 1;
            remainder = (remainder[15:8] - b_reg) << 8 | remainder[7:0];
        end else begin
            quotient[15-i] = 0;
            remainder = remainder[7:0] << 8 | remainder[7:0];
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule