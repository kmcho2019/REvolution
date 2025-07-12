module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], with out_both[3] = 0 (no neighbor)
    assign out_both = in[3:0] & {in[2:0], 1'b0};

    // out_any[i] = in[i] | in[i-1], with out_any[0] = 0 (no neighbor)
    assign out_any = in[3:0] | {1'b0, in[3:1]};

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ {in[0], in[3:1]};

endmodule