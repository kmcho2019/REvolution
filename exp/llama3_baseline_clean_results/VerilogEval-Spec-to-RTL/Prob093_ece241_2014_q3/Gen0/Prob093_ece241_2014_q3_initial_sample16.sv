module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// Create the first 2-to-1 multiplexer for the "00" and "01" inputs
assign mux_in[0] = (d) ? 1'b1 : c;
assign mux_in[1] = (d) ? 1'b0 : c;

// Create the second 2-to-1 multiplexer for the "11" and "10" inputs
assign mux_in[2] = (d) ? c : 1'b1;
assign mux_in[3] = (d) ? c : 1'b1;

endmodule