module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexer to generate input pattern for 'ab' equals '10' or '11'
    assign mux_in[3] = d; // for ab = 00
    assign mux_in[2] = 1'b0; // for ab = 01
    assign mux_in[1] = d; // for ab = 11
    assign mux_in[0] = c; // for ab = 10

endmodule