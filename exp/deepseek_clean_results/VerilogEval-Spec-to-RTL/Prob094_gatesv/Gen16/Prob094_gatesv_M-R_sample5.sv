module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except for bit 3)
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: check current bit and right neighbor (except for bit 0)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: circular XOR with left neighbor
    assign out_different = {
        in[3] ^ in[0],  // Bit 3 compares with bit 0 (wrap-around)
        in[2] ^ in[3],
        in[1] ^ in[2],
        in[0] ^ in[1]
    };

endmodule