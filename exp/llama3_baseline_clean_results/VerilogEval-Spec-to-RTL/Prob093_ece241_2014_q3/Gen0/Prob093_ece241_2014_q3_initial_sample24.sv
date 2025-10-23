module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d;  // ab = 00
    assign mux_in[1] = c;  // ab = 01
    assign mux_in[2] = (c) ? d : d;  // ab = 11, using a 2-to-1 multiplexer
    assign mux_in[3] = d;  // ab = 10

endmodule