module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Minterm 0 (ab = 00) output is always 0
assign mux_in[0] = 1'b0;

// Minterm 1 (ab = 01) output is always 0
assign mux_in[1] = 1'b0;

// Minterm 2 (ab = 10) output depends on cd
// Use a 2-to-1 multiplexer to select between d (cd = 10) and c (cd = 00 or 01)
assign mux_in[2] = (c) ? d : 1'b1;

// Minterm 3 (ab = 11) output depends on cd
// Use a 2-to-1 multiplexer to select between d (cd = 11) and c (cd = 01)
assign mux_in[3] = (d) ? d : 1'b1;

endmodule