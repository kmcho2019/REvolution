module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal variable to store the product
    reg [7:0]  temp;  // Temporary variable to store the shifted multiplicand
    integer i;        // Loop counter

    always @(A or B) begin
        prod = 0;     // Initialize product to 0
        temp = A;     // Initialize temp with the multiplicand

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin  // Check if the current bit of the multiplier is set
                prod = prod + (temp << i);  // Add the shifted multiplicand to the product
            end
            // No need to explicitly shift temp here, as it's already considered in the next iteration
        end

        product = prod;  // Assign the final product to the output port
    end

endmodule