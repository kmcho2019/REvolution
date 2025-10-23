module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, output = c (since d is 0)
  // For ab = 01, output = 0
  // For ab = 11, output = c (since d can be 0 or 1)
  // For ab = 10, output = c + d (since either c or d can be 1)
  assign mux_in[0] = c;  // ab = 00
  assign mux_in[1] = 1'b0;  // ab = 01
  assign mux_in[2] = c;  // ab = 11
  assign mux_in[3] = c | d;  // ab = 10

endmodule