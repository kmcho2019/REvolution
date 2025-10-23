module TopModule(
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: in[i] & in[i+1], i=0..2; out_both[3]=0 (no left neighbor)
    assign out_both = (in & (in << 1)) & 4'b0111;

    // out_any: in[i] | in[i-1], i=1..3; out_any[0]=0 (no right neighbor)
    assign out_any = (in | (in >> 1)) & 4'b1110;

    // out_different: in[i] ^ in[left neighbor] with wrap-around left neighbor (rotate left by 1)
    assign out_different = in ^ {in[2:0], in[3]};

endmodule