module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Use the built-in multiplication operator (*) for simplicity and efficiency
    assign product = A * B;

    // Alternatively, we can use a tree-like adder structure to sum the partial products
    // wire [15:0] partial_product_0, partial_product_1, partial_product_2, partial_product_3,
    //             partial_product_4, partial_product_5, partial_product_6, partial_product_7;
    // assign partial_product_0 = (B[0] == 1'b1)? {8'b0, A} : 16'b0;
    // assign partial_product_1 = (B[1] == 1'b1)? {8'b0, A} << 1 : 16'b0;
    // assign partial_product_2 = (B[2] == 1'b1)? {8'b0, A} << 2 : 16'b0;
    // assign partial_product_3 = (B[3] == 1'b1)? {8'b0, A} << 3 : 16'b0;
    // assign partial_product_4 = (B[4] == 1'b1)? {8'b0, A} << 4 : 16'b0;
    // assign partial_product_5 = (B[5] == 1'b1)? {8'b0, A} << 5 : 16'b0;
    // assign partial_product_6 = (B[6] == 1'b1)? {8'b0, A} << 6 : 16'b0;
    // assign partial_product_7 = (B[7] == 1'b1)? {8'b0, A} << 7 : 16'b0;
    // wire [15:0] sum_1, sum_2, sum_3, sum_4;
    // assign sum_1 = partial_product_0 + partial_product_1;
    // assign sum_2 = partial_product_2 + partial_product_3;
    // assign sum_3 = partial_product_4 + partial_product_5;
    // assign sum_4 = partial_product_6 + partial_product_7;
    // assign product = sum_1 + sum_2 + sum_3 + sum_4;

endmodule