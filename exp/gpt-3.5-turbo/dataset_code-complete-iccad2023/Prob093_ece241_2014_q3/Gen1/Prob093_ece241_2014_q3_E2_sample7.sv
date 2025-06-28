module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire m0, m1, m2, m3;

  assign m0 = ~c & d;
  assign m1 = c & ~d;
  assign m2 = c | d;
  assign m3 = c & d;

  assign mux_in[0] = m0;
  assign mux_in[1] = m1;
  assign mux_in[2] = m2;
  assign mux_in[3] = m3;

endmodule