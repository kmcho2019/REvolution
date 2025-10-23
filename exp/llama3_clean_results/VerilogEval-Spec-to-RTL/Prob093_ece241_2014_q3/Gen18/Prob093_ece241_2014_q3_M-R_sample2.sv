module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is always 0
    assign mux_in[0] = 0;

    // For ab = 01, output is always 0
    assign mux_in[1] = 0;

    // For ab = 11, output is 'd' when c=1, otherwise 0
    assign mux_in[2] = c ? d : 0;

    // For ab = 10, output is 1 when c=1, otherwise 0
    assign mux_in[3] = c ? 1 : d;

    // But as per the K-map for ab = 10, output is 1 when c = 1 and d = 0 or 1 
    // So this can be further simplified as:
    // assign mux_in[3] = c ? 1 : 0;

endmodule