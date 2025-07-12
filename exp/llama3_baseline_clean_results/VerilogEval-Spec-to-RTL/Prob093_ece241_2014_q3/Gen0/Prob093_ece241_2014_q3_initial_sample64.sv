module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Generate input for ab = 00 and ab = 01
  assign mux_in[0] = 1'b0;
  assign mux_in[1] = 1'b0;

  // Generate input for ab = 10
  assign mux_in[2] = (c) ? 1'b1 : d;

  // Generate input for ab = 11
  assign mux_in[3] = (c) ? 1'b1 : 1'b0;
endmodule