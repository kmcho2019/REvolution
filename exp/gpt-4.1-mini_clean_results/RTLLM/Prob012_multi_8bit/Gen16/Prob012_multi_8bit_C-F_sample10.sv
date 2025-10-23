module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [7:0];
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    genvar i;

    // Generate partial products only if corresponding bit in B is set,
    // shifting A by i bits to align correctly
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'b0;
            // Note: zero-extend A to 16 bits before shifting to avoid implicit width extension issues
        end
    endgenerate

    // Balanced adder tree summation of partial products for improved timing
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule