module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Extend A to 16 bits once
    wire [15:0] A_ext = {8'b0, A};

    // Generate partial products by masking shifted B bits, then AND with A_ext
    // Partial product i = (B[i] ? 1'b1 : 1'b0) << i, ANDed with A_ext shifted left by i
    // To avoid repeated shifting of A_ext, generate shifted masks and AND with A_ext shifted accordingly
    // But here, we'll create each partial product by:
    // partial_products[i] = B[i] ? (A_ext << i) : 16'b0;

    // This matches the minimal logic and matches shift-and-add behavior exactly

    wire [15:0] partial_products [7:0];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            // Partial product is A_ext shifted by i if B[i] is 1, else zero
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree summation to minimize critical path
    // Level 1: sum partial_products pairwise (4 sums)
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of sums from level 1 (2 sums)
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: final sum (product)
    assign product = sum_level2[0] + sum_level2[1];

endmodule