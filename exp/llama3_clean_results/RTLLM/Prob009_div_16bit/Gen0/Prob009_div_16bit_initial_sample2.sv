module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0]  B,  // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result = 0;
    odd = a_reg;
    for (int i = 15; i >= 8; i--) begin
        if (odd[15:8] >= b_reg) begin
            result[15-i+7] = 1;
            odd = {odd[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            result[15-i+7] = 0;
            odd = {odd[7:0], 1'b0};
        end
    end
end

endmodule