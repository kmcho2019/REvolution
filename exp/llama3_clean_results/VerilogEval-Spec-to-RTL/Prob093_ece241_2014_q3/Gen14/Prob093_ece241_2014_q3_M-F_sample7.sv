module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = 0; // For ab = 00, output is always '0'
    assign mux_in[1] = c & ~d; // For ab = 01, output is '1' when c is '1' and d is '0'
    assign mux_in[2] = c & d; // For ab = 11, output is '1' when both c and d are '1'
    assign mux_in[3] = c; // For ab = 10, output is '1' when c is '1'

endmodule