module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  wire not_c, not_d;

  // Implement not_c = ~c using 2-to-1 mux: select c, inputs 1 and 0
  // If c=0 select 1, c=1 select 0 -> output ~c
  // 2-to-1 mux: out = c ? in1 : in0
  // So out = c ? 0 : 1
  assign not_c = c ? 1'b0 : 1'b1;

  // Implement not_d = ~d similarly
  assign not_d = d ? 1'b0 : 1'b1;

  // mux_in[0] = c + (~c & d) = (c) OR ((~c) AND d)
  // = if c=1 => 1
  // else if c=0 => d
  // This is a mux with c as select: if c=1 output 1, else output d
  assign mux_in[0] = c ? 1'b1 : d;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c & d
  // Implement c & d using 2-to-1 mux:
  // c & d = d if c=1, else 0
  // So mux select c, inputs 0 and d
  assign mux_in[2] = c ? d : 1'b0;

  // mux_in[3] = c + ~d
  // = if c=1 =>1 else output ~d
  // mux select c, inputs ~d and 1
  // careful: c=0 output ~d, c=1 output 1
  // So mux select c, inputs: 0->~d, 1->1
  assign mux_in[3] = c ? 1'b1 : not_d;

endmodule