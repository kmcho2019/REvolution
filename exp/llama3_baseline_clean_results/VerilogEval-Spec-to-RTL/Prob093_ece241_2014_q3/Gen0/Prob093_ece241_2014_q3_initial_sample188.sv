module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 0
    assign mux_in[0] = 0;

    // For ab = 01, output is 0
    assign mux_in[1] = 0;

    // For ab = 11, output is c
    assign mux_in[2] = c;

    // For ab = 10, output is d
    assign mux_in[3] = d;
endmodule