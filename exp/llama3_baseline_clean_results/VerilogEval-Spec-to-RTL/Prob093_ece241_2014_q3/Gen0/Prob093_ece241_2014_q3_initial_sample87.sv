module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  assign mux_in[0] = 1'b0;  // ab = 00 corresponds to 0
  assign mux_in[1] = 1'b0;  // ab = 01 corresponds to 0
  assign mux_in[2] = d;    // ab = 11 corresponds to d
  assign mux_in[3] = c;    // ab = 10 corresponds to c

endmodule