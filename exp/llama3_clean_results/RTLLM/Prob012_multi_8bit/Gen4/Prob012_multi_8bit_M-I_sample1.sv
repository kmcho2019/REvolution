module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to zero
    reg [15:0] prod;
    initial prod = 16'd0;

    // Perform multiplication using shift-and-add method
    always @(A or B) begin
        prod = 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                prod = prod + (A << i);
            end
        end
    end

    // Assign the final product to the output
    assign product = prod;

endmodule