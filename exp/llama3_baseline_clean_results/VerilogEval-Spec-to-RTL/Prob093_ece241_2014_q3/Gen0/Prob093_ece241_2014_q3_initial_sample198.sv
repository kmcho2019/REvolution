module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Generate input for ab = 00
assign mux_in[0] = (c == 0) ? 1'b0 : 1'b1;

// Generate input for ab = 01
assign mux_in[1] = 1'b0;

// Generate input for ab = 11
assign mux_in[2] = (d == 0) ? 1'b1 : 1'b1;

// Generate input for ab = 10
assign mux_in[3] = (c == 0) ? 1'b1 : 1'b1;

endmodule