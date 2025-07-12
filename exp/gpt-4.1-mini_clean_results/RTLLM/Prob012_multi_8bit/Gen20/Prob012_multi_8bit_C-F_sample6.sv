module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Explicitly extend A to 16 bits to avoid implicit extension during shifts/additions
    wire [15:0] A_ext = {8'b0, A};

    wire [15:0] partial_products [7:0];
    genvar i;

    // Generate partial products: if B[i] == 1, partial product = A_ext << i; else zero
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree to sum partial products efficiently:
    // Stage 1: 4 adders summing pairs of partial products
    wire [15:0] sum_stage1 [3:0];
    assign sum_stage1[0] = partial_products[0] + partial_products[1];
    assign sum_stage1[1] = partial_products[2] + partial_products[3];
    assign sum_stage1[2] = partial_products[4] + partial_products[5];
    assign sum_stage1[3] = partial_products[6] + partial_products[7];

    // Stage 2: 2 adders summing pairs of sums from stage 1
    wire [15:0] sum_stage2 [1:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];

    // Stage 3: Final adder summing stage 2 results to form the product
    assign product = sum_stage2[0] + sum_stage2[1];

endmodule