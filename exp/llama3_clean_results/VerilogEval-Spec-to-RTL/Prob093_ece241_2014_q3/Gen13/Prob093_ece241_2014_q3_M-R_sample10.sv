module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d; // For ab = 00, output is 'd'
    assign mux_in[1] = c & ~d; // For ab = 01, corrected to depend on 'c' and 'd'
    assign mux_in[2] = c & d; // For ab = 11, both 'c' and 'd' must be '1'
    assign mux_in[3] = c; // For ab = 10, 'c' being '1' is the determining factor

endmodule