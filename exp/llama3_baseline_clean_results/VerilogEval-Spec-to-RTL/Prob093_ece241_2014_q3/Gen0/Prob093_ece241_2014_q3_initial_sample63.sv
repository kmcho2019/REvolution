module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Direct assignments for ab = 00 and ab = 10
assign mux_in[0] = ~c & ~d;
assign mux_in[3] = d;

// For ab = 01, the output is always 0
assign mux_in[1] = 1'b0;

// For ab = 11, use a 2-to-1 multiplexer
assign mux_in[2] = (d) ? d : c;

endmodule