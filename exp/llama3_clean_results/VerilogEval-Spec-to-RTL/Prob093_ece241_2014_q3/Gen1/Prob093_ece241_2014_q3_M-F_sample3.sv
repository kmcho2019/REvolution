module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~d;  // ab = 00, output is d'
    assign mux_in[1] = (c) ? 1'b0 : d;  // ab = 01, output is d + c'
    assign mux_in[2] = ~d;  // ab = 11, output is d'
    assign mux_in[3] = (c) ? d : 1'b1;  // ab = 10, output is d + c

endmodule