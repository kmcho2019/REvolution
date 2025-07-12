module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] prod;  // Internal 16-bit product register
reg [7:0] temp_A;  // Temporary register to hold A for shifting
integer i;  // Loop counter

always @(A or B) begin
    prod = 0;  // Initialize product to zero
    temp_A = A;  // Initialize temp_A with A
    
    // Iterate through each bit of the multiplier (B)
    for (i = 0; i < 8; i = i + 1) begin
        // Check if the current bit of B is set (1)
        if (B[i] == 1'b1) begin
            // Add A shifted left by the current bit position to the product
            prod = prod + (temp_A << i);
        end
        
        // Shift A left by one bit for the next addition
        temp_A = temp_A << 1;
    end
    
    // Assign the final product to the output port
    product = prod;
end

endmodule