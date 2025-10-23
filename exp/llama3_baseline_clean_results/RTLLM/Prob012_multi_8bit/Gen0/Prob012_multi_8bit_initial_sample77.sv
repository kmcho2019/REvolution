module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] prod_reg;  // Register to hold the intermediate and final product
reg [7:0] shift_reg;  // Register to hold the shifted multiplicand
reg [2:0] count;  // Counter to track the current bit in the multiplier

initial begin
    prod_reg = 16'd0;  // Initialize product register to 0
    count = 3'd0;  // Initialize counter to 0
end

always @(*) begin
    product = prod_reg;  // Continuously assign the product register to the output
end

always @(posedge count) begin
    if (count < 8) begin
        if (B[count] == 1'b1) begin
            prod_reg = prod_reg + (A << count);  // Add shifted A to product if current bit of B is set
        end
        count = count + 1;  // Increment counter to move to the next bit
    end else begin
        count = 3'd0;  // Reset counter after all bits have been processed
    end
end

endmodule