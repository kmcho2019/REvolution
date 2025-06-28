module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  assign mux_in[0] = c & ~d; // K-map entry: ab=00
  assign mux_in[1] = ~c & ~d; // K-map entry: ab=01
  assign mux_in[2] = c | d; // K-map entry: ab=11
  assign mux_in[3] = c & d; // K-map entry: ab=10

endmodule