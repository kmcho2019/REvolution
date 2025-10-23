module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to store the product
    reg [7:0] temp_A;  // Temporary register to store the shifted multiplicand
    integer i;  // Loop counter

    // Initialize the product and temporary multiplicand
    initial begin
        prod = 0;
        temp_A = A;
    end

    // Perform the multiplication using the shift-and-add method
    always @(*) begin
        prod = 0;
        temp_A = A;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                prod = prod + (temp_A << i);
            end
            temp_A = temp_A << 1;
        end
    end

    // Assign the final product to the output port
    assign product = prod;

endmodule