module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (MSB is don't care)
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: check current bit or right neighbor (LSB is don't care)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: check current bit vs left neighbor (wrapped)
    assign out_different = {in[3] ^ in[0], in[2:0] ^ in[3:1]};

endmodule