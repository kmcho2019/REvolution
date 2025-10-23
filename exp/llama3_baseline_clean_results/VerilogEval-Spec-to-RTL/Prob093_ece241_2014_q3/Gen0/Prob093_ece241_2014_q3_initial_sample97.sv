module TopModule(
  input  c,
  input  d,
  output [3:0] mux_in
);

  // generate c'd' and c + d'
  assign mux_in[0] = ~c & ~d;
  assign mux_in[1] = ~c & ~d;
  assign mux_in[2] = c | ~d;
  assign mux_in[3] = c | d;

endmodule