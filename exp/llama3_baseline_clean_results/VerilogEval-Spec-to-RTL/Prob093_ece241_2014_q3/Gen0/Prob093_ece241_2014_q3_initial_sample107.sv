module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;
  
  assign mux_in[0] = d;
  assign mux_in[1] = 1'b0;
  assign mux_in[2] = d;
  assign mux_in[3] = c;
  
endmodule