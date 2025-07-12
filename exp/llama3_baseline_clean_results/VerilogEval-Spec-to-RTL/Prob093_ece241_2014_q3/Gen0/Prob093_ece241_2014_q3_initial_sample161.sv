module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // For ab = 00, input should always be 0
  assign mux_in[0] = 0;

  // For ab = 01, input should always be 0
  assign mux_in[1] = 0;

  // For ab = 11 and ab = 10, use a 2-to-1 multiplexer with c as select input
  // and d as one of the inputs and 1 as the other input
  assign mux_in[2] = (c) ? 1 : d; // ab = 11
  assign mux_in[3] = (c) ? 1 : d; // ab = 10

endmodule