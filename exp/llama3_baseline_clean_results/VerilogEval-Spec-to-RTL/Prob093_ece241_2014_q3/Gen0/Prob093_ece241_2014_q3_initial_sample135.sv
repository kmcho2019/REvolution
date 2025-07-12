module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, the output is 0
  assign mux_in[0] = 1'b0;

  // For ab = 01, the output is 0
  assign mux_in[1] = 1'b0;

  // For ab = 11, the output depends on c and d
  // Using a 2-to-1 multiplexer to select between c and d
  assign mux_in[2] = (d == 1'b1) ? c : 1'b0;

  // For ab = 10, the output depends on c and d
  // Using a 2-to-1 multiplexer to select between c and d
  assign mux_in[3] = (d == 1'b1) ? c : 1'b1;
endmodule