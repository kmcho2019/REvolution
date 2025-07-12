module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = 0; // ab = 00
    assign mux_in[1] = 0; // ab = 01
    assign mux_in[2] = c; // ab = 11
    assign mux_in[3] = c; // ab = 10

endmodule