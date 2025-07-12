module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 8; i > 0; i--) begin
        if (odd_reg[15:i+7] >= b_reg) begin
            result_reg[15-i] = 1;
            odd_reg = {odd_reg[15:i+7] - b_reg, odd_reg[i-1:0]};
        end else begin
            result_reg[15-i] = 0;
            odd_reg = {odd_reg[15:i+7], odd_reg[i-1:0]};
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule