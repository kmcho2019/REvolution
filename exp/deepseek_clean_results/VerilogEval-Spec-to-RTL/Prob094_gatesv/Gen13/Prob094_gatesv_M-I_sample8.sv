module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with left neighbor (bit 3 is unused)
    assign out_both[2:0] = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any: OR with right neighbor (bit 0 is unused)
    assign out_any[3:1] = {in[3] | in[2], in[2] | in[1], in[1] | in[0]};

    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule