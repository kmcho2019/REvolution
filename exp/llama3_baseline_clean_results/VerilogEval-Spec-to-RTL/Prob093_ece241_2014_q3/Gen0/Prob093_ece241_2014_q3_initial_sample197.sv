module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, output is 0 for all cd except 10, where it's 1
assign mux_in[0] = ~(c) & d;

// For ab = 01, output is 0 for all cd
assign mux_in[1] = 1'b0;

// For ab = 11, output depends on cd
assign mux_in[2] = c;

// For ab = 10, output depends on cd
assign mux_in[3] = c | d;

endmodule