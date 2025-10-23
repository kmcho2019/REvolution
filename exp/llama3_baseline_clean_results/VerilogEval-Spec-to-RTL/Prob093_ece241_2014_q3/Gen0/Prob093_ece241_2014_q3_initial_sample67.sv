module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  assign mux_in[0] = 1'b0;  // Output for ab = 00
  assign mux_in[1] = (c == 1'b1) ? 1'b1 : 1'b0;  // Output for ab = 01
  assign mux_in[2] = (c == 1'b1) ? 1'b1 : 1'b0;  // Output for ab = 11
  assign mux_in[3] = (d == 1'b1) ? 1'b1 : (c == 1'b1) ? 1'b1 : 1'b0;  // Output for ab = 10

endmodule