module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// For ab = 00, select between 0 and 1 based on d
assign mux_in[0] = d;

// For ab = 01, output is always 0
assign mux_in[1] = 1'b0;

// For ab = 11, select between 0 and 1 based on c
assign mux_in[2] = c;

// For ab = 10, output is always 1
assign mux_in[3] = 1'b1;

endmodule