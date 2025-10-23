module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = ~c && d;  // For ab = 00, output is 1 when cd = 10
    assign mux_in[1] = c && d;   // For ab = 01, output is 1 only when cd = 11
    assign mux_in[2] = d;        // For ab = 11, output directly depends on d
    assign mux_in[3] = ~c && d;  // For ab = 10, output is 1 when cd = 10
endmodule