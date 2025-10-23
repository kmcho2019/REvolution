module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Pre-compute rotated input for out_different
    wire [3:0] in_rot = {in[0], in[3:1]};

    // out_both: only lower 3 bits are meaningful
    assign out_both[2:0] = in[3:1] & in[2:0];

    // out_any: only upper 3 bits are meaningful
    assign out_any[3:1] = in[3:1] | in[2:0];

    // out_different: all bits are meaningful with wrap-around
    assign out_different = in ^ in_rot;

endmodule