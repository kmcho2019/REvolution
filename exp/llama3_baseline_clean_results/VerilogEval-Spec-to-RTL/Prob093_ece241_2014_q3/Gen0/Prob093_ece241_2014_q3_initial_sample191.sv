module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = ~c; // ab = 00
    assign mux_in[1] = ~d; // ab = 01
    assign mux_in[2] = c & ~d; // ab = 11
    assign mux_in[3] = ~d; // ab = 10, using ~d since cd=00 and cd=11 have the same output for ab=10

endmodule