module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = (d && !c); // For ab = 00, output is '1' when cd = 10, otherwise '0'
    assign mux_in[1] = 0; // For ab = 01, output is always '0'
    assign mux_in[2] = (c && (d || !d)); // For ab = 11, output is '1' when c = 1, regardless of d
    assign mux_in[3] = c; // For ab = 10, output is '1' when c = 1, regardless of d

endmodule