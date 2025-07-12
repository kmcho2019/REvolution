module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    assign mux_in[0] = 0; // when ab = 00
    assign mux_in[1] = 0; // when ab = 01
    assign mux_in[2] = d ? 1 : c; // when ab = 11
    assign mux_in[3] = c; // when ab = 10

endmodule