// Module: multi_8bit_refactored
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit_refactored(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod; // Internal register to hold the product
    assign product = prod; // Assign the internal product to the output

    always @(*) begin
        prod = 0; // Initialize product to 0 for each calculation
        for (int i = 0; i < 8; i++) begin
            if (B[i]) // Check if the current bit of the multiplier is 1
                prod = prod + (A << i); // Shift A left by i bits and add to product
        end
    end

endmodule