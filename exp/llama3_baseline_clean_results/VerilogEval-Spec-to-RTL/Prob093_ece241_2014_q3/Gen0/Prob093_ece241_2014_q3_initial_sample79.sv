module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  // Direct connections for ab = 00 and 10
  assign mux_in[0] = d;
  assign mux_in[2] = 1'b1; // for ab = 11, output is 'c' or '1'
  assign mux_in[3] = c;

  // 2-to-1 multiplexer for ab = 01 and 11
  assign mux_in[1] = (d) ? c : 1'b0;
endmodule