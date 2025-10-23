module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, output is always 0 except when c = 1 and d = 0.
  // But in K-map, there is no 1 at cd = 01. So, we can directly assign 0.
  assign mux_in[0] = 0;

  // For ab = 01, output is always 0.
  assign mux_in[1] = 0;

  // For ab = 11, output depends on c and d. 
  // We can use a 2-to-1 multiplexer with 'd' as select line.
  // If d = 0, output is c, if d = 1, output is 1.
  assign mux_in[2] = (d) ? 1 : c;

  // For ab = 10, output is 1 when c = 1 or d = 0.
  // We can use a 2-to-1 multiplexer with 'd' as select line.
  // If d = 0, output is 1, if d = 1, output is c.
  assign mux_in[3] = (d) ? c : 1;
endmodule