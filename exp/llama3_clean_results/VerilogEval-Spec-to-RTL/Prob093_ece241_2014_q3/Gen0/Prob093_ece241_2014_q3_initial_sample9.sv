module TopModule(c, d, mux_in);
  input c;
  input d;
  output [3:0] mux_in;

  assign mux_in[0] = 0;
  assign mux_in[1] = 0;
  assign mux_in[2] = (c == 1)? d : c;
  assign mux_in[3] = (d == 1)? c : 1;
endmodule