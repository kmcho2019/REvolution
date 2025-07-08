module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  
  // mux_in[0] = c OR d
  assign mux_in[0] = c | d;
  
  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;
  
  // mux_in[2] = c OR ~d
  assign mux_in[2] = c | ~d;
  
  // mux_in[3] = c AND d
  assign mux_in[3] = c & d;
  
endmodule