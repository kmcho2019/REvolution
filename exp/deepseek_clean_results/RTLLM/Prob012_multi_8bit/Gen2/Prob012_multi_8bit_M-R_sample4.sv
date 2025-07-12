module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all possible shifted versions of A
    wire [15:0] partial_products [7:0];
    
    assign partial_products[0] = B[0] ? {8'b0, A} : 16'b0;
    assign partial_products[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign partial_products[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign partial_products[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign partial_products[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign partial_products[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign partial_products[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign partial_products[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Sum all partial products
    assign product = partial_products[0] + partial_products[1] +
                    partial_products[2] + partial_products[3] +
                    partial_products[4] + partial_products[5] +
                    partial_products[6] + partial_products[7];

endmodule