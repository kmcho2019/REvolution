module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Logic for ab = 00, output is 1 only when cd = 10
    assign mux_in[0] = ~c & d;

    // Logic for ab = 01, output is 1 only when cd = 11
    assign mux_in[1] = c & d;

    // Logic for ab = 11, output is 1 when cd = 11 or cd = 10
    assign mux_in[2] = d;

    // Logic for ab = 10, output is 1 when cd = 01, cd = 11, or cd = 10
    assign mux_in[3] = c | d;
endmodule