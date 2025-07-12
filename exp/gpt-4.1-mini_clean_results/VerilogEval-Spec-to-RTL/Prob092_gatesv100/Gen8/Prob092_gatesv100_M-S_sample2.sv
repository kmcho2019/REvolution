module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// out_both[i] = in[i] & in[i+1] (neighbor left), with zero at MSB (no neighbor)
assign out_both = in & {in[98:0], 1'b0};

// out_any[i] = in[i] | in[i-1] (neighbor right), with zero at LSB (no neighbor)
assign out_any = in | {1'b0, in[99:1]};

// out_different[i] = in[i] ^ in[(i+1) mod 100], wrap-around by left-rotation
assign out_different = in ^ {in[98:0], in[99]};

endmodule