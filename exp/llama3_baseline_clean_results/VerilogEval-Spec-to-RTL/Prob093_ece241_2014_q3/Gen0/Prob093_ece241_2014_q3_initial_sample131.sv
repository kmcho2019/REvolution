module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Using a 2-to-1 multiplexer to generate the input for ab = 10 and ab = 11
  // Select 'c' when d = 0 and 'd' when d = 1
  assign mux_in[3] = d;  // ab = 11
  assign mux_in[2] = c;  // ab = 10
  assign mux_in[1] = 1'b0;  // ab = 01
  assign mux_in[0] = 1'b0;  // ab = 00

endmodule