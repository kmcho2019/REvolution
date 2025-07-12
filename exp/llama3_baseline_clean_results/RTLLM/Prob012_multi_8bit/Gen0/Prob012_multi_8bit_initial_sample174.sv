module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(A or B) begin
    product = 16'd0;  // Initialize product to zero
    reg [7:0] temp_A; // Temporary variable for A
    temp_A = A;      // Initialize temp_A with A
    
    for (int i = 0; i < 8; i = i + 1) begin
        if (B[i]) begin  // If current bit of B is 1
            product = product + (temp_A << i); // Add shifted A to product
        end
        // No need to explicitly shift temp_A here, 
        // the shift operation is handled in the next iteration
    end
end

endmodule