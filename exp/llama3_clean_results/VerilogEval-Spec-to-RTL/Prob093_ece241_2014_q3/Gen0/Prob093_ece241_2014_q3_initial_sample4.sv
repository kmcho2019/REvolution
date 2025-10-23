module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // The K-map shows that for ab = 00 and ab = 01, the output is 0.
    assign mux_in[0] = 0;
    assign mux_in[1] = 0;

    // For ab = 11, the output is 1.
    assign mux_in[3] = 1;

    // For ab = 10, the output is also 1.
    assign mux_in[2] = 1;

endmodule