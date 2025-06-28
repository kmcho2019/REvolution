module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

// Generate the outputs based on the K-map mapping directly to the 4-to-1 multiplexer inputs
assign mux_in[0] = (~c & ~d) | (c & d);
assign mux_in[1] = (c & ~d) | (c & d);
assign mux_in[2] = c & d;
assign mux_in[3] = (~c & d);

endmodule