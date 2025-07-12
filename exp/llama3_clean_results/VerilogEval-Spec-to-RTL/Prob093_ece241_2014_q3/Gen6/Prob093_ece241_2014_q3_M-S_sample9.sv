module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d &&!c; // For ab = 00
    assign mux_in[1] = c && d;   // For ab = 01, correcting the interpretation
    assign mux_in[2] = d;         // For ab = 11
    assign mux_in[3] = d &&!c;   // For ab = 10
endmodule