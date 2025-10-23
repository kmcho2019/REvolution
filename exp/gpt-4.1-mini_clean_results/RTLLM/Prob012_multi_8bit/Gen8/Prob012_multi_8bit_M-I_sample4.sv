module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] partial_products [7:0];
    wire [15:0] sums [8:0];

    genvar i;

    // Generate partial products by shifting A via concatenation (to avoid shift operator)
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PROD
            // Shift A by i bits: upper bits zero-padded
            assign partial_products[i] = B[i] ? {8'd0, A} << i : 16'd0;
            // Alternatively, write shift as concatenation:
            // assign partial_products[i] = B[i] ? ({A, 8'd0} >> (8 - i)) : 16'd0;
            // But the left shift with '<<' on concatenation is synthesizable and clear.
        end
    endgenerate

    // Initialize sums[0] to 0
    assign sums[0] = 16'd0;

    // Accumulate partial products in a for-generate loop
    generate
        for (i = 0; i < 8; i = i + 1) begin : ACCUMULATE
            assign sums[i+1] = sums[i] + partial_products[i];
        end
    endgenerate

    // The final product is the sum after adding all partial products
    assign product = sums[8];

endmodule