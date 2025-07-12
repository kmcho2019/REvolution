module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] partial_products [7:0];
    wire [15:0] sums [7:0];
    genvar i;

    // Generate partial products by shifting A when corresponding B bit is 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PROD
            assign partial_products[i] = B[i] ? ( {8'd0, A} << i ) : 16'd0;
        end
    endgenerate

    // Accumulate partial products in a linear chain
    assign sums[0] = partial_products[0];
    generate
        for (i = 1; i < 8; i = i + 1) begin : SUM_ACCUM
            assign sums[i] = sums[i-1] + partial_products[i];
        end
    endgenerate

    assign product = sums[7];

endmodule