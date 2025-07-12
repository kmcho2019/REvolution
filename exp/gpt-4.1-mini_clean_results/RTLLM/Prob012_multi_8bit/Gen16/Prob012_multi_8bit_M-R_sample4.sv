module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [7:0];
    wire [15:0] sum_partial;

    genvar i;

    // Generate partial products for each bit of B
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Sequentially accumulate partial products using a generate loop
    wire [15:0] sums [7:0];

    assign sums[0] = partial_products[0];
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_accumulate
            assign sums[i] = sums[i-1] + partial_products[i];
        end
    endgenerate

    assign product = sums[7];

endmodule