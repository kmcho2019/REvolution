module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  
  wire ab0, ab1;
  
  assign ab0 = ~(c & ~d);
  assign ab1 = c;
  
  // 2-to-1 multiplexer for d
  assign mux_in[0] = ab0 ? 1'b1 : 1'b0;
  assign mux_in[1] = ab0 ? d : 1'b0;

  // 2-to-1 multiplexer for c
  assign mux_in[2] = ab1 ? c : 1'b0;
  assign mux_in[3] = ab1 ? 1'b1 : 1'b0;

endmodule