module PipelineStage(
    input  [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    wire [4:0] and_tree;
    assign and_tree[0] = in[0];
    assign and_tree[1] = in[1] & and_tree[0];
    assign and_tree[2] = in[2] & and_tree[1];
    assign and_tree[3] = in[3] & and_tree[2];
    assign and_tree[4] = in[4] & and_tree[3];
    assign and_out = in[9] & in[8] & in[7] & in[6] & in[5] & and_tree[4];

    // OR Operation
    wire [4:0] or_tree;
    assign or_tree[0] = in[0];
    assign or_tree[1] = in[1] | or_tree[0];
    assign or_tree[2] = in[2] | or_tree[1];
    assign or_tree[3] = in[3] | or_tree[2];
    assign or_tree[4] = in[4] | or_tree[3];
    assign or_out = in[9] | in[8] | in[7] | in[6] | in[5] | or_tree[4];

    // XOR Operation
    wire [4:0] xor_tree;
    assign xor_tree[0] = in[0];
    assign xor_tree[1] = in[1] ^ xor_tree[0];
    assign xor_tree[2] = in[2] ^ xor_tree[1];
    assign xor_tree[3] = in[3] ^ xor_tree[2];
    assign xor_tree[4] = in[4] ^ xor_tree[3];
    assign xor_out = in[9] ^ in[8] ^ in[7] ^ in[6] ^ in[5] ^ xor_tree[4];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_result0;
    wire or_result0;
    wire xor_result0;
    wire and_result1;
    wire or_result1;
    wire xor_result1;
    wire and_result2;
    wire or_result2;
    wire xor_result2;
    wire and_result3;
    wire or_result3;
    wire xor_result3;
    wire and_result4;
    wire or_result4;
    wire xor_result4;
    wire and_result5;
    wire or_result5;
    wire xor_result5;
    wire and_result6;
    wire or_result6;
    wire xor_result6;
    wire and_result7;
    wire or_result7;
    wire xor_result7;
    wire and_result8;
    wire or_result8;
    wire xor_result8;
    wire and_result9;
    wire or_result9;
    wire xor_result9;

    PipelineStage stage0(.in(in[9:0]), .and_out(and_result0), .or_out(or_result0), .xor_out(xor_result0));
    PipelineStage stage1(.in(in[19:10]), .and_out(and_result1), .or_out(or_result1), .xor_out(xor_result1));
    PipelineStage stage2(.in(in[29:20]), .and_out(and_result2), .or_out(or_result2), .xor_out(xor_result2));
    PipelineStage stage3(.in(in[39:30]), .and_out(and_result3), .or_out(or_result3), .xor_out(xor_result3));
    PipelineStage stage4(.in(in[49:40]), .and_out(and_result4), .or_out(or_result4), .xor_out(xor_result4));
    PipelineStage stage5(.in(in[59:50]), .and_out(and_result5), .or_out(or_result5), .xor_out(xor_result5));
    PipelineStage stage6(.in(in[69:60]), .and_out(and_result6), .or_out(or_result6), .xor_out(xor_result6));
    PipelineStage stage7(.in(in[79:70]), .and_out(and_result7), .or_out(or_result7), .xor_out(xor_result7));
    PipelineStage stage8(.in(in[89:80]), .and_out(and_result8), .or_out(or_result8), .xor_out(xor_result8));
    PipelineStage stage9(.in(in[99:90]), .and_out(and_result9), .or_out(or_result9), .xor_out(xor_result9));

    assign out_and = and_result0 & and_result1 & and_result2 & and_result3 & and_result4 & and_result5 & and_result6 & and_result7 & and_result8 & and_result9;
    assign out_or = or_result0 | or_result1 | or_result2 | or_result3 | or_result4 | or_result5 | or_result6 | or_result7 | or_result8 | or_result9;
    assign out_xor = xor_result0 ^ xor_result1 ^ xor_result2 ^ xor_result3 ^ xor_result4 ^ xor_result5 ^ xor_result6 ^ xor_result7 ^ xor_result8 ^ xor_result9;

endmodule