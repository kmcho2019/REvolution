module PipelineStage(
    input  [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // Reduction tree for AND operation
    wire and_tree1, and_tree2, and_tree3, and_tree4;
    assign and_tree1 = in[0] & in[1];
    assign and_tree2 = in[2] & in[3];
    assign and_tree3 = in[4] & in[5];
    assign and_tree4 = in[6] & in[7];
    assign and_out = and_tree1 & and_tree2 & and_tree3 & and_tree4 & in[8] & in[9];

    // Reduction tree for OR operation
    wire or_tree1, or_tree2, or_tree3, or_tree4;
    assign or_tree1 = in[0] | in[1];
    assign or_tree2 = in[2] | in[3];
    assign or_tree3 = in[4] | in[5];
    assign or_tree4 = in[6] | in[7];
    assign or_out = or_tree1 | or_tree2 | or_tree3 | or_tree4 | in[8] | in[9];

    // Reduction tree for XOR operation
    wire xor_tree1, xor_tree2, xor_tree3, xor_tree4;
    assign xor_tree1 = in[0] ^ in[1];
    assign xor_tree2 = in[2] ^ in[3];
    assign xor_tree3 = in[4] ^ in[5];
    assign xor_tree4 = in[6] ^ in[7];
    assign xor_out = xor_tree1 ^ xor_tree2 ^ xor_tree3 ^ xor_tree4 ^ in[8] ^ in[9];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [9:0] stage1_in, stage2_in, stage3_in, stage4_in, stage5_in, stage6_in, stage7_in, stage8_in, stage9_in, stage10_in;
    wire stage1_and_out, stage2_and_out, stage3_and_out, stage4_and_out, stage5_and_out, stage6_and_out, stage7_and_out, stage8_and_out, stage9_and_out, stage10_and_out;
    wire stage1_or_out, stage2_or_out, stage3_or_out, stage4_or_out, stage5_or_out, stage6_or_out, stage7_or_out, stage8_or_out, stage9_or_out, stage10_or_out;
    wire stage1_xor_out, stage2_xor_out, stage3_xor_out, stage4_xor_out, stage5_xor_out, stage6_xor_out, stage7_xor_out, stage8_xor_out, stage9_xor_out, stage10_xor_out;

    assign stage1_in = in[9:0];
    assign stage2_in = in[19:10];
    assign stage3_in = in[29:20];
    assign stage4_in = in[39:30];
    assign stage5_in = in[49:40];
    assign stage6_in = in[59:50];
    assign stage7_in = in[69:60];
    assign stage8_in = in[79:70];
    assign stage9_in = in[89:80];
    assign stage10_in = in[99:90];

    PipelineStage stage1(.in(stage1_in), .and_out(stage1_and_out), .or_out(stage1_or_out), .xor_out(stage1_xor_out));
    PipelineStage stage2(.in(stage2_in), .and_out(stage2_and_out), .or_out(stage2_or_out), .xor_out(stage2_xor_out));
    PipelineStage stage3(.in(stage3_in), .and_out(stage3_and_out), .or_out(stage3_or_out), .xor_out(stage3_xor_out));
    PipelineStage stage4(.in(stage4_in), .and_out(stage4_and_out), .or_out(stage4_or_out), .xor_out(stage4_xor_out));
    PipelineStage stage5(.in(stage5_in), .and_out(stage5_and_out), .or_out(stage5_or_out), .xor_out(stage5_xor_out));
    PipelineStage stage6(.in(stage6_in), .and_out(stage6_and_out), .or_out(stage6_or_out), .xor_out(stage6_xor_out));
    PipelineStage stage7(.in(stage7_in), .and_out(stage7_and_out), .or_out(stage7_or_out), .xor_out(stage7_xor_out));
    PipelineStage stage8(.in(stage8_in), .and_out(stage8_and_out), .or_out(stage8_or_out), .xor_out(stage8_xor_out));
    PipelineStage stage9(.in(stage9_in), .and_out(stage9_and_out), .or_out(stage9_or_out), .xor_out(stage9_xor_out));
    PipelineStage stage10(.in(stage10_in), .and_out(stage10_and_out), .or_out(stage10_or_out), .xor_out(stage10_xor_out));

    assign out_and = stage1_and_out & stage2_and_out & stage3_and_out & stage4_and_out & stage5_and_out & stage6_and_out & stage7_and_out & stage8_and_out & stage9_and_out & stage10_and_out;
    assign out_or = stage1_or_out | stage2_or_out | stage3_or_out | stage4_or_out | stage5_or_out | stage6_or_out | stage7_or_out | stage8_or_out | stage9_or_out | stage10_or_out;
    assign out_xor = stage1_xor_out ^ stage2_xor_out ^ stage3_xor_out ^ stage4_xor_out ^ stage5_xor_out ^ stage6_xor_out ^ stage7_xor_out ^ stage8_xor_out ^ stage9_xor_out ^ stage10_xor_out;

endmodule