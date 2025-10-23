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
    generate
        // Generate partial products: if B[i] = 1, shift A left by i, else zero
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PRODUCT_GEN
            // Extend A to 16 bits, shift left by i only if B[i] set
            assign partial_products[i] = B[i] ? ( {8'd0, A} << i ) : 16'd0;
        end
    endgenerate

    // Balanced addition tree to sum all partial products efficiently
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule