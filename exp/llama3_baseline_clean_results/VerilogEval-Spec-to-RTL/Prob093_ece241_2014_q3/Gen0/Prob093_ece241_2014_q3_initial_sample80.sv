module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Generate the inputs for the 4-to-1 multiplexer using 2-to-1 multiplexers
    // For ab = 00, the output should be 'c'
    assign mux_in[0] = c;
    // For ab = 01, the output should be '0'
    assign mux_in[1] = 1'b0;
    // For ab = 11, the output should be 'd'
    assign mux_in[2] = d;
    // For ab = 10, the output should be 'c'
    assign mux_in[3] = c;
endmodule