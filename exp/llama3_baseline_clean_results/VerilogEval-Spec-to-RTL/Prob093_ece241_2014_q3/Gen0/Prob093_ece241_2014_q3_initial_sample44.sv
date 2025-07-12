module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing the logic based on the K-map analysis
    // For ab = 00, output = cd[01] = d (since c must be 0 for this condition)
    assign mux_in[0] = d;

    // For ab = 01, output is always 0
    assign mux_in[1] = 0;

    // For ab = 11, output = d
    assign mux_in[2] = d;

    // For ab = 10, output = c
    assign mux_in[3] = c;
endmodule