module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Using two 2-to-1 multiplexers to generate the required inputs
  assign mux_in[0] = 1'b0;  // For (a,b) = (00)
  assign mux_in[1] = 1'b0;  // For (a,b) = (01)
  assign mux_in[2] = d;    // For (a,b) = (11)
  assign mux_in[3] = c;    // For (a,b) = (10)
endmodule