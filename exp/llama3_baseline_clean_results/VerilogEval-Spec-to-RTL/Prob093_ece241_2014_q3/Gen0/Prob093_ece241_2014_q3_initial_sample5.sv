module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // 2-to-1 multiplexers to generate inputs for the 4-to-1 multiplexer
  assign mux_in[0] = 0; // ab = 00
  assign mux_in[1] = ~c; // ab = 01
  assign mux_in[2] = d; // ab = 11
  assign mux_in[3] = c; // ab = 10

endmodule