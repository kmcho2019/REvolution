module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    wire [15:0] partial_products [7:0];

    // Generate partial products: if B[i] is set, shift A left by i
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial
            assign partial_products[i] = B[i] ? ( {8'd0, A} << i ) : 16'd0;
        end
    endgenerate

    // Level 1 additions: sum pairs of partial products
    wire [15:0] sum_level1 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level1
            assign sum_level1[i] = partial_products[2*i] + partial_products[2*i+1];
        end
    endgenerate

    // Level 2 additions: sum pairs from level 1
    wire [15:0] sum_level2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3 addition: sum final two sums from level 2
    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule