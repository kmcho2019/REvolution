module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // For 'ab = 00', the output is 'd'
    assign mux_in[0] = d;

    // For 'ab = 01', the output is '0'
    assign mux_in[1] = 1'b0;

    // For 'ab = 11', the output is 'c'
    assign mux_in[2] = c;

    // For 'ab = 10', the output is 'd'
    assign mux_in[3] = d;
endmodule