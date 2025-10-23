module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 multiplexer for mux_in[0] = c'd'
assign mux_in[0] = ~c;

// Direct connection for mux_in[1] = d'
assign mux_in[1] = ~d;

// Direct connection for mux_in[2] = c
assign mux_in[2] = c;

// 2-to-1 multiplexer for mux_in[3] = c + d'
assign mux_in[3] = c | ~d;

endmodule