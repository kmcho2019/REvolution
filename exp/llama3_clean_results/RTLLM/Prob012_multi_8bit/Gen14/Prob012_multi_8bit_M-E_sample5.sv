module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the partial products
    wire [7:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Generate partial products
    assign pp0 = (A & {8{B[0]}});
    assign pp1 = (A & {8{B[1]}}) << 1;
    assign pp2 = (A & {8{B[2]}}) << 2;
    assign pp3 = (A & {8{B[3]}}) << 3;
    assign pp4 = (A & {8{B[4]}}) << 4;
    assign pp5 = (A & {8{B[5]}}) << 5;
    assign pp6 = (A & {8{B[6]}}) << 6;
    assign pp7 = (A & {8{B[7]}}) << 7;

    // Sum the partial products using a ripple-carry adder
    wire [15:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;
    assign sum0 = pp0 + pp1;
    assign sum1 = sum0 + pp2;
    assign sum2 = sum1 + pp3;
    assign sum3 = sum2 + pp4;
    assign sum4 = sum3 + pp5;
    assign sum5 = sum4 + pp6;
    assign sum6 = sum5 + pp7;

    // Assign the final product
    assign product = sum6;

endmodule