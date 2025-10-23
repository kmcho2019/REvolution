module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] partial_product;

    always @(*) begin
        partial_product = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                partial_product = partial_product + ({8'b0, A} << i);
            end
        end
    end

    assign product = partial_product;

endmodule