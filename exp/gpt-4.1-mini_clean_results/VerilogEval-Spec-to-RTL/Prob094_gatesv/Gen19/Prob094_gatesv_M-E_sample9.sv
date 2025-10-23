module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], MSB no left neighbor -> zero
    // Shift left by 1: in << 1, MSB becomes 0 naturally
    assign out_both = in & (in << 1);

    // out_any[i] = in[i] | in[i-1], LSB no right neighbor -> zero
    // Shift right by 1: in >> 1, LSB becomes 0 naturally
    assign out_any = in | (in >> 1);

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // Circular left rotate by 1: {in[2:0], in[3]}
    wire [3:0] in_rotl = {in[2:0], in[3]};
    assign out_different = in ^ in_rotl;

endmodule