module SegmentOperation(
    input [12:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // Initialize variables to store the result of AND, OR, and XOR operations
    reg and_result = 1'b1;
    reg or_result = 1'b0;
    reg xor_result = 1'b0;

    // Perform AND operation
    always @(in) begin
        and_result = 1'b1;
        or_result = 1'b0;
        xor_result = 1'b0;
        for (int i = 0; i < 13; i = i + 1) begin
            and_result = and_result & in[i];
            or_result = or_result | in[i];
            xor_result = xor_result ^ in[i];
        end
    end

    // Assign results to output ports
    assign and_out = and_result;
    assign or_out = or_result;
    assign xor_out = xor_result;

endmodule

module PipelineStage(
    input  [24:0] in,
    input  and_in,
    input  or_in,
    input  xor_in,
    output and_out,
    output or_out,
    output xor_out
);

    // Divide the input into two 13-bit segments (minus 1 bit for the 25-bit input)
    wire [12:0] seg1;
    wire [12:0] seg2;

    assign seg1 = in[12:0];
    assign seg2 = in[24:13];

    // Perform operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;

    SegmentOperation seg1_op(seg1, and_seg1, or_seg1, xor_seg1);
    SegmentOperation seg2_op(seg2, and_seg2, or_seg2, xor_seg2);

    // Combine the results from each segment
    assign and_out = and_seg1 & and_seg2 & and_in;
    assign or_out = or_seg1 | or_seg2 | or_in;
    assign xor_out = xor_seg1 ^ xor_seg2 ^ xor_in;

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

    PipelineStage stage0(.in(in[24:0]),.and_in(1'b1),.or_in(1'b0),.xor_in(1'b0),.and_out(and_result0),.or_out(or_result0),.xor_out(xor_result0));
    PipelineStage stage1(.in(in[49:25]),.and_in(and_result0),.or_in(or_result0),.xor_in(xor_result0),.and_out(and_result1),.or_out(or_result1),.xor_out(xor_result1));
    PipelineStage stage2(.in(in[74:50]),.and_in(and_result1),.or_in(or_result1),.xor_in(xor_result1),.and_out(and_result2),.or_out(or_result2),.xor_out(xor_result2));
    PipelineStage stage3(.in(in[99:75]),.and_in(and_result2),.or_in(or_result2),.xor_in(xor_result2),.and_out(and_result3),.or_out(or_result3),.xor_out(xor_result3));

    assign out_and = and_result3;
    assign out_or = or_result3;
    assign out_xor = xor_result3;

endmodule