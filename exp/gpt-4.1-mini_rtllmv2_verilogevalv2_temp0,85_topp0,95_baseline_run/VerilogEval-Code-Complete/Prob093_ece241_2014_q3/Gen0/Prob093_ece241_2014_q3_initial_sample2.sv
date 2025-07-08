module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  // 2:1 mux function implemented as ternary operator
  // mux(sel, in1, in0) = sel ? in1 : in0

  // mux_in[0] = c + d = mux(d,1,c)
  assign mux_in[0] = d ? 1'b1 : c;

  // mux_in[1] = 0 constant
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c + ~d = mux(d, c, 1)
  assign mux_in[2] = d ? c : 1'b1;

  // mux_in[3] = c & d = mux(c, d, 0)
  assign mux_in[3] = c ? d : 1'b0;

endmodule