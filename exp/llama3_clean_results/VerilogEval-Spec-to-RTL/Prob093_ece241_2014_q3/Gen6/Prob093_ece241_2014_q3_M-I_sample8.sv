module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 1 when cd = 10
    assign mux_in[0] = ~c & d;

    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;

    // For ab = 11, output is 1 when d is 1 (covers both cd = 11 and cd = 10)
    assign mux_in[2] = d;

    // For ab = 10, output is 1 when cd = 10
    assign mux_in[3] = ~c & d;
endmodule