module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all possible shifted versions of A
    wire [15:0] shifted_A [7:0];
    assign shifted_A[0] = {8'b0, A};
    assign shifted_A[1] = {7'b0, A, 1'b0};
    assign shifted_A[2] = {6'b0, A, 2'b0};
    assign shifted_A[3] = {5'b0, A, 3'b0};
    assign shifted_A[4] = {4'b0, A, 4'b0};
    assign shifted_A[5] = {3'b0, A, 5'b0};
    assign shifted_A[6] = {2'b0, A, 6'b0};
    assign shifted_A[7] = {1'b0, A, 7'b0};

    // Conditionally select shifted versions based on B bits
    wire [15:0] partial_products [7:0];
    assign partial_products[0] = B[0] ? shifted_A[0] : 16'b0;
    assign partial_products[1] = B[1] ? shifted_A[1] : 16'b0;
    assign partial_products[2] = B[2] ? shifted_A[2] : 16'b0;
    assign partial_products[3] = B[3] ? shifted_A[3] : 16'b0;
    assign partial_products[4] = B[4] ? shifted_A[4] : 16'b0;
    assign partial_products[5] = B[5] ? shifted_A[5] : 16'b0;
    assign partial_products[6] = B[6] ? shifted_A[6] : 16'b0;
    assign partial_products[7] = B[7] ? shifted_A[7] : 16'b0;

    // Accumulate all partial products
    assign product = partial_products[0] +
                    partial_products[1] +
                    partial_products[2] +
                    partial_products[3] +
                    partial_products[4] +
                    partial_products[5] +
                    partial_products[6] +
                    partial_products[7];

endmodule