module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, output is d when c is 1 and 0 when c is 0
  assign mux_in[0] = (c) ? d : 0;

  // For ab = 01, output is always 0
  assign mux_in[1] = 0;

  // For ab = 10, output is 'd' when 'c' is 0 and 'c' when 'd' is 1
  assign mux_in[2] = (d) ? c : d;

  // For ab = 11, output is 'c' when 'd' is 0 and 'd' when 'c' is 0 and 'd' is 1
  assign mux_in[3] = (d) ? d : c;

endmodule