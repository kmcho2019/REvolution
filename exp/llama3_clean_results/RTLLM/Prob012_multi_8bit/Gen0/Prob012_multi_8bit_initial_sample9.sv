module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to zero
    reg [15:0] temp_product;
    assign product = temp_product;

    // Use a generate loop to iterate through each bit of the multiplier
    always @(*) begin
        temp_product = 0;
        for (int i = 0; i < 8; i++) begin
            // If the current bit of the multiplier is set, add the shifted multiplicand to the product
            if (B[i])
                temp_product = temp_product + (A << i);
        end
    end

endmodule