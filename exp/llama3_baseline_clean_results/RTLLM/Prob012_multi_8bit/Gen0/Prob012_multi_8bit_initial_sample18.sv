module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to hold the product
    reg [7:0] temp_A;  // Temporary register to hold A for shifting

    // Initialize temp_A with input A and prod to 0
    initial begin
        temp_A = A;
        prod = 0;
    end

    // Perform multiplication using the shift-and-add method
    always @(A or B) begin
        prod = 0;
        temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                prod = prod + (temp_A << i);
            end
            temp_A = temp_A << 1;  // Shift temp_A left by one bit
        end
    end

    // Assign the final product to the output port
    assign product = prod;

endmodule