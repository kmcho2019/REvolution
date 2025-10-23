module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // For ab = 00, output is 0 for cd = 00 and 1 for cd = 10, 11
    assign mux_in[0] = (c && d) || (!c && d);

    // For ab = 01, output is 1 for cd = 01
    assign mux_in[1] = c && !d;

    // For ab = 11, output is 0 for cd = 00, 01 and 1 for cd = 10, 11
    assign mux_in[2] = (!c && d) || (c && d);

    // For ab = 10, output is 1 for cd = 01, 10, 11
    assign mux_in[3] = (!c && d) || c;

endmodule