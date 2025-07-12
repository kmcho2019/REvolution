module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    // Generate partial products: each is A shifted left by bit position i if B[i] is 1; else zero
    // Extend to 16 bits directly to accommodate max product size
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? ( {8'd0, A} << i ) : 16'd0;
        end
    endgenerate

    // Balanced adder tree to sum partial products for improved timing
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule