module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexer for ab = 00 and ab = 10
    assign mux_in[0] = (c)? c : d;
    assign mux_in[3] = (c)? c : d;

    // 2-to-1 multiplexer for ab = 01 and ab = 11
    assign mux_in[1] = (c)? c : 1'b0;
    assign mux_in[2] = (c)? c : d;

endmodule