module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // ab = 00: always 0
    assign mux_in[0] = 0;

    // ab = 01: always 0
    assign mux_in[1] = 0;

    // ab = 11: select between 1 (c = 1 and d = 1) and 0 (otherwise)
    assign mux_in[2] = (c && d) ? 1 : 0;

    // ab = 10: select between 1 (c = 1) and 0 (c = 0)
    assign mux_in[3] = c ? 1 : 0;
endmodule