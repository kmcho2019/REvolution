module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Left neighbor of bit i is in[i+1] except for i=99 (no left neighbor)
    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99]=0
    assign out_both = (in & (in << 1)) & ~{1'b1, 99'b0};

    // Right neighbor of bit i is in[i-1], out_any[0] = 0
    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0]=0
    assign out_any = (in | (in >> 1)) & ~{1'b0, 99'b1};

    // out_different[i] = in[i] ^ in[(i+1)%100], wrap-around left neighbor by rotate left 1
    assign out_different = in ^ {in[98:0], in[99]};

endmodule