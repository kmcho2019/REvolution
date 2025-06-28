module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

// Generate the outputs directly based on the simplified Boolean expression
assign mux_in[0] = d | (c & ~d);
assign mux_in[1] = c & ~d;
assign mux_in[2] = d | (c & d) | (~c & d);
assign mux_in[3] = ~c & d;

endmodule