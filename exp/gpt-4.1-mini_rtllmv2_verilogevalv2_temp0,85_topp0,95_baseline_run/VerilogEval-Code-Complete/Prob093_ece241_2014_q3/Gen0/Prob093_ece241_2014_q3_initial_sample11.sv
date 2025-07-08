module mux2to1 (
  input sel,
  input d0,
  input d1,
  output y
);
  assign y = sel ? d1 : d0;
endmodule

module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  wire d_not;

  // Implement NOT d using mux2to1: d ? 0 : 1
  mux2to1 not_d_mux(.sel(d), .d0(1'b1), .d1(1'b0), .y(d_not));

  // mux_in[0]: if c=0 output d else 1
  // mux2to1 with c selector: d0=d, d1=1
  mux2to1 mux_in0_mux(.sel(c), .d0(d), .d1(1'b1), .y(mux_in[0]));

  // mux_in[1] = 0 (all zeros)
  assign mux_in[1] = 1'b0;

  // mux_in[2]: if c=0 output 0 else d
  // mux2to1 with c selector: d0=0, d1=d
  mux2to1 mux_in2_mux(.sel(c), .d0(1'b0), .d1(d), .y(mux_in[2]));

  // mux_in[3]: if c=0 output ~d else 1
  // ~d is d_not from above
  mux2to1 mux_in3_mux(.sel(c), .d0(d_not), .d1(1'b1), .y(mux_in[3]));

endmodule