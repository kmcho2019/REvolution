module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  wire not_d;
  wire or_cd;
  wire and_cd;
  wire or_c_notd;

  // NOT d = mux(d,1,0)
  // Implemented as: if d=0 => output=1, if d=1 => output=0
  // mux input0 = 1, input1=0, select = d
  assign not_d = d ? 1'b0 : 1'b1;

  // OR(c,d) = mux(c,1,d)
  // if c=0 -> output=d, if c=1 -> output=1
  assign or_cd = c ? 1'b1 : d;

  // AND(c,d) = mux(c,0,d)
  // if c=0 -> output=0, if c=1 -> output=d
  assign and_cd = c ? d : 1'b0;

  // OR(c, not_d) = mux(c,1,not_d)
  // if c=0 -> output=not_d, if c=1 -> output=1
  assign or_c_notd = c ? 1'b1 : not_d;

  // mux_in[0] = c | d
  assign mux_in[0] = or_cd;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c & d
  assign mux_in[2] = and_cd;

  // mux_in[3] = c | (~d)
  assign mux_in[3] = or_c_notd;

endmodule