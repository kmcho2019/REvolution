module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    // Zero-extend multiplicand A to 16 bits once for reuse
    wire [15:0] A_ext = {8'b0, A};

    // Generate partial products based on each bit of B
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree to sum partial products
    // Stage 1: sum pairs
    wire [15:0] sum_stage1 [3:0];
    assign sum_stage1[0] = pp[0] + pp[1];
    assign sum_stage1[1] = pp[2] + pp[3];
    assign sum_stage1[2] = pp[4] + pp[5];
    assign sum_stage1[3] = pp[6] + pp[7];

    // Stage 2: sum pairs of sums from Stage 1
    wire [15:0] sum_stage2 [1:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];

    // Stage 3: final sum
    assign product = sum_stage2[0] + sum_stage2[1];

endmodule