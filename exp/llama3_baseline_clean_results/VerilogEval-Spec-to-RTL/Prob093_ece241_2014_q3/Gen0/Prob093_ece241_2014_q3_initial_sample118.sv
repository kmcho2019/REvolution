module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 'ab = 00' input
assign mux_in[0] = d;

// 'ab = 01' input
assign mux_in[1] = c;

// 'ab = 10' input
assign mux_in[2] = d;

// 'ab = 11' input, use a 2-to-1 multiplexer
assign mux_in[3] = (c)? d : c;

endmodule