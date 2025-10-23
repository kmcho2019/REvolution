module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], with in[100] treated as 0
    assign out_both = in & {in[98:0], 1'b0};

    // out_any[i] = in[i] | in[i-1], with in[-1] treated as 0
    assign out_any = in | {1'b0, in[99:1]};

    // out_different[i] = in[i] ^ in[(i-1) mod 100], wrap-around by concatenating in[0]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule