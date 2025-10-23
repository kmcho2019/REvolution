module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 0;  // Initialize product to 0
        reg [7:0] temp_A;  // Temporary variable to hold the value of A
        temp_A = A;  // Assign A to temp_A
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product = product + (temp_A << i);  // Add temp_A shifted left by i bits to product if B[i] is 1
            end
        end
    end

endmodule