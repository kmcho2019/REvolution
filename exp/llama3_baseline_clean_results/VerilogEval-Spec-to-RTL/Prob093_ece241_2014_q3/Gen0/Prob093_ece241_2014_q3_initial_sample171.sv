module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Generate the inputs for the 4-to-1 multiplexer
assign mux_in[0] = 1'b0;  // ab = 00
assign mux_in[1] = 1'b0;  // ab = 01
assign mux_in[2] = c;    // ab = 11
assign mux_in[3] = c | d;  // ab = 10

endmodule