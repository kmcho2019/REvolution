module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;
  
  // Generate the input for the '00' column
  // Since both 'c' and 'd' are '0', the output is 'c' (which is '0')
  assign mux_in[0] = 1'b0;
  
  // Generate the input for the '01' column
  // Since 'c' is '0' and 'd' is '1', the output is '0'
  assign mux_in[1] = 1'b0;
  
  // Generate the input for the '11' column
  // Since both 'c' and 'd' are '1', the output is 'c' (which is '1')
  assign mux_in[2] = c;
  
  // Generate the input for the '10' column
  // Since 'c' is '1' and 'd' is '0', the output is 'c' (which is '1')
  assign mux_in[3] = c;
endmodule