module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Pre-extend multiplicand A to 16 bits once to avoid repeated concatenations
    wire [15:0] A_ext = {8'b0, A};

    // Generate partial products: A_ext shifted by i if B[i] is 1, else zero
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'd0;
        end
    endgenerate

    // Balanced adder tree summation of partial products to reduce critical path
    // Level 1: sum pairs of partial products (4 adders)
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of sums from Level 1 (2 adders)
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: final sum of Level 2 results (1 adder)
    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    // Output the final product
    assign product = sum_level3;

endmodule