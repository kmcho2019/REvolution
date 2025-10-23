module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] partial_product;
    reg [7:0] shifted_A;
    integer i;

    always @(*) begin
        partial_product = 0;
        shifted_A = A;
        for (i = 0; i < 8; i++) begin
            if (B[i] == 1) begin
                partial_product = partial_product + (shifted_A << i);
            end
            shifted_A = shifted_A << 1;
        end
        product = partial_product;
    end

endmodule