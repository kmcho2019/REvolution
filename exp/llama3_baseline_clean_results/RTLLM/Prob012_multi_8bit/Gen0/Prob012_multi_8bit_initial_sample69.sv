module multi_8bit(
    input  [7:0] A,  // First 8-bit input operand (multiplicand)
    input  [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product;  // Internal signal to store the product
reg [7:0] temp_A;    // Temporary storage for A to perform shifts

initial begin
    product = 0;  // Initialize product to 0
end

always @(A or B) begin
    product = 0;  // Reset product whenever inputs change
    temp_A = A;   // Initialize temp_A with A
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            product = product + (temp_A << i);  // If bit is set, add shifted A to product
        end
        temp_A = temp_A << 1;  // Shift A left for next iteration
    end
end

endmodule