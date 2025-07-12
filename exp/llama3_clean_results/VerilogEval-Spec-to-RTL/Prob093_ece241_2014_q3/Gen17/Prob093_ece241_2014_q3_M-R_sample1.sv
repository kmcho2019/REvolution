module TopModule(c, d, a, b, mux_in);
    input c, d, a, b;
    output [3:0] mux_in;

    // For ab = 00, output is 'd'
    assign mux_in[0] = d;

    // For ab = 01, output is '1' when c is '1'
    assign mux_in[1] = c;

    // For ab = 11 and ab = 10, output depends on c and d
    assign mux_in[2] = (c) ? 1'b1 : d;
    assign mux_in[3] = (c) ? 1'b1 : d;

endmodule