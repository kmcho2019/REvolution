module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

// For ab = 00, output is 0
assign mux_in[0] = 1'b0;

// For ab = 01, output is 0
assign mux_in[1] = 1'b0;

// For ab = 11, output is d
assign mux_in[2] = d;

// For ab = 10, output is c
assign mux_in[3] = c;

endmodule