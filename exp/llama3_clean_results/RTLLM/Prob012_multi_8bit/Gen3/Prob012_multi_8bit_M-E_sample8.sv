module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    wire [15:0] partial_product;
    wire [15:0] temp;

    // Initialize partial product to 0
    assign partial_product = 16'd0;

    // Iterate through each bit of the multiplier
    always @(*) begin
        temp = 16'd0;
        for (int i = 0; i < 8; i++) begin
            // Determine the operation to be performed
            if (B[i] == 1'b1) begin
                // Add the multiplicand to the partial product
                temp = temp + (A << i);
            end
        end
        // Update the partial product
        partial_product = temp;
    end

    // Assign the final product to the output
    assign product = partial_product;

endmodule