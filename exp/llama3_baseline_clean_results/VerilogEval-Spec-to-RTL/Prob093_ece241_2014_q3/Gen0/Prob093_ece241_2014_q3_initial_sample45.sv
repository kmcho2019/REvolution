module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  // ab = 00
  assign mux_in[0] = d ? 1 : 0;

  // ab = 01
  assign mux_in[1] = 0;

  // ab = 11
  assign mux_in[2] = c ? 1 : 0;

  // ab = 10
  assign mux_in[3] = d ? 1 : 0;
endmodule