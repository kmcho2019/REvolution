module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is always 0
    assign mux_in[0] = 0;

    // For ab = 01, output is 0 when c = 0, and d when c = 1
    assign mux_in[1] = d;

    // For ab = 11, output is 1 when c = 1, and 0 when c = 0
    assign mux_in[2] = c;

    // For ab = 10, output is 1 when d = 1, and c when d = 0
    assign mux_in[3] = c;
endmodule