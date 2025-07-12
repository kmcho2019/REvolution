module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, the output is 0 when cd = 00, and 1 when cd = 01, 11, or 10.
    // This can be simplified as the output being 1 when c is high, and 0 when c is low and d is low.
    assign mux_in[0] = c | d;

    // For ab = 01, the output is always 0.
    assign mux_in[1] = 0;

    // For ab = 11, the output is 1 when cd = 11, and 0 otherwise.
    assign mux_in[2] = c & d;

    // For ab = 10, the output is 1 when cd = 10 or 11, which simplifies to c being high.
    assign mux_in[3] = c;
endmodule