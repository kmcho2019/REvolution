module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Generate the inputs for the 4-to-1 multiplexer
  // For ab = 00
  assign mux_in[0] = (c && d) ? 1'b1 : (c && !d) ? 1'b1 : (d && !c) ? 1'b1 : 1'b0;
  
  // For ab = 01
  assign mux_in[1] = (c && !d) ? 1'b0 : (c && d) ? 1'b0 : (d && !c) ? 1'b0 : 1'b0;
  
  // For ab = 11
  assign mux_in[2] = (c && d) ? 1'b1 : (c && !d) ? 1'b0 : (d && !c) ? 1'b0 : 1'b0;
  
  // For ab = 10
  assign mux_in[3] = (c && d) ? 1'b1 : (c && !d) ? 1'b1 : (d && !c) ? 1'b1 : 1'b1;

endmodule