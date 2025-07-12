module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// out_both: bits 0..2 = in[i] & in[i+1], bit 3 = 0 (no left neighbor)
assign out_both[2:0] = in[2:0] & in[3:1];
assign out_both[3] = 1'b0;

// out_any: bits 1..3 = in[i] | in[i-1], bit 0 = 0 (no right neighbor)
assign out_any[3:1] = in[3:1] | in[2:0];
assign out_any[0] = 1'b0;

// out_different: wrap neighbor to left, i.e., neighbor of in[3] is in[0]
wire [3:0] neighbor_left = {in[0], in[3:1]};
assign out_different = in ^ neighbor_left;

endmodule