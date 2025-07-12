module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Generate the inputs to the 4-to-1 multiplexer
assign mux_in[0] = d;  // for ab = 00
assign mux_in[1] = ~d; // for ab = 01
assign mux_in[2] = c;  // for ab = 11
assign mux_in[3] = c;  // for ab = 10

endmodule