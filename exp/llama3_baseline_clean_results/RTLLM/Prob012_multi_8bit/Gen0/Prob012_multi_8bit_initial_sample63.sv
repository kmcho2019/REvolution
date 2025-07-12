module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize product to 0
    reg [15:0] prod;

    // Perform multiplication using shift-and-add method
    always @(*) begin
        prod = 16'd0;  // Reset product to 0 for new calculation
        reg [7:0] temp_A;  // Temporary variable to hold A
        temp_A = A;  // Initialize temp_A with A

        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin  // Check if current bit of B is set
                prod = prod + (temp_A << i);  // Add shifted A to product
            end
            // No need to explicitly shift A here as we use (temp_A << i) to simulate shifting
        end

        product = prod;  // Assign final product to output
    end

endmodule