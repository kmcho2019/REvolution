module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Zero-extend multiplicand once to 16 bits for all partial products
    wire [15:0] A_ext = {8'd0, A};

    // Generate partial products: for each bit of B, conditionally shift A_ext by bit index
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'd0;
        end
    endgenerate

    // Balanced adder tree to sum partial products efficiently:
    // Level 1: sum pairs of partial products → 4 sums
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of level 1 sums → 2 sums
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: final sum of two level 2 sums → final product
    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    // Assign final product output
    assign product = sum_level3;

endmodule