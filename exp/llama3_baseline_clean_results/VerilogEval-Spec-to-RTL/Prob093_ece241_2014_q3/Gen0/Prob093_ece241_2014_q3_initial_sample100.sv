module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  mux_in[0] = 0;
  mux_in[1] = 0;
  mux_in[2] = c;
  mux_in[3] = (c == 1) ? d : 1;

endmodule