module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output depends on cd
    assign mux_in[0] = (c && d)? 1 : 0;

    // For ab = 01, output is always 0
    assign mux_in[1] = 0;

    // For ab = 11, output depends on cd
    assign mux_in[2] = (c && d)? 1 : 0;

    // For ab = 10, reuse the same logic as ab = 00
    assign mux_in[3] = (c && d)? 1 : 0;
endmodule