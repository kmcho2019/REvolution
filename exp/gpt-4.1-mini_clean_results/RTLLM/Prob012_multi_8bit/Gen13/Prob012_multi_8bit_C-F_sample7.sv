module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Generate partial products: for each bit of B, conditionally shift A by i bits
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            // Explicit concatenation and shift wiring for clarity and synthesis friendliness
            // Shift by i: lower i bits zero, upper bits hold A if B[i] is 1, else zero
            assign partial_products[i] = B[i] ? ({8'd0, A} << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree to sum partial products efficiently

    // Level 1 sums: 4 pairs of partial products
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2 sums: 2 pairs of level1 sums
    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3 sum: final addition of level2 sums to produce product
    wire [15:0] sum_level3;
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    // Output assignment
    assign product = sum_level3;

endmodule