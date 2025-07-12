module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    // Partial products: each partial product is A shifted left by i if B[i] is 1; else zero.
    // Since A is 8 bits, shifting it left by i produces at most 15 bits; extend to 16 bits.
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? ( {8'd0, A} << i ) : 16'd0;
        end
    endgenerate

    // Balanced adder tree summation for performance:
    // Level 1 sums: 4 adders
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2 sums: 2 adders
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3 sum: final adder
    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule