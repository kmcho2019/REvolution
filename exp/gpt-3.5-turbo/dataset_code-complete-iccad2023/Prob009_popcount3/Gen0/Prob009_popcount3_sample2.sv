module TopModule (
  input [2:0] in,
  output [1:0] out
);

  wire [1:0] count;

  assign count[0] = in[0] ^ in[1];
  assign count[1] = (in[0] & in[1]) | (count[0] & in[2]);

  assign out = count;

endmodule