module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // mux_in[0] = (c && d)
  assign mux_in[0] = (c && d) ? 1'b1 : 1'b0;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = (c && d)
  assign mux_in[2] = (c && d) ? 1'b1 : 1'b0;

  // mux_in[3] = c
  assign mux_in[3] = c;

endmodule