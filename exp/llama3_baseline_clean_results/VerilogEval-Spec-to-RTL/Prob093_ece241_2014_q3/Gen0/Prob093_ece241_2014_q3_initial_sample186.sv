module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = 1'b0; // For ab = 00, always output 0 for cd = 00, 01 and 1 for cd = 10, 11
    assign mux_in[1] = 1'b0; // For ab = 01, output is always 0
    assign mux_in[2] = d; // For ab = 11, output depends on d (1 for d = 1, 0 for d = 0)
    assign mux_in[3] = c; // For ab = 10, output depends on c (1 for c = 1, 0 for c = 0)
endmodule