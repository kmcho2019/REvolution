module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  // mux_in[0]: if cd==00 output=0 else 1
  // mux with d select: d=0 -> mux(c,1,0), d=1 -> 1
  wire mux0_d0;
  assign mux0_d0 = d ? 1'b1 : (c ? 1'b1 : 1'b0); // same as mux(d,1,mux(c,1,0))
  // But to only use 2-to-1 muxes:
  // implement as mux_d0 = mux(c,1,0);
  wire mux0_c_sel = c;
  wire mux0_d_sel = d;
  // mux0 = mux(d, 1, mux(c,1,0))
  // mux(c,1,0) = c?1:0
  // mux(d,1,(c?1:0)) = d?1:(c?1:0)

  // Implement mux_in[0]
  assign mux_in[0] = d ? 1'b1 : (c ? 1'b1 : 1'b0);

  // mux_in[1]: always 0
  assign mux_in[1] = 1'b0;

  // mux_in[2]: only cd=11=1 else 0
  // mux(d, mux(c,1,0), 0)
  wire mux2_c_out;
  assign mux2_c_out = c ? 1'b1 : 1'b0;
  assign mux_in[2] = d ? mux2_c_out : 1'b0;

  // mux_in[3]: d=0 output 1, d=1 output c
  // mux(d, c, 1)
  assign mux_in[3] = d ? c : 1'b1;

endmodule