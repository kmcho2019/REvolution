module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // 2-to-1 multiplexer for the first column (ab = 00, 01)
  assign mux_in[0] = c ? d : 0;
  assign mux_in[1] = c ? d : 0;

  // 2-to-1 multiplexer for the third column (ab = 11)
  assign mux_in[2] = d ? c : c;

  // 2-to-1 multiplexer for the fourth column (ab = 10)
  assign mux_in[3] = d ? c : c;
endmodule