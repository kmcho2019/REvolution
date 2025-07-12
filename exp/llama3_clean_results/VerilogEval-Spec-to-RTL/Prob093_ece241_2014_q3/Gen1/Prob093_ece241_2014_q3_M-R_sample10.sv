module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // The K-map shows that for ab = 00 and ab = 01, the output is 0.
    assign mux_in[0] = 0;
    assign mux_in[1] = 0;

    // For ab = 11 and ab = 10, use 2-to-1 multiplexers to generate the output values.
    assign mux_in[3] = c;
    assign mux_in[2] = c;

endmodule