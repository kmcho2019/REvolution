module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  // The 2-to-1 multiplexers are used to generate the inputs for the 4-to-1 multiplexer
  // The first 2-to-1 multiplexer selects between '0' and 'd' based on 'c'
  // The second 2-to-1 multiplexer selects between 'c' and 'd' based on 'c'

  assign mux_in[0] = 1'b0;
  assign mux_in[1] = 1'b0;
  assign mux_in[2] = c;
  assign mux_in[3] = d;

endmodule