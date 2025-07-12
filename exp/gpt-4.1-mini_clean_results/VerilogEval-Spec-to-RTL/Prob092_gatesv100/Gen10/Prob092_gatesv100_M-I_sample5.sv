module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: For bits 0 to 98, check in[i] & in[i+1], out_both[99]=0
assign out_both[98:0] = in[98:0] & in[99:1];
assign out_both[99] = 1'b0;

// out_any: For bits 1 to 99, check in[i] | in[i-1], out_any[0]=0
assign out_any[99:1] = in[99:1] | in[98:0];
assign out_any[0] = 1'b0;

// out_different: Each bit i = in[i] ^ in[(i-1) mod 100], wrap-around
// Create a left neighbor vector by wrapping in[99] as neighbor to in[0]
wire [99:0] left_neighbor = {in[0], in[99:1]};
assign out_different = in ^ left_neighbor;

endmodule