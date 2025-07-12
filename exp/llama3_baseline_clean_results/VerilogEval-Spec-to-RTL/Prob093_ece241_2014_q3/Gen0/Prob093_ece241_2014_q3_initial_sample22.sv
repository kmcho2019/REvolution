module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  // 2-to-1 multiplexer for mux_in[1]
  mux_in[1] = (c) ? (~d) : 0;

  // direct connections
  mux_in[0] = 0;
  mux_in[2] = c;
  mux_in[3] = c;

endmodule