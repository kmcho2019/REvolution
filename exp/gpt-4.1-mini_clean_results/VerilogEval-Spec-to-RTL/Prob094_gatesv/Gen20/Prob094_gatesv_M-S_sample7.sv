module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// out_both: each bit checks if in[i] & in[i+1], last bit has no left neighbor, zero it by ANDing with 4'b0111_0 (shifted zero)
assign out_both = (in & {in[2:0], 1'b0}) & 4'b0111;

// out_any: each bit checks if in[i] | in[i-1], first bit no right neighbor, zero it by ORing with 4'b1110
assign out_any = (in | {1'b0, in[3:1]}) & 4'b1110;

// out_different: XOR with left neighbor, wrapping left neighbor vector is {in[0], in[3:1]} written inline
assign out_different = in ^ {in[0], in[3:1]};

endmodule