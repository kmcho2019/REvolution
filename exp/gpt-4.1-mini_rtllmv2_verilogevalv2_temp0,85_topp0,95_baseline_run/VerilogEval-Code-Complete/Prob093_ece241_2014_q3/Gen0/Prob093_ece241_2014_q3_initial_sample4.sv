module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  // We assume availability of constants 0 and 1 as wires
  wire zero = 1'b0;
  wire one = 1'b1;

  // Implement mux_in[0] = c OR d = mux(c, d, 1)
  // 2-to-1 mux: output = s ? i1 : i0
  // Here s=c, i0=d, i1=1
  wire mux0_tmp;
  assign mux0_tmp = c ? one : d;
  assign mux_in[0] = mux0_tmp;

  // mux_in[1] = 0
  assign mux_in[1] = zero;

  // mux_in[2] = NOT d = mux(d, 0, 1)
  wire mux2_tmp;
  assign mux2_tmp = d ? zero : one;
  assign mux_in[2] = mux2_tmp;

  // mux_in[3] = c AND d = mux(c, 0, d)
  wire mux3_tmp;
  assign mux3_tmp = c ? d : zero;
  assign mux_in[3] = mux3_tmp;

endmodule