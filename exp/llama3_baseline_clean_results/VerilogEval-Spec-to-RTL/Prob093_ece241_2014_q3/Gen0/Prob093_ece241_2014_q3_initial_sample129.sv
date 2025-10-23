module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // always 0
    assign mux_in[0] = 1'b0;
    assign mux_in[1] = 1'b0;

    // 'c' is the selector
    assign mux_in[2] = c;

    // 'd' is the output
    assign mux_in[3] = d;
endmodule