module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  assign mux_in[0] = 1'b0; // for (a, b) = (0, 0)
  assign mux_in[1] = 1'b0; // for (a, b) = (0, 1)
  assign mux_in[2] = 1'b1; // for (a, b) = (1, 1)
  assign mux_in[3] = 1'b1; // for (a, b) = (1, 0)

endmodule