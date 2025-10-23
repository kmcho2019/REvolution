module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d; // For ab = 00, output is 'd'
    assign mux_in[1] = (c && !d) ? 1 : 0; // For ab = 01, output is '1' when c=1 and d=0
    assign mux_in[2] = (c && d) ? 1 : 0; // For ab = 11, output is '1' when both c and d are '1'
    assign mux_in[3] = c; // For ab = 10, output is '1' when c is '1'

endmodule