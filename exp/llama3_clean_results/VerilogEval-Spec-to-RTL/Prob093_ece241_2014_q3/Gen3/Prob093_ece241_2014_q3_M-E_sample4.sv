module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d? ~c : 0; // For ab = 00, output is 1 when cd = 10
    assign mux_in[1] = 0; // For ab = 01, output is always 0
    assign mux_in[2] = c? 1 : d; // For ab = 11, output is 1 when cd is not 00
    assign mux_in[3] = c; // For ab = 10, output is 1 when c is 1

endmodule