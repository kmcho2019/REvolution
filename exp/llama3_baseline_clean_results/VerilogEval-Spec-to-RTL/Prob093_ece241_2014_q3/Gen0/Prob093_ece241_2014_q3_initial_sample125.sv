module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexer for ab = 00
    assign mux_in[0] = 0;

    // 2-to-1 multiplexer for ab = 01
    assign mux_in[1] = 0;

    // 2-to-1 multiplexer for ab = 11
    assign mux_in[2] = d ? 1 : 0;

    // 2-to-1 multiplexer for ab = 10
    assign mux_in[3] = c ? 1 : 0;
endmodule