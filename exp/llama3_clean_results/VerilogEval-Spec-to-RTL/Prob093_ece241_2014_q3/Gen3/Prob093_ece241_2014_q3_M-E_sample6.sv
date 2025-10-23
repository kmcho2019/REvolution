module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, the output is 1 when c is 1 or when c is 0 and d is 1.
    assign mux_in[0] = (c) | (~c & d);

    // For ab = 01, the output is 1 only when c is 0 and d is 1.
    assign mux_in[1] = (~c & d);

    // For ab = 11, the output is 1 when c is 1 and d is 1.
    assign mux_in[2] = c & d;

    // For ab = 10, the output is 1 when c is 1.
    assign mux_in[3] = c;
endmodule