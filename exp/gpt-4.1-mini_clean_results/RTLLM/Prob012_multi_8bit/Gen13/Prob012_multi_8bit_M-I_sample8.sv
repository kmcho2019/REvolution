module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [7:0];
    genvar i;

    // Generate each partial product based on bit i of B
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Pairwise additions (4 adders)
    wire [15:0] sum_stage1 [3:0];
    assign sum_stage1[0] = partial_products[0] + partial_products[1];
    assign sum_stage1[1] = partial_products[2] + partial_products[3];
    assign sum_stage1[2] = partial_products[4] + partial_products[5];
    assign sum_stage1[3] = partial_products[6] + partial_products[7];

    // Stage 2: Pairwise additions (2 adders)
    wire [15:0] sum_stage2 [1:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];

    // Stage 3: Final addition
    assign product = sum_stage2[0] + sum_stage2[1];

endmodule