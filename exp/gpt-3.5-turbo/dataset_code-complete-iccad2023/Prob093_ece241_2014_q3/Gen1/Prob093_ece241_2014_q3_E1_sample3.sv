module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  
  // Directly map Karnaugh map outputs to 4-to-1 MUX inputs based on 'a' and 'b' inputs
  assign mux_in[0] = d;
  assign mux_in[1] = c & ~d;
  assign mux_in[2] = c | d;
  assign mux_in[3] = c;
  
endmodule