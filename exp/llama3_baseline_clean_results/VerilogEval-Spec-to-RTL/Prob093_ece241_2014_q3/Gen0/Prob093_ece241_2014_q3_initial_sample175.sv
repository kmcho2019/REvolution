module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexer for ab = 11 and ab = 10
    assign mux_in[3] = (c && d)? 1'b1 : 1'b0; // for ab = 11
    assign mux_in[2] = (c || (d == 1'b0))? 1'b1 : 1'b0; // for ab = 10

    // 2-to-1 multiplexers are not needed for ab = 01 and ab = 00
    assign mux_in[1] = 1'b0; // for ab = 01
    assign mux_in[0] = 1'b0; // for ab = 00

endmodule