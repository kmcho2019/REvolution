module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d; // For ab = 00, output is directly d
    assign mux_in[1] = 1'b0; // For ab = 01, output is always 0
    assign mux_in[2] = c || d; // For ab = 11, output is 1 if c or d is 1
    assign mux_in[3] = c || d; // For ab = 10, output is 1 if c or d is 1

endmodule