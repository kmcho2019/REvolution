module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // 2-to-1 multiplexer for ab = 00 and ab = 10
  assign mux_in[0] = (c) ? 1 : d;

  // 2-to-1 multiplexer for ab = 01 and ab = 11
  assign mux_in[1] = (c) ? 1 : 0;

  // inputs for ab = 11 and ab = 10
  assign mux_in[2] = (c) ? d : 0;
  assign mux_in[3] = (c) ? 1 : d;

endmodule