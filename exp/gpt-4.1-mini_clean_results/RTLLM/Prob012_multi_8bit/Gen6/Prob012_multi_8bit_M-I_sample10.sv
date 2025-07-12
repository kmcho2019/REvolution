module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] partial_products [7:0];

    // Generate partial products by shifting A when corresponding B bit is 1
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PROD
            assign partial_products[i] = B[i] ? ({8'd0, A} << i) : 16'd0;
        end
    endgenerate

    // Stage 1: Add pairs of partial products (4 adders)
    wire [15:0] stage1_sums [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE1
            assign stage1_sums[i] = partial_products[2*i] + partial_products[2*i + 1];
        end
    endgenerate

    // Stage 2: Add pairs of stage1 sums (2 adders)
    wire [15:0] stage2_sums [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : STAGE2
            assign stage2_sums[i] = stage1_sums[2*i] + stage1_sums[2*i + 1];
        end
    endgenerate

    // Stage 3: Add the two stage2 sums (1 adder)
    wire [15:0] stage3_sum;
    assign stage3_sum = stage2_sums[0] + stage2_sums[1];

    assign product = stage3_sum;

endmodule