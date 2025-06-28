module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire ma0, ma1, mb0, mb1;

  // 2-to-1 multiplexer for c
  assign ma0 = c & ~d;
  assign ma1 = c | d;

  // 2-to-1 multiplexer for d
  assign mb0 = c & d;
  assign mb1 = ~c & d;

  // 4-to-1 multiplexer for final implementation
  assign mux_in[0] = ma0 & mb0;
  assign mux_in[1] = ma1 & mb0;
  assign mux_in[2] = ma1 & mb1;
  assign mux_in[3] = ma1 & mb0;

endmodule