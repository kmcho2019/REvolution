module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;
  
  // For ab=00, output is d
  assign mux_in[0] = d;
  
  // For ab=01, output is c
  assign mux_in[1] = c;
  
  // For ab=11, output is c+d, use a 2-to-1 multiplexer with 'c' and 'd' as inputs and 'd' as the selector input
  assign mux_in[2] = (d) ? d : c;
  
  // For ab=10, output is c
  assign mux_in[3] = c;

endmodule