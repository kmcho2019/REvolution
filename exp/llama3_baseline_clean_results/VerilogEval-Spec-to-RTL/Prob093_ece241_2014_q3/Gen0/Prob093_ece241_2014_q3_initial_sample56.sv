module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, output is 0 when cd = 00, and 1 otherwise
assign mux_in[0] = ~(c & d);

// For ab = 01, output is always 0
assign mux_in[1] = 1'b0;

// For ab = 11, output is 1 when d = 1, and 0 otherwise
assign mux_in[2] = d;

// For ab = 10, output is 1 when c = 1, and 0 when c = 0 and d = 0
assign mux_in[3] = c | d;

endmodule