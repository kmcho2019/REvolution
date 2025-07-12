module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, output is 'd'
assign mux_in[0] = d;

// For ab = 01, output is 'c'
assign mux_in[1] = c;

// For ab = 11 and ab = 10, output is 'd'
assign mux_in[2] = d;
assign mux_in[3] = d;

endmodule