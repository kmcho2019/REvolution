module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexer for mux_in[0]
    assign mux_in[0] = (d) ? 1 : 0;

    // mux_in[1] is always 0
    assign mux_in[1] = 0;

    // 2-to-1 multiplexer for mux_in[2]
    assign mux_in[2] = (d) ? 0 : 1;

    // mux_in[3] is always 1
    assign mux_in[3] = 1;
endmodule