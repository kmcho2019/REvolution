module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    // For ab = 00 (mux_in[0]), the output is always 0
    assign mux_in[0] = 0;

    // For ab = 01 (mux_in[1]), the output is always 0
    assign mux_in[1] = 0;

    // For ab = 11 (mux_in[2]), the output depends on 'c' and 'd'
    // Using a 2-to-1 multiplexer with 'c' as the selector and 'd' and 1 as inputs
    assign mux_in[2] = (c) ? d : 1;

    // For ab = 10 (mux_in[3]), the output depends on 'c' and 'd'
    // Since the output is the same as 'c', we can directly assign 'c' to mux_in[3]
    assign mux_in[3] = c;
endmodule