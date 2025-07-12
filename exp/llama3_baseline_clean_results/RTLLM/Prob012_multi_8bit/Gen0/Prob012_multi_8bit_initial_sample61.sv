module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(A or B) begin
    product = 0; // Initialize the product to zero
    reg [7:0] multiplicand; // Temporary variable to hold the multiplicand
    multiplicand = A; // Assign the multiplicand
    reg [7:0] multiplier; // Temporary variable to hold the multiplier
    multiplier = B; // Assign the multiplier
    
    for (int i = 0; i < 8; i++) begin
        if (multiplier[0]) begin // Check the least significant bit
            product = product + {multiplicand, 8'b0}; // Add the multiplicand to the product
        end
        multiplicand = multiplicand << 1; // Shift the multiplicand left by one bit
        multiplier = multiplier >> 1; // Shift the multiplier right by one bit
    end
end

endmodule