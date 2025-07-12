module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] partial_product;
    reg [15:0] running_total;
    reg [7:0] shifted_multiplicand;
    integer i;

    always @(*) begin
        running_total = 0;
        shifted_multiplicand = A;
        for (i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                partial_product = {8'b0, shifted_multiplicand};
                running_total = running_total + partial_product;
            end
            shifted_multiplicand = shifted_multiplicand << 1;
        end
        product = running_total;
    end

endmodule