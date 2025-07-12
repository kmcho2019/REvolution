module SegmentOperation(
    input [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = (in[0] & in[1] & in[2] & in[3] & in[4] & in[5] & in[6] & in[7] & in[8] & in[9]);
    assign or_out = (in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7] | in[8] | in[9]);
    assign xor_out = (in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7] ^ in[8] ^ in[9]);

endmodule

module TopModule(
    input [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    reg [9:0] and_results;
    reg [9:0] or_results;
    reg [9:0] xor_results;

    SegmentOperation seg0(.in(in[9:0]), .and_out(and_results[0]), .or_out(or_results[0]), .xor_out(xor_results[0]));
    SegmentOperation seg1(.in(in[19:10]), .and_out(and_results[1]), .or_out(or_results[1]), .xor_out(xor_results[1]));
    SegmentOperation seg2(.in(in[29:20]), .and_out(and_results[2]), .or_out(or_results[2]), .xor_out(xor_results[2]));
    SegmentOperation seg3(.in(in[39:30]), .and_out(and_results[3]), .or_out(or_results[3]), .xor_out(xor_results[3]));
    SegmentOperation seg4(.in(in[49:40]), .and_out(and_results[4]), .or_out(or_results[4]), .xor_out(xor_results[4]));
    SegmentOperation seg5(.in(in[59:50]), .and_out(and_results[5]), .or_out(or_results[5]), .xor_out(xor_results[5]));
    SegmentOperation seg6(.in(in[69:60]), .and_out(and_results[6]), .or_out(or_results[6]), .xor_out(xor_results[6]));
    SegmentOperation seg7(.in(in[79:70]), .and_out(and_results[7]), .or_out(or_results[7]), .xor_out(xor_results[7]));
    SegmentOperation seg8(.in(in[89:80]), .and_out(and_results[8]), .or_out(or_results[8]), .xor_out(xor_results[8]));
    SegmentOperation seg9(.in(in[99:90]), .and_out(and_results[9]), .or_out(or_results[9]), .xor_out(xor_results[9]));

    always @(and_results or or_results or xor_results) begin
        out_and = and_results[0] & and_results[1] & and_results[2] & and_results[3] & and_results[4] & and_results[5] & and_results[6] & and_results[7] & and_results[8] & and_results[9];
        out_or = or_results[0] | or_results[1] | or_results[2] | or_results[3] | or_results[4] | or_results[5] | or_results[6] | or_results[7] | or_results[8] | or_results[9];
        out_xor = xor_results[0] ^ xor_results[1] ^ xor_results[2] ^ xor_results[3] ^ xor_results[4] ^ xor_results[5] ^ xor_results[6] ^ xor_results[7] ^ xor_results[8] ^ xor_results[9];
    end

endmodule