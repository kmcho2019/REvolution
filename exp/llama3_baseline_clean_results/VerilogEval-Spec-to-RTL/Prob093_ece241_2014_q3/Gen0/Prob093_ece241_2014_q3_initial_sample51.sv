module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, output is dependent on c
assign mux_in[0] = c;

// For ab = 01, output is always 0, except for cd = 01
assign mux_in[1] = c && d;

// For ab = 11, output is dependent on c
assign mux_in[2] = c;

// For ab = 10, output is 1 when c = 1 (regardless of d)
assign mux_in[3] = c;

endmodule