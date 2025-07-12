module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Implement mux_in[0]
  assign mux_in[0] = (c) ? d : 1;

  // Implement mux_in[1]
  assign mux_in[1] = (c) ? 0 : d;

  // Implement mux_in[2]
  assign mux_in[2] = (c) ? 1 : d;

  // Implement mux_in[3]
  assign mux_in[3] = (c) ? 1 : d;
endmodule