module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Stage 1: Divide inputs into 10 groups of 10 bits
    wire [9:0] and_stage1;
    wire [9:0] or_stage1;
    wire [9:0] xor_stage1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1_groups
            assign and_stage1[i] = &in[i*10 +: 10]; // AND of 10 bits
            assign or_stage1[i]  = |in[i*10 +: 10]; // OR of 10 bits
            assign xor_stage1[i] = ^in[i*10 +: 10]; // XOR of 10 bits
        end
    endgenerate

    // Stage 2: Reduce 10 partial results to a single output using tree structure
    // Since 10 is not a power of two, do one step with groups of 2, then handle leftover

    // AND reduction stage 2
    wire [4:0] and_stage2;
    generate
        for (i = 0; i < 5; i = i + 1) begin : and_stage2_groups
            assign and_stage2[i] = and_stage1[2*i] & and_stage1[2*i + 1];
        end
    endgenerate

    // OR reduction stage 2
    wire [4:0] or_stage2;
    generate
        for (i = 0; i < 5; i = i + 1) begin : or_stage2_groups
            assign or_stage2[i] = or_stage1[2*i] | or_stage1[2*i + 1];
        end
    endgenerate

    // XOR reduction stage 2
    wire [4:0] xor_stage2;
    generate
        for (i = 0; i < 5; i = i + 1) begin : xor_stage2_groups
            assign xor_stage2[i] = xor_stage1[2*i] ^ xor_stage1[2*i + 1];
        end
    endgenerate

    // Stage 3: Reduce 5 to 1, handle the odd count by including the leftover element from stage1

    // AND stage 3: Combine and_stage2[0..3] pairs and include leftover and_stage1[9]
    wire and_temp0 = and_stage2[0] & and_stage2[1];
    wire and_temp1 = and_stage2[2] & and_stage2[3];
    wire and_temp2 = and_temp0 & and_temp1;
    wire and_temp3 = and_temp2 & and_stage2[4];
    wire and_temp4 = and_temp3 & and_stage1[9]; // leftover group

    // OR stage 3
    wire or_temp0 = or_stage2[0] | or_stage2[1];
    wire or_temp1 = or_stage2[2] | or_stage2[3];
    wire or_temp2 = or_temp0 | or_temp1;
    wire or_temp3 = or_temp2 | or_stage2[4];
    wire or_temp4 = or_temp3 | or_stage1[9]; // leftover group

    // XOR stage 3
    wire xor_temp0 = xor_stage2[0] ^ xor_stage2[1];
    wire xor_temp1 = xor_stage2[2] ^ xor_stage2[3];
    wire xor_temp2 = xor_temp0 ^ xor_temp1;
    wire xor_temp3 = xor_temp2 ^ xor_stage2[4];
    wire xor_temp4 = xor_temp3 ^ xor_stage1[9]; // leftover group

    // Final outputs
    assign out_and = and_temp4;
    assign out_or  = or_temp4;
    assign out_xor = xor_temp4;

endmodule