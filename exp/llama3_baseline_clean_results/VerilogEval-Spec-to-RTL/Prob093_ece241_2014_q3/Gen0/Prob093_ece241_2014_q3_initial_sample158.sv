module TopModule(
  input c,
  input d,
  output [3:0] mux_in
);

// For ab = 00, the output should be 0 (from the K-map)
assign mux_in[0] = 1'b0;

// For ab = 01, the output should be 0 (from the K-map)
assign mux_in[1] = 1'b0;

// For ab = 11, the output should be 1 when c is 1 and d is 1 (from the K-map)
assign mux_in[2] = c & d;

// For ab = 10, the output should be 1 when c is 1 (from the K-map)
assign mux_in[3] = c;

endmodule