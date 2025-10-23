module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 multiplexers to generate inputs for the 4-to-1 multiplexer
// Since we directly use 'c' and 'd', we don't need to implement 2-to-1 multiplexers
// We directly assign 'c' and 'd' to the respective inputs of the 4-to-1 multiplexer
assign mux_in[0] = d;
assign mux_in[1] = c;
assign mux_in[2] = d;
assign mux_in[3] = d;

endmodule