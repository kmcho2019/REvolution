module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  
  // 2-to-1 multiplexer for input c
  assign mux_in[0] = (a & ~b) ? 1'b1 : c;
  assign mux_in[1] = (a & b) ? 1'b1 : c;
  
  // 2-to-1 multiplexer for input d
  assign mux_in[2] = (~a & b) ? 1'b1 : d;
  assign mux_in[3] = (a | b) ? 1'b1 : d;

endmodule