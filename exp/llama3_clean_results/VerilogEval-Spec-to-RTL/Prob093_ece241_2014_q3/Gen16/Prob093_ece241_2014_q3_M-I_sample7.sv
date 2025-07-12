module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00
    assign mux_in[0] = (d ? 1'b1 : (c ? 1'b0 : 1'b0));

    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;

    // For ab = 11
    assign mux_in[2] = (c ? 1'b1 : (d ? 1'b1 : 1'b0));

    // For ab = 10
    assign mux_in[3] = (c ? 1'b1 : (d ? 1'b1 : 1'b0));
endmodule