module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: bits 0 to 98 = in[i] & in[i+1]; bit 99 = 0
    assign out_both = { (in[98:0] & in[99:1]), 1'b0 };

    // out_any: bits 1 to 99 = in[i] | in[i-1]; bit 0 = 0
    assign out_any = { (in[99:1] | in[98:0]), 1'b0 };

    // out_different: circular XOR with left neighbor (wrap-around)
    assign out_different = in ^ { in[0], in[99:1] };

endmodule