module TopModule(
    input [31:0] in,
    output [31:0] out
);

assign out[31:24] = in[7:0];  // assign byte 0 of in to byte 3 of out
assign out[23:16] = in[15:8]; // assign byte 1 of in to byte 2 of out
assign out[15:8] = in[23:16]; // assign byte 2 of in to byte 1 of out
assign out[7:0] = in[31:24];  // assign byte 3 of in to byte 0 of out

endmodule