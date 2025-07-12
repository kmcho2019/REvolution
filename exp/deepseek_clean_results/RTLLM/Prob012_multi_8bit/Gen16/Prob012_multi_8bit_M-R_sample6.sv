module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate shifted versions of A
    wire [15:0] shifted_A [7:0];
    assign shifted_A[0] = {8'b0, A};
    assign shifted_A[1] = shifted_A[0] << 1;
    assign shifted_A[2] = shifted_A[1] << 1;
    assign shifted_A[3] = shifted_A[2] << 1;
    assign shifted_A[4] = shifted_A[3] << 1;
    assign shifted_A[5] = shifted_A[4] << 1;
    assign shifted_A[6] = shifted_A[5] << 1;
    assign shifted_A[7] = shifted_A[6] << 1;

    // Generate partial products
    wire [15:0] partial [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign partial[i] = B[i] ? shifted_A[i] : 16'b0;
        end
    endgenerate

    // Accumulate partial products in a binary tree
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial[0] + partial[1];
    assign sum_level1[1] = partial[2] + partial[3];
    assign sum_level1[2] = partial[4] + partial[5];
    assign sum_level1[3] = partial[6] + partial[7];

    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Final sum
    assign product = sum_level2[0] + sum_level2[1];

endmodule