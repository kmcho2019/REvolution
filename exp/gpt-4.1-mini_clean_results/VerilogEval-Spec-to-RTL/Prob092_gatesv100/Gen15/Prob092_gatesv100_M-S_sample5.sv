module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: in[i] & in[i+1], MSB (bit 99) = 0 (no left neighbor)
    assign out_both = (in & (in << 1)) & 100'b0111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

    // out_any: in[i] | in[i-1], LSB (bit 0) = 0 (no right neighbor)
    assign out_any = (in | (in >> 1)) & 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110;

    // out_different: in[i] ^ in[(i+1)%100] (circular left shift by 1)
    assign out_different = in ^ {in[98:0], in[99]};

endmodule