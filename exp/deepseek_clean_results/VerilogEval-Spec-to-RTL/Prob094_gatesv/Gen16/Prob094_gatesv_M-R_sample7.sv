module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except MSB)
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: check current bit or right neighbor (except LSB)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: XOR with left neighbor (wrap around)
    assign out_different = {in[0] ^ in[3], in[3:1] ^ in[2:0]};

endmodule