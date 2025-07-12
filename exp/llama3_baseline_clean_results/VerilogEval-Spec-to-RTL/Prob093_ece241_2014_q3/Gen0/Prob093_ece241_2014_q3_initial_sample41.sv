module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

assign mux_in[0] = 1'b0;  // ab = 00
assign mux_in[1] = 1'b0;  // ab = 01
assign mux_in[2] = (d) ? 1'b1 : c;  // ab = 11
assign mux_in[3] = (d) ? c : 1'b0;  // ab = 10

endmodule