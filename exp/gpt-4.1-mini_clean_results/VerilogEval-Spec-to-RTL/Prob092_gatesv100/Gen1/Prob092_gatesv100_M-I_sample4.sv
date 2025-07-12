module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Define neighbor vectors to the left and right with wrap and zero edges
wire [99:0] left_neighbor;
wire [99:0] right_neighbor;

// For left_neighbor: in[i]'s left neighbor is in[i+1] except for i=99 (wrap for out_different)
assign left_neighbor[98:0] = in[99:1];  // neighbors for bits 0..98
assign left_neighbor[99] = in[0];       // wrap-around for bit 99 (needed only for out_different)

// For right_neighbor: in[i]'s right neighbor is in[i-1] except for i=0 (set to zero)
assign right_neighbor[99:1] = in[98:0]; // neighbors for bits 1..99
assign right_neighbor[0] = 1'b0;         // no right neighbor for bit 0

// out_both: For bits 0..98: in[i] & left_neighbor[i] (left_neighbor[i]=in[i+1])
// For bit 99: no neighbor to left, output 0
assign out_both[98:0] = in[98:0] & left_neighbor[98:0];
assign out_both[99] = 1'b0;

// out_any: For bits 1..99: in[i] | right_neighbor[i] (right_neighbor[i]=in[i-1])
// For bit 0: no right neighbor, output 0
assign out_any[99:1] = in[99:1] | right_neighbor[99:1];
assign out_any[0] = 1'b0;

// out_different: Each bit i is in[i] ^ left neighbor with wrap-around
assign out_different = in ^ left_neighbor;

endmodule