module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;
  
  // Using two 2-to-1 multiplexers to generate inputs for the 4-to-1 multiplexer
  // based on the Karnaugh map
  mux_in[0] = 0; // ab = 00
  mux_in[1] = ~d; // ab = 01
  mux_in[2] = c; // ab = 11
  mux_in[3] = c; // ab = 10
  
endmodule