module TopModule(
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

assign out_both[0] = 1'b0; // There is no neighbour to the left of in[0]
assign out_both[1] = in[1] & in[2];
assign out_both[2] = in[2] & in[3];
assign out_both[3] = 1'b0; // We don't need to know out_both[3]

assign out_any[0] = in[0] | in[3]; // in[0]'s neighbour to the right is in[3] (wrap around)
assign out_any[1] = in[0] | in[1];
assign out_any[2] = in[1] | in[2];
assign out_any[3] = 1'b0; // There is no need to calculate out_any[3]

assign out_different[0] = in[0] ^ in[3]; // in[0]'s neighbour to the left is in[3] (wrap around)
assign out_different[1] = in[1] ^ in[2];
assign out_different[2] = in[2] ^ in[3];
assign out_different[3] = in[3] ^ in[0]; // in[3]'s neighbour to the left is in[0] (wrap around)

endmodule