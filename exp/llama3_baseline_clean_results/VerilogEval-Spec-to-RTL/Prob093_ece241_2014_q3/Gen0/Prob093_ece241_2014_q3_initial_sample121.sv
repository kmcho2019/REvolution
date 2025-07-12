module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = 0; // for ab = 00
    assign mux_in[1] = 0; // for ab = 01
    assign mux_in[2] = (d == 1)? 1 : c; // for ab = 11
    assign mux_in[3] = (d == 1)? 1 : c; // for ab = 10

endmodule