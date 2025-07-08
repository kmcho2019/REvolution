module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  wire not_d;
  wire c_and_d;
  wire mux_in2;

  // Implement NOT d using 2-to-1 mux: d=0 -> 1, d=1 -> 0
  // 2-to-1 mux with select d, inputs = 1 (sel=0), 0 (sel=1)
  assign not_d = d ? 1'b0 : 1'b1;

  // Implement c & d as mux: c=0->0, c=1->d
  // 2-to-1 mux with select c, inputs=0(sel=0), d(sel=1)
  assign c_and_d = c ? d : 1'b0;

  // Implement mux_in[2] = c ? 1 : ~d
  // 2-to-1 mux with select c, inputs = ~d (sel=0), 1 (sel=1)
  assign mux_in2 = c ? 1'b1 : not_d;

  assign mux_in[0] = d;       // ab=00 input to 4-to-1 mux
  assign mux_in[1] = 1'b0;    // ab=01 input is zero
  assign mux_in[3] = c_and_d; // ab=11 input
  assign mux_in[2] = mux_in2; // ab=10 input

endmodule