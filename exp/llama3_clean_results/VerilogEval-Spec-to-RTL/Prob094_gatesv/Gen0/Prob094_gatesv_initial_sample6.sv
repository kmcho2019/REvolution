module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

assign out_both[3] = 1'b0; // since in[3] has no neighbour to the left
assign out_both[2] = in[2] & in[3];
assign out_both[1] = in[1] & in[2];
assign out_both[0] = in[0] & in[1];

assign out_any[0] = 1'b1; // since in[0] has no neighbour to the right
assign out_any[1] = in[1] | in[0];
assign out_any[2] = in[2] | in[1];

assign out_different[0] = in[0] != in[3]; // wrapping around for the last bit
assign out_different[1] = in[1] != in[0];
assign out_different[2] = in[2] != in[1];
assign out_different[3] = in[3] != in[2];

endmodule