module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d &&!c; // For ab = 00, correct implementation
    assign mux_in[1] = (c && d); // Corrected for ab = 01, should be 1 when cd = 11
    assign mux_in[2] = d; // For ab = 11, output is d
    assign mux_in[3] = d &&!c; // For ab = 10, same as ab = 00
endmodule