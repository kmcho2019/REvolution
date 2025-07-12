module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For (a, b) = 00, use a 2-to-1 multiplexer
// if c is 0, output 0; if c is 1, output d
assign mux_in[0] = (c) ? d : 0;

// For (a, b) = 01, output 0
assign mux_in[1] = 0;

// For (a, b) = 11, use a 2-to-1 multiplexer
// if c is 0, output 0; if c is 1, output d
assign mux_in[2] = (c) ? d : 0;

// For (a, b) = 10, use a 2-to-1 multiplexer
// if c is 0, output d; if c is 1, output d
assign mux_in[3] = d;

endmodule