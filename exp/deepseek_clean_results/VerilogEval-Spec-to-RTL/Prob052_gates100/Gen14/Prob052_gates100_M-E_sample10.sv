module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Pad inputs to next power of 2 (128) with neutral values
    wire [127:0] padded_in;
    assign padded_in[99:0] = in;
    assign padded_in[127:100] = {28{1'b1}};  // Neutral for AND (1), OR/XOR will override

    // Binary tree reduction for AND
    wire [127:0] and_tree [0:6];
    assign and_tree[0] = padded_in;
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : and_tree_gen
            assign and_tree[i] = and_tree[i-1][127:0] & {and_tree[i-1][126:0], 1'b1};
        end
    endgenerate
    assign out_and = and_tree[6][127];

    // Binary tree reduction for OR (override padding)
    wire [127:0] or_tree [0:6];
    assign or_tree[0] = {28'b0, in};
    generate
        for (i = 1; i < 7; i = i + 1) begin : or_tree_gen
            assign or_tree[i] = or_tree[i-1][127:0] | {or_tree[i-1][126:0], 1'b0};
        end
    endgenerate
    assign out_or = or_tree[6][127];

    // Binary tree reduction for XOR (override padding)
    wire [127:0] xor_tree [0:6];
    assign xor_tree[0] = {28'b0, in};
    generate
        for (i = 1; i < 7; i = i + 1) begin : xor_tree_gen
            assign xor_tree[i] = xor_tree[i-1][127:0] ^ {xor_tree[i-1][126:0], 1'b0};
        end
    endgenerate
    assign out_xor = xor_tree[6][127];

endmodule