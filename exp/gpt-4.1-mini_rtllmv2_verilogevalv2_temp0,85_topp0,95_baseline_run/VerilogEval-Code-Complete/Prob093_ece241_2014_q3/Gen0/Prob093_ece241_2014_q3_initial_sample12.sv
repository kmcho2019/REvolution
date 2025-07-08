module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire not_d;

  // Implement ~d using a 2-to-1 mux: select=d, in0=1, in1=0
  assign not_d = d ? 1'b0 : 1'b1;

  // mux_in[0] = c ? 1 : d
  wire mux_in0_lower;
  assign mux_in0_lower = d;            // when c=0
  assign mux_in[0] = c ? 1'b1 : mux_in0_lower;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c ? 1 : ~d
  assign mux_in[2] = c ? 1'b1 : not_d;

  // mux_in[3] = c ? d : 0
  assign mux_in[3] = c ? d : 1'b0;

endmodule