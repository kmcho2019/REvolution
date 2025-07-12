module TopModule(
  input c,
  input d,
  output [3:0] mux_in
);

  // For the 00 case, a 2-to-1 multiplexer that selects between 'c' and 0 based on 'd'
  assign mux_in[0] = d ? 0 : c;

  // For the 01 case, directly connect 0 to the multiplexer input
  assign mux_in[1] = 0;

  // For the 11 and 10 cases, a 2-to-1 multiplexer that selects between 'c' and 'd' based on 'b'
  // However, we don't have 'b' in the module, so we need to think about how the K-map is implemented
  // with 'a' and 'b' as the selector inputs of the 4-to-1 multiplexer.
  // The 11 case corresponds to 'd', and the 10 case corresponds to 'c', so we can directly assign
  // 'd' to mux_in[3] and 'c' to mux_in[2]
  assign mux_in[2] = c;
  assign mux_in[3] = d;

endmodule