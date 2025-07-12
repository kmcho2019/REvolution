module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = 0;
        reg [7:0] temp_A;
        temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp_product = temp_product + (temp_A << i);
            end
            if (i < 7) begin
                temp_A = temp_A << 1;
            end
        end
    end

endmodule