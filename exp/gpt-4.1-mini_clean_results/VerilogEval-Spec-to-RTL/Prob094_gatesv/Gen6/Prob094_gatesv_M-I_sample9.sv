module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: out_both[3]=0, out_both[2:0] = in[2:0] & in[3:1]
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: out_any[0]=0, out_any[3:1] = in[3:1] | in[2:0]
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different[i] = in[i] ^ in[(i+1) mod 4], wrap around
    assign out_different = in ^ {in[0], in[3:1]};

endmodule