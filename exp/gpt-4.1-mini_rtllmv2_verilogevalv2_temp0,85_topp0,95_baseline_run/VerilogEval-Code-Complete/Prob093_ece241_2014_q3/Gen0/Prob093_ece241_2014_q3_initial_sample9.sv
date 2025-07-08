module mux2 (
  input s,
  input d0,
  input d1,
  output y
);
  assign y = s ? d1 : d0;
endmodule

module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  wire not_d;

  // ~d implemented as mux2 with s=d, d0=1, d1=0
  mux2 not_d_inst (
    .s(d),
    .d0(1'b1),
    .d1(1'b0),
    .y(not_d)
  );

  // mux_in[0] = c ? 1 : d
  mux2 mux_in0_inst (
    .s(c),
    .d0(d),
    .d1(1'b1),
    .y(mux_in[0])
  );

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c ? 1 : ~d
  mux2 mux_in2_inst (
    .s(c),
    .d0(not_d),
    .d1(1'b1),
    .y(mux_in[2])
  );

  // mux_in[3] = c ? d : 0
  mux2 mux_in3_inst (
    .s(c),
    .d0(1'b0),
    .d1(d),
    .y(mux_in[3])
  );
endmodule