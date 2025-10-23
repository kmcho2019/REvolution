module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Pre-extend A to 16 bits (zero-extended)
    wire [15:0] A_ext = {8'b0, A};

    // Partial products: 8 arrays of 16-bit wires
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree: Level 1 sums (4 adders)
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2 sums (2 adders)
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3 sum (final product)
    assign product = sum_level2[0] + sum_level2[1];

endmodule