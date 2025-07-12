module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  // 2-to-1 multiplexers for mux_in[0] and mux_in[1]
  assign mux_in[0] = (c) ? 1'b1 : 1'b0;
  assign mux_in[1] = (d) ? 1'b0 : 1'b0;

  // 2-to-1 multiplexers for mux_in[2] and mux_in[3]
  assign mux_in[2] = (d) ? 1'b1 : 1'b0;
  assign mux_in[3] = (d) ? 1'b1 : 1'b1;

endmodule