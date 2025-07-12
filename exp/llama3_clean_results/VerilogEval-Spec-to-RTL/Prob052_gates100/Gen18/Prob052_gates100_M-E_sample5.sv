module PipelineStage(
    input  [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    assign and_out = &in;

    // OR Operation
    assign or_out = |in;

    // XOR Operation
    assign xor_out = ^in;

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [24:0] slice0;
    wire [24:0] slice1;
    wire [24:0] slice2;
    wire [24:0] slice3;

    assign slice0 = in[24:0];
    assign slice1 = in[49:25];
    assign slice2 = in[74:50];
    assign slice3 = in[99:75];

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

    PipelineStage stage0(.in(slice0), .and_out(and_result0), .or_out(or_result0), .xor_out(xor_result0));
    PipelineStage stage1(.in(slice1), .and_out(and_result1), .or_out(or_result1), .xor_out(xor_result1));
    PipelineStage stage2(.in(slice2), .and_out(and_result2), .or_out(or_result2), .xor_out(xor_result2));
    PipelineStage stage3(.in(slice3), .and_out(and_result3), .or_out(or_result3), .xor_out(xor_result3));

    assign out_and = and_result0 & and_result1 & and_result2 & and_result3;
    assign out_or = or_result0 | or_result1 | or_result2 | or_result3;
    assign out_xor = xor_result0 ^ xor_result1 ^ xor_result2 ^ xor_result3;

endmodule