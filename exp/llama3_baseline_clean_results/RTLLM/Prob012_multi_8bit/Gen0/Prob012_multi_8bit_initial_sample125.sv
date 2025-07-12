module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output reg [15:0] product  // 16-bit output representing the product
);

always @(*) begin
    product = 0;
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            product = product + (A << i);
        end
    end
end

endmodule