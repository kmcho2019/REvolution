module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  // mux_in[0] = c + d implemented as mux: if c=1 output 1 else d
  wire mux_in0;
  assign mux_in0 = c ? 1'b1 : d;

  // mux_in[1] = 0
  wire mux_in1 = 1'b0;

  // mux_in[2] = c & d implemented as mux: if c=1 output d else 0
  wire mux_in2;
  assign mux_in2 = c ? d : 1'b0;

  // mux_in[3] = c + (~c & ~d)
  // if c=1 output 1 else ~d
  wire not_d;
  assign not_d = d ? 1'b0 : 1'b1;
  wire mux_in3 = c ? 1'b1 : not_d;

  assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};
endmodule