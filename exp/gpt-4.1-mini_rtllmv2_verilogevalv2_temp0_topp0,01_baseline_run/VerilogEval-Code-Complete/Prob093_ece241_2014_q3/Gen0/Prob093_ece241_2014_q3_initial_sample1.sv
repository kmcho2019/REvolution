module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  // mux_in[0] for ab=00: cd=00->0,01->1,11->1,10->1
  // For c=0: mux_in[0] = d
  // For c=1: mux_in[0] = 1
  assign mux_in[0] = c ? 1'b1 : d;

  // mux_in[1] for ab=01: all zeros
  assign mux_in[1] = 1'b0;

  // mux_in[2] for ab=11: cd=00->0,01->0,11->1,10->0
  // For c=0: mux_in[2] = 0
  // For c=1: mux_in[2] = d
  assign mux_in[2] = c ? d : 1'b0;

  // mux_in[3] for ab=10: cd=00->1,01->0,11->1,10->1
  // For c=0: mux_in[3] = ~d
  // For c=1: mux_in[3] = 1
  assign mux_in[3] = c ? 1'b1 : ~d;

endmodule