module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output should be 0
    assign mux_in[0] = 0;

    // For ab = 01, output should be 1 when c = 1
    assign mux_in[1] = c;

    // For ab = 11, output should be 1 when d = 1
    assign mux_in[2] = d;

    // For ab = 10, output should be 1 when c = 1 or d = 1
    assign mux_in[3] = c | d;
endmodule