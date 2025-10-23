module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] temp_product;

    always @(A or B) begin
        temp_product = 16'd0; // Initialize product to 0
        reg [7:0] temp_A = A; // Temporary variable to hold A
        reg [7:0] temp_B = B; // Temporary variable to hold B

        for (int i = 0; i < 8; i++) begin
            if (temp_B[0]) begin // Check if the least significant bit of B is 1
                temp_product = temp_product + {{8{1'b0}}, temp_A}; // Add A to product, shifting A to correct position
            end
            temp_A = temp_A << 1; // Shift A left by one bit
            temp_B = temp_B >> 1; // Shift B right by one bit to move to the next bit
        end
        product = temp_product; // Assign final product to output
    end

endmodule