module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00: 0
assign mux_in[0] = 0;

// For ab = 01: 0
assign mux_in[1] = 0;

// For ab = 11: c
assign mux_in[2] = c;

// For ab = 10: d
assign mux_in[3] = d;

endmodule