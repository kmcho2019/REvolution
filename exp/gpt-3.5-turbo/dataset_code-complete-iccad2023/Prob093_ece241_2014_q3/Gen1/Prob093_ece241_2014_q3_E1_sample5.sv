module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire ab0, ab1;
  
  assign ab0 = ~c & d;
  assign ab1 = c | d;
  
  // 2-to-1 multiplexer for combining c and d
  assign mux_in[0] = ab0 ? 1'b1 : 1'b0;
  assign mux_in[1] = ab0 ? d : 1'b0;
  
  // 4-to-1 multiplexer for selecting between c, d, and combined c/d
  assign mux_in[2] = ab1 ? (c & d) : 1'b0;
  assign mux_in[3] = ab1 ? (c | d) : 1'b0;
endmodule