module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  assign mux_in[0] = ~c & ~d; // Simplified expression for ab=01
  assign mux_in[1] = c & d;   // Simplified expression for ab=00
  assign mux_in[2] = c & ~d;  // Simplified expression for ab=10
  assign mux_in[3] = c;       // Simplified expression for ab=11

endmodule