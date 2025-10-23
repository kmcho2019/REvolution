module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// create 2-to-1 multiplexers to generate inputs to 4-to-1 multiplexer
assign mux_in[0] = (c == 1) ? 1 : 0; // when ab=00
assign mux_in[1] = 0; // when ab=01
assign mux_in[2] = (c == 1) ? 1 : 0; // when ab=11, same as ab=00
assign mux_in[3] = (d == 1) ? c : 0; // when ab=10

endmodule