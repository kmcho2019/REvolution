module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] partial_products [7:0];
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    genvar i;

    // Generate partial products by shifting A when corresponding B bit is 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PROD
            assign partial_products[i] = B[i] ? ({8'd0, A} << i) : 16'd0;
        end
    endgenerate

    // Level 1: sum pairs of partial products
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of level 1 results
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: sum final two results
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule