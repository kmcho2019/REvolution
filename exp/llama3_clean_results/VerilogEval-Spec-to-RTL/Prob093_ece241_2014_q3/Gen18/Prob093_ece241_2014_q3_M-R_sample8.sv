module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For ab = 00, output is 'd'
    assign mux_in[0] = d;

    // For ab = 01, output is 'c'
    assign mux_in[1] = c;

    // For ab = 11 and ab = 10, output is 'c' or 'd' based on 'c'
    assign mux_in[2] = c ? 1'b1 : d;
    assign mux_in[3] = c ? 1'b1 : d;

    // But to correctly implement the k-map, mux_in[2] should be 'c' or 'd' based on 'd'
    // So use a 2-to-1 multiplexer for mux_in[2]
    wire temp_out;
    assign temp_out = c ? 1'b1 : d;
    assign mux_in[2] = d ? 1'b1 : temp_out;

    // Now the correct implementation is:
    assign mux_in[0] = d;
    assign mux_in[1] = c;
    assign mux_in[2] = d ? 1'b1 : (c ? 1'b1 : d);
    assign mux_in[3] = c ? 1'b1 : d;

endmodule