module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[98:0] = in[98:0] & in[99:1], out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[99:1] = in[99:1] | in[98:0], out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[left_neighbor], with wrap-around for i=0
    assign out_different = in ^ {in[0], in[99:1]};

endmodule