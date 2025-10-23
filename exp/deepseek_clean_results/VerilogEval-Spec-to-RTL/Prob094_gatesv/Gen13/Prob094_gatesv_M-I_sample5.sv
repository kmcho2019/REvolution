module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared intermediate signals for common bit pairs
    wire [2:0] pair_and = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};
    wire [2:0] pair_or = {in[2] | in[3], in[1] | in[2], in[0] | in[1]};
    wire [2:0] pair_xor = {in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

    // out_both: check current and left neighbor (MSB don't care)
    assign out_both = {1'b0, pair_and};

    // out_any: check current or right neighbor (LSB don't care)
    assign out_any = {pair_or, 1'b0};

    // out_different: XOR with left neighbor (wrapped)
    assign out_different = {in[3] ^ in[0], pair_xor};

endmodule