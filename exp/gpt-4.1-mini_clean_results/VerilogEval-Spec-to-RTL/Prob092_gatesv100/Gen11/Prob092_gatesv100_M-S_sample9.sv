module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// out_both[i] = in[i] & in[i+1], with out_both[99] = 0
assign out_both = (in & (in << 1)) & 100'h7FFFFFFFFFFFFFFFFFFFF; // mask MSB zero

// out_any[i] = in[i] | in[i-1], with out_any[0] = 0
assign out_any = (in | (in >> 1)) & 100'hFFFFFFFFFFFFFFFFFFFE; // mask LSB zero

// out_different[i] = in[i] ^ in[(i+1) mod 100]
assign out_different = in ^ {in[0], in[99:1]};

endmodule