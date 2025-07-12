module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Stage 1: Reduce 100 inputs into 10 intermediate bits per function (10 groups of 10 bits)
    wire [9:0] and_stage1;
    wire [9:0] or_stage1;
    wire [9:0] xor_stage1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1_reduction
            assign and_stage1[i] = &in[i*10 +: 10];
            assign or_stage1[i]  = |in[i*10 +: 10];
            assign xor_stage1[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Stage 2: Reduce 10 intermediate bits into 2 bits per function (2 groups of 5 bits)
    wire and_stage2_0, and_stage2_1;
    wire or_stage2_0, or_stage2_1;
    wire xor_stage2_0, xor_stage2_1;

    assign and_stage2_0 = &and_stage1[0 +: 5];
    assign and_stage2_1 = &and_stage1[5 +: 5];

    assign or_stage2_0  = |or_stage1[0 +: 5];
    assign or_stage2_1  = |or_stage1[5 +: 5];

    assign xor_stage2_0 = ^xor_stage1[0 +: 5];
    assign xor_stage2_1 = ^xor_stage1[5 +: 5];

    // Stage 3: Final outputs - combine the two bits from stage 2 to form final output
    assign out_and = and_stage2_0 & and_stage2_1;
    assign out_or  = or_stage2_0 | or_stage2_1;
    assign out_xor = xor_stage2_0 ^ xor_stage2_1;

endmodule