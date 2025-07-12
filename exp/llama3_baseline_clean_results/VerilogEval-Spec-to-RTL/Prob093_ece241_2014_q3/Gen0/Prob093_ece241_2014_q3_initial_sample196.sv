module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;
  
  // Use 2-to-1 multiplexers to generate the required outputs
  assign mux_in[0] = 0;  // For ab = 00, output is 0
  assign mux_in[1] = 0;  // For ab = 01, output is 0
  assign mux_in[2] = (d) ? c : 1;  // For ab = 11, output is c, and for ab = 10, output is 1
  assign mux_in[3] = (d) ? 1 : 1;  // For ab = 10, output is 1, and for ab = 11, output is 1
  
endmodule