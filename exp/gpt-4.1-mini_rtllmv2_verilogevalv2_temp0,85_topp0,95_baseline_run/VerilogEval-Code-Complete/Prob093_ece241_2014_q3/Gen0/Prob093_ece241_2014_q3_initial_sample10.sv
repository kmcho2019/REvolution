module mux2to1 (
  input sel,
  input in0,
  input in1,
  output out
);
  assign out = sel ? in1 : in0;
endmodule

module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire mux_in0_c_mux;
  wire mux_in2_c_mux;
  wire mux_in3_c_mux;

  // mux_in[0] = d ? 1 : c
  // Implement mux_in[0]_c_mux = MUX(c,0,1) = c
  // So mux_in[0] = MUX(d, c, 1)
  mux2to1 mux0_c (.sel(c), .in0(1'b0), .in1(1'b1), .out(mux_in0_c_mux));
  mux2to1 mux0_d (.sel(d), .in0(mux_in0_c_mux), .in1(1'b1), .out(mux_in[0]));

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = d ? c : 1
  // mux_in[2]_c_mux = MUX(c,0,1) = c
  mux2to1 mux2_c (.sel(c), .in0(1'b0), .in1(1'b1), .out(mux_in2_c_mux));
  mux2to1 mux2_d (.sel(d), .in0(1'b1), .in1(mux_in2_c_mux), .out(mux_in[2]));

  // mux_in[3] = d ? c : 0
  // mux_in[3]_c_mux = MUX(c,0,1) = c
  mux2to1 mux3_c (.sel(c), .in0(1'b0), .in1(1'b1), .out(mux_in3_c_mux));
  mux2to1 mux3_d (.sel(d), .in0(1'b0), .in1(mux_in3_c_mux), .out(mux_in[3]));

endmodule