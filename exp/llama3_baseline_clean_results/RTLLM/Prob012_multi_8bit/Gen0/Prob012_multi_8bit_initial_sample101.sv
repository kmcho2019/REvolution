module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(*) begin
    product = 0;  // Initialize the product to 0
    reg [7:0] temp_A;  // Temporary variable to hold A
    temp_A = A;  // Initialize temp_A with A

    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            product = product + (temp_A << i);  // Add temp_A shifted by i bits to product
        end
        // No need to explicitly shift temp_A as it's done in the next iteration
    end
end

endmodule