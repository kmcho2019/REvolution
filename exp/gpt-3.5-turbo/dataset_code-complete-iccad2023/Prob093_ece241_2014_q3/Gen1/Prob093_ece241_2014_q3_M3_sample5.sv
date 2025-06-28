module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  // Mux_in[0]
  assign mux_in[0] = (~c & ~d) | (c & ~d) | (c & d);

  // Mux_in[1]
  assign mux_in[1] = (c & ~d);

  // Mux_in[2]
  assign mux_in[2] = (c & d) | (~c & d);

  // Mux_in[3]
  assign mux_in[3] = (c & ~d) | (~c & d) | (c & d);

endmodule