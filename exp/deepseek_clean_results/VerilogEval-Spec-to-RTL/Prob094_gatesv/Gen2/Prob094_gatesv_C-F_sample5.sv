module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: compact concatenation approach from Example 1
    assign out_both = {1'b0, in[3] & in[2], in[2] & in[1], in[1] & in[0]};

    // out_any: compact concatenation approach from Example 1
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different: clear XOR implementation from Example 2
    assign out_different[3] = in[3] ^ in[0];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule