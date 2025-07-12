module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] prod;  // Temporary variable to accumulate the product
reg [7:0] temp_A;  // Temporary variable to hold A as it is shifted

integer i;  // Loop counter

always @(A or B) begin
    prod = 0;  // Initialize product to 0 at the start of each multiplication
    temp_A = A;  // Initialize temp_A with A

    for (i = 0; i < 8; i = i + 1) begin
        if (B[i] == 1'b1) begin  // Check if the current bit of B is 1
            prod = prod + (temp_A << i);  // Add the shifted A to the product
        end
        // No need for an else statement here as we're only adding when the bit is set
    end

    product = prod;  // Assign the final product to the output port
end

endmodule