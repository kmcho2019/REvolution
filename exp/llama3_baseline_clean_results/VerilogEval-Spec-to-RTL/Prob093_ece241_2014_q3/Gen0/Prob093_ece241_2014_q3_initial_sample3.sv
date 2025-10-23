module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // 2-to-1 multiplexers
    // For ab = 00, 01, 10, and ab = 11 when c = 0
    assign mux_in[0] = d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = d;
    assign mux_in[3] = c ? 1'b1 : d;

endmodule