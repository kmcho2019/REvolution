// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize partial product to zero
    wire [15:0] pp0 = 16'd0;
    
    // Process each bit of the multiplier
    wire [15:0] pp1 = (B[0] == 1'b1) ? (pp0 + A) : pp0;
    wire [15:0] pp2 = (B[1] == 1'b1) ? (pp1 + (A << 1)) : pp1;
    wire [15:0] pp3 = (B[2] == 1'b1) ? (pp2 + (A << 2)) : pp2;
    wire [15:0] pp4 = (B[3] == 1'b1) ? (pp3 + (A << 3)) : pp3;
    wire [15:0] pp5 = (B[4] == 1'b1) ? (pp4 + (A << 4)) : pp4;
    wire [15:0] pp6 = (B[5] == 1'b1) ? (pp5 + (A << 5)) : pp5;
    wire [15:0] pp7 = (B[6] == 1'b1) ? (pp6 + (A << 6)) : pp6;
    wire [15:0] pp8 = (B[7] == 1'b1) ? (pp7 + (A << 7)) : pp7;
    
    // Assign final product
    assign product = pp8;

endmodule