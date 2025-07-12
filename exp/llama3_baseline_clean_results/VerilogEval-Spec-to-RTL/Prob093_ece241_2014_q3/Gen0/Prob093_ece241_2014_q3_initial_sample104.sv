module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, output should be 'd'
  assign mux_in[0] = d;
  
  // For ab = 01, output should be 'c'
  assign mux_in[1] = c;
  
  // For ab = 11, output should also be 'c'
  assign mux_in[2] = c;
  
  // For ab = 10, output should be 'd'
  assign mux_in[3] = c ? 1 : d;
endmodule