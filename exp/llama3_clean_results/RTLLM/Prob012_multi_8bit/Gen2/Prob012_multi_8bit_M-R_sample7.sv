module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Calculate each bit of the product separately
    wire [15:0] partial_product_0 = (B[0] == 1'b1)? {8'd0, A} : 16'd0;
    wire [15:0] partial_product_1 = (B[1] == 1'b1)? {7'd0, A, 1'b0} : 16'd0;
    wire [15:0] partial_product_2 = (B[2] == 1'b1)? {6'd0, A, 2'b0} : 16'd0;
    wire [15:0] partial_product_3 = (B[3] == 1'b1)? {5'd0, A, 3'b0} : 16'd0;
    wire [15:0] partial_product_4 = (B[4] == 1'b1)? {4'd0, A, 4'b0} : 16'd0;
    wire [15:0] partial_product_5 = (B[5] == 1'b1)? {3'd0, A, 5'b0} : 16'd0;
    wire [15:0] partial_product_6 = (B[6] == 1'b1)? {2'd0, A, 6'b0} : 16'd0;
    wire [15:0] partial_product_7 = (B[7] == 1'b1)? {1'd0, A, 7'b0} : 16'd0;

    // Combine the partial products to form the final product
    assign product = partial_product_0 + partial_product_1 + partial_product_2 + partial_product_3 +
                     partial_product_4 + partial_product_5 + partial_product_6 + partial_product_7;

endmodule