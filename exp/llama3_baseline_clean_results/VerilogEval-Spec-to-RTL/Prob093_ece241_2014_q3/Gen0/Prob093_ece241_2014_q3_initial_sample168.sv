module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // Generate the minterms for each output of the 4-to-1 multiplexer
  // For ab = 00, the output is always 0
  assign mux_in[0] = 0;

  // For ab = 01, the output is 0 for all inputs cd except when c = 1 and d = 1
  assign mux_in[1] = c & d;

  // For ab = 10 and ab = 11, the outputs depend on the values of c and d
  // We can use 2-to-1 multiplexers to select the correct minterm
  // For ab = 10, we need to select between c and 1 (when d = 1)
  assign mux_in[2] = d ? 1 : c;

  // For ab = 11, we need to select between c and d
  assign mux_in[3] = d ? 1 : c;
endmodule