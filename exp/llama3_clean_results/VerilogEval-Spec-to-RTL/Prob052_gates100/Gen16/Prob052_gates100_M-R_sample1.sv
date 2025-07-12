module PipelineStage(
    input  [24:0] in,
    input  and_in,
    input  or_in,
    input  xor_in,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &in & and_in;
    assign or_out = |in | or_in;
    assign xor_out = ^in ^ xor_in;

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [3:0] and_result;
    wire [3:0] or_result;
    wire [3:0] xor_result;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            PipelineStage stage(
                .in(in[(i+1)*25-1:i*25]),
                .and_in(i == 0 ? 1'b1 : and_result[i-1]),
                .or_in(i == 0 ? 1'b0 : or_result[i-1]),
                .xor_in(i == 0 ? 1'b0 : xor_result[i-1]),
                .and_out(and_result[i]),
                .or_out(or_result[i]),
                .xor_out(xor_result[i])
            );
        end
    endgenerate

    assign out_and = and_result[3];
    assign out_or = or_result[3];
    assign out_xor = xor_result[3];

endmodule