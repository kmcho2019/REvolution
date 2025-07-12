module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// Calculate out_both
assign out_both[3] = 1'b0; // Since in[3] has no left neighbour
assign out_both[2] = in[2] & in[3];
assign out_both[1] = in[1] & in[2];
assign out_both[0] = in[0] & in[1];

// Calculate out_any
assign out_any[2] = in[2] | in[1];
assign out_any[1] = in[1] | in[0];
assign out_any[0] = in[0] | in[3]; // Since in[0] has no right neighbour, we consider in[3] as its right neighbour for wrapping

// Calculate out_different
assign out_different[3] = in[3] ^ in[0]; // in[3]'s left neighbour is in[0] due to wrapping
assign out_different[2] = in[2] ^ in[3];
assign out_different[1] = in[1] ^ in[2];
assign out_different[0] = in[0] ^ in[1];

endmodule