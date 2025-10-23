module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [7:0];

    genvar i;

    // Generate partial products: each is A shifted left by i if B[i] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Sum partial products in a balanced binary adder tree to reduce critical path
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    // Level 1: sum pairs of partial_products
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of sums from level 1
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: final sum to produce the product
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule