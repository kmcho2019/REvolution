module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Implementing the expressions for each mux_in bit
assign mux_in[0] = c | d;  // c OR d
assign mux_in[1] = 1'b0;   // Constant 0
assign mux_in[2] = c & d;  // c AND d
assign mux_in[3] = d;      // d

endmodule