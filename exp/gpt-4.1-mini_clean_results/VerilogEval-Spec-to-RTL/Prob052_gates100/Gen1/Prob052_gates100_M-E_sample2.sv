module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Stage 1: Break into 10 groups of 10 bits
    wire [9:0] and_stage1;
    wire [9:0] or_stage1;
    wire [9:0] xor_stage1;

    genvar i, j;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1_groups
            wire [9:0] group_bits = in[i*10 +: 10];
            // Partial reductions on each group of 10 bits
            assign and_stage1[i] = &group_bits;
            assign or_stage1[i]  = |group_bits;
            assign xor_stage1[i] = ^group_bits;
        end
    endgenerate

    // Stage 2: Combine the 10 partial results into final outputs
    // For AND and OR, directly reduce the 10 partial signals
    assign out_and = &and_stage1;
    assign out_or  = |or_stage1;

    // For XOR, similarly reduce the 10 partial XOR results
    assign out_xor = ^xor_stage1;

endmodule