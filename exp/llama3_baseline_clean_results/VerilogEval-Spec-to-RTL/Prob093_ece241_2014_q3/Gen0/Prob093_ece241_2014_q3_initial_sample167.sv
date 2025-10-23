module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  mux_in[0] = 0;
  mux_in[1] = 0;
  mux_in[2] = (d) ? c : 0;
  mux_in[3] = (d) ? 1 : c;

endmodule