module TopModule (
  input [31:0] in,
  output [31:0] out
);

  assign out = {in[24:31], in[16:23], in[8:15], in[0:7]};

endmodule