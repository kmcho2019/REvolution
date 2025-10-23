module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Implementing the logic for each input of the 4-to-1 multiplexer
  // mux_in[0] corresponds to ab = 00
  assign mux_in[0] = c;

  // mux_in[1] corresponds to ab = 01
  assign mux_in[1] = 1'b0;

  // mux_in[2] corresponds to ab = 11
  assign mux_in[2] = c;

  // mux_in[3] corresponds to ab = 10
  assign mux_in[3] = c;
endmodule