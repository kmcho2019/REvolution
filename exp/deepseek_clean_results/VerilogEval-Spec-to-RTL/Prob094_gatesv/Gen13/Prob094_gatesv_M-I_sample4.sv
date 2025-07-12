module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Rotated input vector (left rotation by 1) for shared use
    wire [3:0] in_rotated = {in[0], in[3:1]};

    // out_both: check current bit and left neighbor (bit 3 is don't-care)
    assign out_both = {1'b0,        // out_both[3] unused
                       in[2] & in[3],
                       in[1] & in[2],
                       in[0] & in[1]};

    // out_any: check current bit or right neighbor (bit 0 is don't-care)
    assign out_any = {in[3] | in[2],
                      in[2] | in[1],
                      in[1] | in[0],
                      1'b0};        // out_any[0] unused

    // out_different: check current bit against left neighbor (wrapped around)
    assign out_different = in ^ in_rotated;

endmodule