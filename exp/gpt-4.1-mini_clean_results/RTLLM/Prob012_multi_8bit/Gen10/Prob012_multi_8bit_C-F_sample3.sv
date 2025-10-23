module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Zero-extend A to 16 bits for consistent shifting and addition
    wire [15:0] A_ext = {8'b0, A};

    // Generate partial products: each partial product is either A_ext shifted left by i if B[i] = 1, else zero
    wire [15:0] partial_products [7:0];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree summation to minimize critical path delay
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    // Level 1: sum pairs of partial products
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs from level 1
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: sum final two sums to produce the product
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    // Output assignment
    assign product = sum_level3;

endmodule