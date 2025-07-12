module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Logic for ab = 00
    assign mux_in[0] = d;

    // Logic for ab = 01
    assign mux_in[1] = c && d;

    // Logic for ab = 11
    assign mux_in[2] = d;

    // Logic for ab = 10
    assign mux_in[3] = c || d;
endmodule