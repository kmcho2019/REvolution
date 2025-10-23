module PipelineStage(
    input [24:0] in,
    input and_prev,
    input or_prev,
    input xor_prev,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &in & and_prev;
    assign or_out = |in | or_prev;
    assign xor_out = ^in ^ xor_prev;

endmodule

module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [24:0] seg1, seg2, seg3, seg4;
    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;

    PipelineStage stage1(seg1, 1'b1, 1'b0, 1'b0, and_seg1, or_seg1, xor_seg1);
    PipelineStage stage2(seg2, and_seg1, or_seg1, xor_seg1, and_seg2, or_seg2, xor_seg2);
    PipelineStage stage3(seg3, and_seg2, or_seg2, xor_seg2, and_seg3, or_seg3, xor_seg3);
    PipelineStage stage4(seg4, and_seg3, or_seg3, xor_seg3, and_seg4, or_seg4, xor_seg4);

    assign out_and = and_seg4;
    assign out_or = or_seg4;
    assign out_xor = xor_seg4;

endmodule