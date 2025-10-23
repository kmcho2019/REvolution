module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d;  // For ab = 00, output is 'd'
    assign mux_in[1] = c;  // For ab = 01, output is 'c'

    // Use a 2-to-1 multiplexer for mux_in[2] and mux_in[3]
    assign mux_in[2] = d ? 1'b1 : c;  // For ab = 11, output is 'c' or 'd' based on 'd'
    assign mux_in[3] = d ? 1'b1 : c;  // For ab = 10, output is 'c' or 'd' based on 'd'

endmodule