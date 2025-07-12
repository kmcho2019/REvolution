module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing the 4-to-1 multiplexer inputs using 2-to-1 multiplexers
    // mux_in[0] corresponds to ab = 00
    assign mux_in[0] = 0;

    // mux_in[1] corresponds to ab = 01
    assign mux_in[1] = 0;

    // mux_in[2] corresponds to ab = 11
    assign mux_in[2] = d ? 1 : c;

    // mux_in[3] corresponds to ab = 10
    assign mux_in[3] = c;
endmodule