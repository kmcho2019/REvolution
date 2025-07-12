module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = d; // For ab = 00, output depends directly on d
    assign mux_in[1] = 1'b0; // For ab = 01, output is always 0
    assign mux_in[2] = (c) ? 1'b1 : d; // For ab = 11, output is '1' when c=1, else depends on d
    assign mux_in[3] = (c) ? 1'b1 : d; // For ab = 10, output is '1' when c=1, else depends on d
endmodule