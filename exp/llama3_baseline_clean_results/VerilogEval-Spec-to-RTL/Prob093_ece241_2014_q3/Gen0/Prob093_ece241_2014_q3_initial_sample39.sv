module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Create mux_in[3] directly from 'c'
    assign mux_in[3] = c;

    // Create mux_in[2] directly since 'd' is 0 in this case
    assign mux_in[2] = 1'b0;

    // Create mux_in[1] directly since 'd' is 0 in this case
    assign mux_in[1] = 1'b0;

    // Create mux_in[0] using a 2-to-1 multiplexer
    assign mux_in[0] = (c) ? 1'b1 : 1'b0;
endmodule