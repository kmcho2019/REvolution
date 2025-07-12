module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(A or B) begin
    product = 0;  // Initialize the product to zero
    reg [7:0] temp_A;  // Temporary variable to hold A
    temp_A = A;  // Initialize temp_A with A
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin  // If the current bit of B is set
            product = product + (temp_A << i);  // Add temp_A shifted left by i bits to the product
        end
        temp_A = temp_A << 1;  // Shift temp_A left by one bit
    end
end

endmodule