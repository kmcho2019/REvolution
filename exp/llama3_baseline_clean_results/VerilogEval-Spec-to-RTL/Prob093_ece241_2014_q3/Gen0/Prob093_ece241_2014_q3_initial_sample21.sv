module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00
    assign mux_in[0] = c ? 1 : 0;

    // For ab = 01
    assign mux_in[1] = 0;

    // For ab = 11
    assign mux_in[2] = d ? 1 : 0;

    // For ab = 10
    assign mux_in[3] = d ? 1 : 0;
endmodule