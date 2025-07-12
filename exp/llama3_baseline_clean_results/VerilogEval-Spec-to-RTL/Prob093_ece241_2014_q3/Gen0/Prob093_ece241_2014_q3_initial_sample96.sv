module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 multiplexer for 00 and 01 cases
assign mux_in[0] = 1'b0;
assign mux_in[1] = 1'b0;

// 2-to-1 multiplexer for 10 and 11 cases
assign mux_in[2] = 1'b1;
assign mux_in[3] = (c == 1'b1) ? 1'b1 : 1'b0;

// Alternatively, the above line can also be written as:
// assign mux_in[3] = c;

endmodule