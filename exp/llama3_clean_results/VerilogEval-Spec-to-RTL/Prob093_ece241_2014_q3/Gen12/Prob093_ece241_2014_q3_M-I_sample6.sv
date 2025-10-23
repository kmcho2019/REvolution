module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 01, output is always 0
    assign mux_in[1] = 1'b0;

    // For ab = 00 and ab = 10, use a 2-to-1 multiplexer
    assign mux_in[0] = ~c & d;
    assign mux_in[3] = ~c & d;

    // For ab = 11, use a 2-to-1 multiplexer
    assign mux_in[2] = (c ? d : d);
endmodule