module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// mux_in[0] (ab = 00): 1 when either 'c' or 'd' (or both) is 1
assign mux_in[0] = c | d;

// mux_in[1] (ab = 01): 0 for all combinations of 'c' and 'd'
assign mux_in[1] = 0;

// mux_in[2] (ab = 11): 1 when both 'c' and 'd' are 1
assign mux_in[2] = c & d;

// mux_in[3] (ab = 10): 1 when 'c' and 'd' are both 0 or both 1
assign mux_in[3] = ~(c ^ d);

endmodule