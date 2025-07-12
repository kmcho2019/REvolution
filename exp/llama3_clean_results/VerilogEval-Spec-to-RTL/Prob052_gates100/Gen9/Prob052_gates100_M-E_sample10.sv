module ChunkProcessor(
    input  [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    wire [4:0] and_tree;
    wire [4:0] or_tree;
    wire [4:0] xor_tree;

    assign and_tree[0] = in[0]  & in[1]  & in[2];
    assign and_tree[1] = in[3]  & in[4]  & in[5];
    assign and_tree[2] = in[6]  & in[7]  & in[8];
    assign and_tree[3] = in[9];
    assign and_tree[4] = 1'b1;

    assign or_tree[0]  = in[0]  | in[1]  | in[2];
    assign or_tree[1]  = in[3]  | in[4]  | in[5];
    assign or_tree[2]  = in[6]  | in[7]  | in[8];
    assign or_tree[3]  = in[9];
    assign or_tree[4]  = 1'b0;

    assign xor_tree[0] = in[0]  ^ in[1]  ^ in[2];
    assign xor_tree[1] = in[3]  ^ in[4]  ^ in[5];
    assign xor_tree[2] = in[6]  ^ in[7]  ^ in[8];
    assign xor_tree[3] = in[9];
    assign xor_tree[4] = 1'b0;

    assign and_out = and_tree[0] & and_tree[1] & and_tree[2] & and_tree[3] & and_tree[4];
    assign or_out  = or_tree[0]  | or_tree[1]  | or_tree[2]  | or_tree[3]  | or_tree[4];
    assign xor_out = xor_tree[0] ^ xor_tree[1] ^ xor_tree[2] ^ xor_tree[3] ^ xor_tree[4];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [9:0] and_result0;
    wire [9:0] or_result0;
    wire [9:0] xor_result0;
    wire [9:0] and_result1;
    wire [9:0] or_result1;
    wire [9:0] xor_result1;
    wire [9:0] and_result2;
    wire [9:0] or_result2;
    wire [9:0] xor_result2;
    wire [9:0] and_result3;
    wire [9:0] or_result3;
    wire [9:0] xor_result3;
    wire [9:0] and_result4;
    wire [9:0] or_result4;
    wire [9:0] xor_result4;
    wire [9:0] and_result5;
    wire [9:0] or_result5;
    wire [9:0] xor_result5;
    wire [9:0] and_result6;
    wire [9:0] or_result6;
    wire [9:0] xor_result6;
    wire [9:0] and_result7;
    wire [9:0] or_result7;
    wire [9:0] xor_result7;
    wire [9:0] and_result8;
    wire [9:0] or_result8;
    wire [9:0] xor_result8;
    wire [9:0] and_result9;
    wire [9:0] or_result9;
    wire [9:0] xor_result9;
    wire [9:0] and_result10;
    wire [9:0] or_result10;
    wire [9:0] xor_result10;

    ChunkProcessor chunk0(.in({in[9:0]}), .and_out(and_result0), .or_out(or_result0), .xor_out(xor_result0));
    ChunkProcessor chunk1(.in({in[19:10]}), .and_out(and_result1), .or_out(or_result1), .xor_out(xor_result1));
    ChunkProcessor chunk2(.in({in[29:20]}), .and_out(and_result2), .or_out(or_result2), .xor_out(xor_result2));
    ChunkProcessor chunk3(.in({in[39:30]}), .and_out(and_result3), .or_out(or_result3), .xor_out(xor_result3));
    ChunkProcessor chunk4(.in({in[49:40]}), .and_out(and_result4), .or_out(or_result4), .xor_out(xor_result4));
    ChunkProcessor chunk5(.in({in[59:50]}), .and_out(and_result5), .or_out(or_result5), .xor_out(xor_result5));
    ChunkProcessor chunk6(.in({in[69:60]}), .and_out(and_result6), .or_out(or_result6), .xor_out(xor_result6));
    ChunkProcessor chunk7(.in({in[79:70]}), .and_out(and_result7), .or_out(or_result7), .xor_out(xor_result7));
    ChunkProcessor chunk8(.in({in[89:80]}), .and_out(and_result8), .or_out(or_result8), .xor_out(xor_result8));
    ChunkProcessor chunk9(.in({in[99:90]}), .and_out(and_result9), .or_out(or_result9), .xor_out(xor_result9));
    ChunkProcessor chunk10(.in({10'b0}), .and_out(and_result10), .or_out(or_result10), .xor_out(xor_result10));

    assign out_and = and_result0 & and_result1 & and_result2 & and_result3 & and_result4 & and_result5 & and_result6 & and_result7 & and_result8 & and_result9 & and_result10;
    assign out_or = or_result0 | or_result1 | or_result2 | or_result3 | or_result4 | or_result5 | or_result6 | or_result7 | or_result8 | or_result9 | or_result10;
    assign out_xor = xor_result0 ^ xor_result1 ^ xor_result2 ^ xor_result3 ^ xor_result4 ^ xor_result5 ^ xor_result6 ^ xor_result7 ^ xor_result8 ^ xor_result9 ^ xor_result10;

endmodule