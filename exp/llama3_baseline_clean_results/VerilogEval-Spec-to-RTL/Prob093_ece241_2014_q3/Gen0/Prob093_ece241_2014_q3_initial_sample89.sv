module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

assign mux_in[0] = (d == 1) ? c : 0;  // ab = 00
assign mux_in[1] = (c == 1) ? d : 0;  // ab = 01
assign mux_in[2] = (d == 1) ? 1 : c;  // ab = 11
assign mux_in[3] = (c == 1) ? d : 1;  // ab = 10

endmodule