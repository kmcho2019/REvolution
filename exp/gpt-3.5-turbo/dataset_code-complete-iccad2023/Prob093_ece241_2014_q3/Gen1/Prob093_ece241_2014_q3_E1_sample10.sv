module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  
  wire ab, d_sel;
  
  assign ab = ~(c & ~d);
  assign d_sel = c;
  
  // 2-to-1 multiplexer for d
  assign mux_in[0] = d_sel ? d : c;
  assign mux_in[1] = d_sel ? c : d;
  
  // 4-to-1 multiplexer
  assign mux_in[2] = c;
  assign mux_in[3] = d;

endmodule