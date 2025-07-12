module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output depends on cd
    assign mux_in[0] = (d)? c : 0;

    // For ab = 01, output is always 0
    assign mux_in[1] = 0;

    // For ab = 11 and ab = 10, output depends on cd, using d as selector
    assign mux_in[2] = (d)? c : 0;
    assign mux_in[3] = (d)? c : 0;
endmodule