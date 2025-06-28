module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire out1, out2, out3, out4;

  // Group of 1s corresponding to mux_in[0]
  assign out1 = (c & !d) | (c & d) | (c & !d) | (!c & d);
  
  // Group of 1s corresponding to mux_in[1]
  assign out2 = (c & d);
  
  // Group of 1s corresponding to mux_in[2]
  assign out3 = (c & d) | (!c & d) | (c & !d) | (c & d);
  
  // Group of 1s corresponding to mux_in[3]
  assign out4 = (c & d) | (c & !d);

  // 2-to-1 mux for each output bit
  mux2to1 mux1 (.a(a), .b(b), .s(c), .y(out1), .x(0));
  mux2to1 mux2 (.a(a), .b(b), .s(c), .y(out2), .x(0));
  mux2to1 mux3 (.a(a), .b(b), .s(c), .y(out3), .x(0));
  mux2to1 mux4 (.a(a), .b(b), .s(c), .y(out4), .x(0));

  // 4-to-1 mux for final output
  mux4to1 mux4to1_inst (.a(a), .b(b), .s(d), .mux_in({out4, out3, out1, out2}));

endmodule