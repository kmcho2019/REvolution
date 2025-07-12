module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (MSB is don't care)
    assign out_both[2:0] = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any: check current bit or right neighbor (LSB is don't care)
    assign out_any[3:1] = {in[3] | in[2], in[2] | in[1], in[1] | in[0]};

    // out_different: check current bit vs left neighbor with wrap-around
    // Note: in[3] compares with in[0] for wrap-around behavior
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule