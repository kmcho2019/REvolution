module mux2 (
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

  wire temp0, temp2;

  // mux_in[0] = c ? 1 : (d ? 1 : 0)
  mux2 mux0_0 (.sel(d), .in0(1'b0), .in1(1'b1), .out(temp0));
  mux2 mux0_1 (.sel(c), .in0(temp0), .in1(1'b1), .out(mux_in[0]));

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c ? d : 0
  mux2 mux2_0 (.sel(c), .in0(1'b0), .in1(d), .out(mux_in[2]));

  // mux_in[3] = c ? 1 : (d ? 0 : 1)
  mux2 mux3_0 (.sel(d), .in0(1'b1), .in1(1'b0), .out(temp2));
  mux2 mux3_1 (.sel(c), .in0(temp2), .in1(1'b1), .out(mux_in[3]));

endmodule