module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] temp_product;

always @(A or B) begin
    temp_product = 16'd0; // Initialize product to zero
    reg [7:0] temp_A; // Temporary register to hold A
    temp_A = A; // Initialize temp_A with A

    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin // Check if current bit of B is set
            temp_product = temp_product + (temp_A << i); // Add A shifted by i positions to product
        end
        temp_A = temp_A << 1; // Shift A one bit to the left for next iteration
    end
    product = temp_product; // Assign final product to output
end

endmodule