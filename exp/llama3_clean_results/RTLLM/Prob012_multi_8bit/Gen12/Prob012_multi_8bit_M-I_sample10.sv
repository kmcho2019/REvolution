module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] partial_product;
    reg [15:0] sum;

    always @(A or B) begin
        partial_product = 16'b0;
        sum = 16'b0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                partial_product = {8'b0, A} << i;
                sum = sum + partial_product;
            end
        end
        product = sum;
    end

endmodule