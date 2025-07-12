module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00
    assign mux_in[0] = (c && !d) ? 1'b0 : 1'b1;

    // For ab = 01
    assign mux_in[1] = c;

    // For ab = 11
    assign mux_in[2] = d;

    // For ab = 10
    assign mux_in[3] = (c || d) ? 1'b1 : 1'b0;
endmodule