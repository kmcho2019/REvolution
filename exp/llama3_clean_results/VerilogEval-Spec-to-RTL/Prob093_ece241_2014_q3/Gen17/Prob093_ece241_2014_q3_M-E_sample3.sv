module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = c ? d : 0; // For ab = 00, output is 'd' when c=1, otherwise 0
    assign mux_in[1] = c ? 0 : 0; // For ab = 01, output is always 0
    assign mux_in[2] = c ? d : 0; // For ab = 11, output is 'd' when c=1, otherwise 0
    assign mux_in[3] = c ? 1 : 0; // For ab = 10, output is '1' when c=1, otherwise 0

endmodule