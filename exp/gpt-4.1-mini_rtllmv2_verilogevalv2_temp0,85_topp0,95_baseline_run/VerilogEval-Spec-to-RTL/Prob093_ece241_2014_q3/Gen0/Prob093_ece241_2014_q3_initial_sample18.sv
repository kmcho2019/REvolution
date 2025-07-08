module mux2to1(input sel, input in0, input in1, output out);
  assign out = sel ? in1 : in0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
  wire not_d;

  // ~d = mux(d,0,1)
  mux2to1 notd_mux(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

  // mux_in[0] = MUX(c, d, 1)
  mux2to1 mux0(.sel(c), .in0(d), .in1(1'b1), .out(mux_in[0]));

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = MUX(c, 0, d)
  mux2to1 mux2(.sel(c), .in0(1'b0), .in1(d), .out(mux_in[2]));

  // mux_in[3] = MUX(c, ~d, 1)
  mux2to1 mux3(.sel(c), .in0(not_d), .in1(1'b1), .out(mux_in[3]));
endmodule