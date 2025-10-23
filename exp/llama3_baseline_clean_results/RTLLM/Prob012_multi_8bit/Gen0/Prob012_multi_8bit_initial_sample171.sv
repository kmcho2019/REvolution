module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to hold the product
    reg [7:0] tempA;  // Temporary register to hold the multiplicand
    integer i;       // Loop counter

    always @(A or B) begin
        prod = 0;    // Initialize the product to 0
        tempA = A;   // Initialize the temporary multiplicand to A

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1) begin
                prod = prod + (tempA << i);  // Add the multiplicand to the product if the current bit of the multiplier is set
            end
            // No need to explicitly shift tempA here, as it's done implicitly in the next iteration
        end

        product = prod;  // Assign the final product to the output port
    end

endmodule