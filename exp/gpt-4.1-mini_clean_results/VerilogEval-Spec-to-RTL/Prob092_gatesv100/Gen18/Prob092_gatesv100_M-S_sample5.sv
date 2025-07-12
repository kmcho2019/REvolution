module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], with out_both[99] = 0 (no left neighbor)
    assign out_both = (in & {in[98:0], 1'b0});

    // out_any[i] = in[i] | in[i-1], with out_any[0] = 0 (no right neighbor)
    assign out_any = (in | {1'b0, in[99:1]});

    // out_different[i] = in[i] ^ in[(i-1) mod 100] using wrap-around
    assign out_different = in ^ {in[0], in[99:1]};

endmodule