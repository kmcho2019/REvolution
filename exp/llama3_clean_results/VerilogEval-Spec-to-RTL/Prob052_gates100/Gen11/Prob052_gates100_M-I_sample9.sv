module TreeOperation(
    input  [12:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    wire [2:0] and_tree;
    wire [2:0] or_tree;
    wire [2:0] xor_tree;

    assign and_tree[0] = in[0]  & in[1]  & in[2]  & in[3];
    assign and_tree[1] = in[4]  & in[5]  & in[6]  & in[7];
    assign and_tree[2] = in[8]  & in[9]  & in[10] & in[11] & in[12];

    assign or_tree[0]  = in[0]  | in[1]  | in[2]  | in[3];
    assign or_tree[1]  = in[4]  | in[5]  | in[6]  | in[7];
    assign or_tree[2]  = in[8]  | in[9]  | in[10] | in[11] | in[12];

    assign xor_tree[0] = in[0]  ^ in[1]  ^ in[2]  ^ in[3];
    assign xor_tree[1] = in[4]  ^ in[5]  ^ in[6]  ^ in[7];
    assign xor_tree[2] = in[8]  ^ in[9]  ^ in[10] ^ in[11] ^ in[12];

    assign and_out = and_tree[0] & and_tree[1] & and_tree[2];
    assign or_out  = or_tree[0]  | or_tree[1]  | or_tree[2];
    assign xor_out = xor_tree[0] ^ xor_tree[1] ^ xor_tree[2];

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

    TreeOperation tree0(.in({in[12:0]}), .and_out(and_result0), .or_out(or_result0), .xor_out(xor_result0));
    TreeOperation tree1(.in({in[24:13]}), .and_out(and_result1), .or_out(or_result1), .xor_out(xor_result1));
    TreeOperation tree2(.in({in[36:25]}), .and_out(and_result2), .or_out(or_result2), .xor_out(xor_result2));
    TreeOperation tree3(.in({in[48:37]}), .and_out(and_result3), .or_out(or_result3), .xor_out(xor_result3));
    TreeOperation tree4(.in({in[60:49]}), .and_out(and_result4), .or_out(or_result4), .xor_out(xor_result4));
    TreeOperation tree5(.in({in[72:61]}), .and_out(and_result5), .or_out(or_result5), .xor_out(xor_result5));
    TreeOperation tree6(.in({in[84:73]}), .and_out(and_result6), .or_out(or_result6), .xor_out(xor_result6));
    TreeOperation tree7(.in({in[99:85]}), .and_out(and_result7), .or_out(or_result7), .xor_out(xor_result7));

    assign out_and = and_result0 & and_result1 & and_result2 & and_result3 & and_result4 & and_result5 & and_result6 & and_result7;
    assign out_or = or_result0 | or_result1 | or_result2 | or_result3 | or_result4 | or_result5 | or_result6 | or_result7;
    assign out_xor = xor_result0 ^ xor_result1 ^ xor_result2 ^ xor_result3 ^ xor_result4 ^ xor_result5 ^ xor_result6 ^ xor_result7;

endmodule