module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  // mux_in[0] = c ? 1 : d
  assign mux_in[0] = c ? 1'b1 : d;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c ? d : 0
  assign mux_in[2] = c ? d : 1'b0;

  // For mux_in[3] = c ? 1 : ~d
  // Implement ~d using a 2-to-1 mux: ~d = d ? 0 : 1
  wire not_d;
  assign not_d = d ? 1'b0 : 1'b1;
  assign mux_in[3] = c ? 1'b1 : not_d;
endmodule