module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00
    mux_in[0] = d;

    // For ab = 01
    mux_in[1] = 1'b0;

    // For ab = 11
    mux_in[2] = c;

    // For ab = 10
    mux_in[3] = c;
endmodule