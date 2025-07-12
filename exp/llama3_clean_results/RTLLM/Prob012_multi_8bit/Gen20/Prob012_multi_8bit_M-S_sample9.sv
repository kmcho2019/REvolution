// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary product register
    integer i;  // Loop counter

    always @(A or B) begin  // Update product on change of A or B
        temp_product = 0;  // Reset product
        for (i = 0; i < 8; i = i + 1) begin  // Iterate through bits of B
            if (B[i] == 1'b1) begin  // If current bit of B is 1
                temp_product = temp_product + (A << i);  // Add A shifted by i bits to product
            end
        end
        product = temp_product;  // Assign final product
    end

endmodule